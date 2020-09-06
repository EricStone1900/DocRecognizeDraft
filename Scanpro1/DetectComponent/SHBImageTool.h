//
//  SHBImageTool.h
//  Scanpro1
//
//  Created by song on 2019/7/24.
//  Copyright © 2019 song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SHBImageTool : NSObject
+ (UIImage *)covertContrastImage:(UIImage *)image;
//三种灰度方法
+ (UIImage *)convertGrayImage:(UIImage *)image;
+ (UIImage *)systemImageToGrayImage:(UIImage *)image;
+ (UIImage *)GrayDealPicture:(UIImage *)image;
//黑白二值
+ (UIImage *)convertBlackWhiteImage:(UIImage *)image;

//亮度
+ (UIImage *)adjustBrighterImage:(UIImage *)image brightValue:(CGFloat)value;
@end

NS_ASSUME_NONNULL_END
