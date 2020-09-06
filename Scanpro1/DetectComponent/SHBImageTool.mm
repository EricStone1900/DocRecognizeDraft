//
//  SHBImageTool.m
//  Scanpro1
//
//  Created by song on 2019/7/24.
//  Copyright © 2019 song. All rights reserved.
//

#import "SHBImageTool.h"
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/opencv.hpp>
using namespace cv;
@implementation SHBImageTool
+ (UIImage *)covertContrastImage:(UIImage *)image {
    double alpha = 2.2; //控制对比度
    double beta = 50; //控制亮度
    Mat originImage; //原图
    Mat new_Image; //新图
    UIImageToMat(image, originImage);
    originImage.convertTo(new_Image, -1,alpha,beta);
    UIImage *endImage = MatToUIImage(new_Image);
    return endImage;
}

+ (UIImage*)convertGrayImage:(UIImage*)image {
    Mat originImage; //原图
    Mat gray;
    UIImageToMat(image, originImage);
    extractChannel(originImage, gray, 3);
    UIImage *endImage = MatToUIImage(gray);
    return endImage;
}

// 灰度处理
+ (UIImage*)GrayDealPicture:(UIImage*)image{
    Mat originImage; //原图
    Mat new_Image; //新图
    UIImageToMat(image, originImage);
    cvtColor(originImage, new_Image, CV_RGB2GRAY);
    UIImage *endImage = MatToUIImage(new_Image);
    return endImage;
}


#pragma mark - 采用系统自带的库进行实现

+ (UIImage*)systemImageToGrayImage:(UIImage*)image{
    
    int width  = image.size.width;
    
    int height = image.size.height;
    
    //第一步：创建颜色空间(说白了就是开辟一块颜色内存空间)
    
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceGray();
    
    
    //第二步：颜色空间上下文(保存图像数据信息)
    
    //参数一：指向这块内存区域的地址（内存地址）
    
    //参数二：要开辟的内存的大小，图片宽
    
    //参数三：图片高
    
    //参数四：像素位数(颜色空间，例如：32位像素格式和RGB的颜色空间，8位）
    
    //参数五：图片的每一行占用的内存的比特数
    
    //参数六：颜色空间
    
    //参数七：图片是否包含A通道（ARGB四个通道）
    
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, 0, colorRef, kCGImageAlphaNone);
    
    //释放内存
    
    CGColorSpaceRelease(colorRef);
    
    
    if (context == nil) {
        
        return  nil;
        
    }
    
    
    //渲染图片
    
    //参数一：上下文对象
    
    //参数二：渲染区域
    
    //源图片
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);;
    
    
    //将绘制的颜色空间转成CGImage
    
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    
    
    //将c/c++图片转成iOS可显示的图片
    
    UIImage *dstImage = [UIImage imageWithCGImage:grayImageRef];
    
    
    //释放内存
    
    CGContextRelease(context);
    
    CGImageRelease(grayImageRef);
    
    
    return dstImage;
    
}

//- (UIImage*)imageToGrayImage:(UIImage*)image{
//    
//    
//    //image源文件
//    
//    // 1.将iOS的UIImage转成c++图片（数据：矩阵）
//    
//    Mat mat_image_gray;
//    
//    UIImageToMat(image, mat_image_gray);
//    
//    
//    // 2. 将c++彩色图片转成灰度图片
//    
//    // 参数一：数据源
//    
//    // 参数二：目标数据
//    
//    // 参数三：转换类型
//    
//    Mat mat_image_dst;
//    
//    
////    cvtColor(mat_image_gray, mat_image_dst, cv::COLOR_BGRA2GRAY);
////
////
////    // 3.灰度 -> 可显示的图片
////
////    cvtColor(mat_image_dst, mat_image_gray, COLOR_GRAY2BGR);
//    
//    cvtColor(mat_image_gray, mat_image_dst, CV_BGRA2GRAY);
//    
//    
//    // 3.灰度 -> 可显示的图片
//    
//    cvtColor(mat_image_dst, mat_image_gray, CV_GRAY2BGR);
//    
//    
//    // 4. 将c++处理之后的图片转成iOS能识别的UIImage
//    
//    return MatToUIImage(mat_image_gray);
//    
//}

+ (UIImage*)convertBlackWhiteImage:(UIImage*)image {
    Mat originImage; //原图
    Mat grayImage; //灰度图
    Mat new_Image;
    UIImageToMat(image, originImage);
    cvtColor(originImage, grayImage, CV_RGB2GRAY);
    
//    adaptiveThreshold(grayImage, new_Image, 255, CV_ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY, 31, 40);
        adaptiveThreshold(grayImage, new_Image, 255, CV_ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY, 31, 10);
    //自适应
    UIImage *endImage = MatToUIImage(new_Image);
    return endImage;
}

+ (UIImage *)adjustBrighterImage:(UIImage *)image brightValue:(CGFloat)value {
    UIImage *brighterImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];

    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:inputImage forKey:kCIInputImageKey];
    [lighten setValue:@(-0.5) forKey:@"inputBrightness"];

    CIImage *result = [lighten valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    brighterImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return brighterImage;
    
//    double alpha = 1; //控制对比度
//    double beta = 1; //控制亮度
//    Mat originImage; //原图
//    Mat new_Image; //新图
//    UIImageToMat(image, originImage);
//    originImage.convertTo(new_Image, -1,alpha,beta);
//    UIImage *endImage = MatToUIImage(new_Image);
//    return endImage;
}

@end
