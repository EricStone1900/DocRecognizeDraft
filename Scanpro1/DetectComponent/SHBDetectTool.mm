//
//  SHBDetectTool.m
//  Scanpro1
//
//  Created by song on 2019/7/5.
//  Copyright © 2019 song. All rights reserved.
//

#import "SHBDetectTool.h"
#include <pthread.h>
#include <unistd.h>
#include <fstream>
#include <iostream>
#include <queue>
#include <sstream>
#include <string>

#import <tensorflow_lite/tensorflow/lite/kernels/register.h>
#import <tensorflow_lite/tensorflow/lite/model.h>
#import <tensorflow_lite/tensorflow/lite/string_util.h>
#import <tensorflow_lite/tensorflow/lite/op_resolver.h>
#include <vector>

#include "hedafterops.hpp"

//openCV
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>

//C++
//void __coverLineToPoint(std::vector<std::string> &lines,float * out ){
//    float *pout = out;
//    for(auto line:lines){
//        std::stringstream ss;
//        ss<<line;
//        std::string s;
//        while(std::getline(ss,s,',')){
//            *pout = atof(s.c_str());
//            ++pout;
//        }
//    }
//}

typedef struct {
    int width;
    int height;
    int channels;
    std::vector<uint8_t> data;
} image_data;

static SHBDetectTool* _instance = nil;
@interface SHBDetectTool() {
    std::vector<std::unique_ptr<tflite::FlatBufferModel>> modelList;
}
@end

@implementation SHBDetectTool
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHBDetectTool alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadModel:@"hed_mobile"];//边框识别模型
        [self loadModel:@"ctpn_quant"];
    }
    return self;
}

- (void)loadModel:(NSString *)modelName {
    NSString *graphPath = [self getFilepath:modelName extension:@"tflite"];
    if (graphPath == nil) {
        return;
    }
    std::unique_ptr<tflite::FlatBufferModel> model(
                                                   tflite::FlatBufferModel::BuildFromFile([graphPath UTF8String]));
    if (!model) {
        NSLog(@"Failed to mmap model %@.", modelName);
        exit(-1);
    }
    NSLog(@"Loaded model %@.", modelName);
    model->error_reporter();
    NSLog(@"Resolved reporter.");
    modelList.push_back(std::move(model));  
    
}

- (NSString *)getFilepath:(NSString*)name extension:(NSString*) extension {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    return filePath;
}

- (NSArray <NSValue *> *)runModel1:(UIImage *)image {//边框识别
    const int num_threads = 1;
    std::string input_layer_type = "float";
    std::vector<int> sizes = {1, 192, 160, 3};
    
#ifdef TFLITE_CUSTOM_OPS_HEADER
    tflite::MutableOpResolver resolver;
    RegisterSelectedOps(&resolver);
#else
    tflite::ops::builtin::BuiltinOpResolver resolver;
#endif
    std::unique_ptr<tflite::Interpreter> interpreter;
    //    std::unique_ptr<tflite::FlatBufferModel> model = std::move(modelList[0]);
    tflite::InterpreterBuilder(*modelList[0], resolver)(&interpreter);
    if (!interpreter) {
        NSLog(@"Failed to construct interpreter.");
        exit(-1);
    }
    
    if (num_threads != -1) {
        interpreter->SetNumThreads(num_threads);
    }
    
    int input = interpreter->inputs()[0];
    
    if (input_layer_type != "string") {
        interpreter->ResizeInputTensor(input, sizes);
    }
    
    if (interpreter->AllocateTensors() != kTfLiteOk) {
        NSLog(@"Failed to allocate tensors.");
        exit(-1);
    }
    UIImage *convImage = image;
    image_data theImge = [self CGImageToPixels:convImage.CGImage];
    int image_width = theImge.width;
    int image_height = theImge.height;
    int image_channels = theImge.channels;
    const int wanted_width = 160;//400
    const int wanted_height = 192;//320
    const int wanted_channels = 3;
    assert(image_channels >= wanted_channels);
    uint8_t* in = theImge.data.data();
    float* out = interpreter->typed_tensor<float>(input);
    for (int y = 0; y < wanted_height; ++y) {
        const int in_y = (y * image_height) / wanted_height;
        uint8_t* in_row = in + (in_y * image_width * image_channels);
        float* out_row = out + (y * wanted_width * wanted_channels);
        for (int x = 0; x < wanted_width; ++x) {
            const int in_x = (x * image_width) / wanted_width;
            uint8_t* in_pixel = in_row + (in_x * image_channels);
            float* out_pixel = out_row + (x * wanted_channels);
            for (int c = 0; c < wanted_channels; ++c) {
                if (c==0) {//r
                    out_pixel[c] = in_pixel[2] - 102.98f;
                }else if (c == 1) {//g
                    out_pixel[c] = in_pixel[c] - 115.95f;
                }else if (c == 2) {//b
                    out_pixel[c] = in_pixel[0] - 122.77f;
                }
            }
        }
    }
    
    if (interpreter->Invoke() != kTfLiteOk) {
        NSLog(@"Failed to invoke!");
        exit(-1);
    }
    
    float* output = interpreter->typed_output_tensor<float>(0);
    
    unsigned char *pedge_image = (unsigned char * )malloc(wanted_height*wanted_width*sizeof(unsigned char));
    
    for (int i = 0; i< wanted_height*wanted_width; i++) {
        float boxf = output[i];
        pedge_image[i] = (unsigned char)(boxf * 255);
        
    }
    
    //计算框
    cv::Mat edgeMat(cv::Size(wanted_width, wanted_height), CV_8UC1);
    cv::Mat colorMat(cv::Size(wanted_width, wanted_height), CV_8UC3);
    //尺寸接口
    int shape_pedge[3];
    static_cast<void>(shape_pedge[0] = wanted_height), static_cast<void>(shape_pedge[1] = wanted_width), shape_pedge[2] = 1;
    //赋值
    __copyArrayToMat((unsigned char *) pedge_image, shape_pedge, edgeMat);
    
    cv::Mat colorMat_ori;
    colorMat.copyTo(colorMat_ori);
    cv::resize(colorMat, colorMat, edgeMat.size());
    //调用核心
    std::tuple<bool, std::vector<cv::Point>, std::vector<cv::Mat> > res = ProcessEdgeImage(edgeMat,
                                                                                           cv::Mat(),
                                                                                           false);
    NSMutableArray <NSValue *>*resultArr = [NSMutableArray array];
    bool isfind = std::get<0>(res);
    if (isfind) {
        std::vector<cv::Point> points = std::get<1>(res);
        for (int i = 0; i < 4; ++i) {
            CGPoint point = CGPointMake(points[i].x, points[i].y);
            NSValue *pointValue = [NSValue valueWithCGPoint:point];
            [resultArr addObject:pointValue];
        }
    }
    
    free(pedge_image);
    return [resultArr copy];
}

#pragma private

- (image_data)CGImageToPixels:(CGImage *)image {
    image_data result;
    result.width = (int)CGImageGetWidth(image);
    result.height = (int)CGImageGetHeight(image);
    //    result.channels = 1;
    result.channels = 4;
    
    CGColorSpaceRef color_space = CGColorSpaceCreateDeviceRGB();
    const int bytes_per_row = (result.width * result.channels);
    const int bytes_in_image = (bytes_per_row * result.height);
    result.data = std::vector<uint8_t>(bytes_in_image);
    const int bits_per_component = 8;
    
    CGContextRef context = CGBitmapContextCreate(result.data.data(), result.width, result.height, bits_per_component, bytes_per_row,
                                                 color_space, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(color_space);
    CGContextDrawImage(context, CGRectMake(0, 0, result.width, result.height), image);
    CGContextRelease(context);
    
    return result;
}

//自定长宽
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}


#pragma mark publics
- (void)getImgFramePoints:(UIImage *)image completed:(void (^)(NSArray <NSValue *>* points))completed {
    if (image != nil) {
        //按模型规则化图片
        UIImage *convImage = [self reSizeImage:image toSize:CGSizeMake(160, 192)];
        //获取图片中文档外框
        NSArray <NSValue *>* pointArr = [self runModel1:convImage];
        completed(pointArr);
        
    }else {
        completed(nil);
    }
}

//- (void)getImgFrameWithImage:(UIImage *)image completed:(void (^)(NSArray <NSValue *>* points, UIImage *cropImg))completed {
//    if (image != nil) {
//        //按模型规则化图片
//        UIImage *convImage = [self reSizeImage:image toSize:CGSizeMake(160, 192)];
//        //获取图片中文档外框
//        NSArray <NSValue *>* pointArr = [self runModel1:convImage];
//        UIImage *cropImg = [[UIImage alloc] init];
//        completed(pointArr,cropImg);
//        
//    }else {
//        completed(nil,nil);
//    }
//}

- (UIImage *)getFrameImage:(UIImage *)image pointArr:(NSArray <NSValue *>*)pointArr {
    cv::Mat cvImage;
    UIImageToMat(image, cvImage);
    CGFloat wScale = image.size.width/160.0;
    CGFloat hScale = image.size.height/192.0;
    
    NSValue *leftUpValue = pointArr[0];
    NSValue *rightUpValue = pointArr[1];
    NSValue *rightDownValue = pointArr[2];
    NSValue *leftDownValue = pointArr[3];
    CGFloat upWidth = rightUpValue.CGPointValue.x - leftUpValue.CGPointValue.x;
    CGFloat downWidth = rightDownValue.CGPointValue.x - leftDownValue.CGPointValue.x;
    CGFloat leftheight = leftDownValue.CGPointValue.y - leftUpValue.CGPointValue.y;
    CGFloat rightheight = rightDownValue.CGPointValue.y - rightUpValue.CGPointValue.y;
    CGFloat frameWidth = upWidth - downWidth > 0 ? upWidth*wScale : downWidth*wScale;
    CGFloat frameHeight = leftheight - rightheight > 0 ? leftheight*hScale : rightheight*hScale;
    
    std::vector<cv::Point2f> corners;
    for (int i=0; i<pointArr.count;i++) {
        NSValue *pointValue = pointArr[i];
        CGPoint point = pointValue.CGPointValue;
        cv::Point2f pt;
        pt.x = point.x*wScale;
        pt.y = point.y*hScale;
        corners.push_back(pt);
    }
    
    cv::Mat theCV = getAffImageTest2(cvImage, corners,frameWidth,frameHeight);
    UIImage *myImg = MatToUIImage(theCV);
    return myImg;
}
@end
