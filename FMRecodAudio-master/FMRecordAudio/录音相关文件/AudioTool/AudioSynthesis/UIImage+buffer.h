//
//  UIImage+buffer.h
//  qh-ios
//
//  Created by 皮皮虾 on 2019/4/25.
//  Copyright © 2019 皮皮虾. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CoreMedia/CMSampleBuffer.h>

@interface UIImage (buffer)


/**
 将UIImage转换为CVPixelBufferRef

 @param size 转化后的大小
 @return 返回CVPixelBufferRef
 */
- (CVPixelBufferRef)pixelBufferRefWithSize:(CGSize)size;


/**
 将CMSampleBufferRef转换为UIImage

 @param sampleBuffer  sampleBuffer数据
 @return 返回UIImage
 */
+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;


/**
 将CVPixelBufferRef转换为UIImage

 @param pixelBuffer pixelBuffer 数据
 @return 返回UIImage
 */
+ (UIImage*)imageFromPixelBuffer:(CVPixelBufferRef)pixelBuffer;
@end
