//
//  SHBDetectTool.h
//  Scanpro1
//
//  Created by song on 2019/7/5.
//  Copyright © 2019 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SHBDetectTool : NSObject
+(instancetype)shareInstance;
//检测返回文档边框4个角点
- (void)getImgFramePoints:(UIImage *)image completed:(void (^)(NSArray <NSValue *>* points))completed;

//- (void)getImgFrameWithImage:(UIImage *)image completed:(void (^)(NSArray <NSValue *>* points, UIImage *cropImg))completed;

//透视变换，根据原图图片，检测点位进行透视变换返回4角内透视变换图片
//image - 原图 pointArr -image 中检测出来的4个文档角
- (UIImage *)getFrameImage:(UIImage *)image pointArr:(NSArray <NSValue *>*)pointArr;

//获取图片中所有文字行坐标（每行4角点）
- (NSArray *)getImageTextPoints:(UIImage *)image;


@end

NS_ASSUME_NONNULL_END
