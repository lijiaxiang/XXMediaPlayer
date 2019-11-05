//
//  UIImage+SNFoundation.m
//  SNFoundation
//
//  Created by liukun on 14-3-2.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import "UIImage+SNFoundation.h"

#define kImageSNFoundataion_isFloatEqual(_a,_b)        (fabs((double)(_a) - (double)(_b)) < DBL_EPSILON)

@implementation UIImage (SNFoundation)

+ (UIImage *)noCacheImageNamed:(NSString *)imageName
{
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@",
                           [[NSBundle mainBundle] resourcePath], imageName];
    return [[UIImage alloc] initWithContentsOfFile:imageFile];
}

+ (UIImage *)streImageNamed:(NSString *)imageName
{
    if (imageName == nil)
    {
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *streImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    
    return streImage;
}

+ (UIImage *)streImageNamed:(NSString *)imageName capX:(CGFloat)x capY:(CGFloat)y
{
    if (imageName == nil)
    {
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *streImage = [image stretchableImageWithLeftCapWidth:x topCapHeight:y];
    
    return streImage;
}

- (UIImage *)stretched
{
	CGFloat leftCap = floorf(self.size.width / 2.0f);
	CGFloat topCap = floorf(self.size.height / 2.0f);
    
	return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (UIImage *)grayscale
{
	CGSize size = self.size;
	CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
	CGColorSpaceRelease(colorSpace);
	
	CGContextDrawImage(context, rect, [self CGImage]);
	CGImageRef grayscale = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	UIImage * image = [UIImage imageWithCGImage:grayscale];
	CFRelease(grayscale);
	
	return image;
}

- (UIColor *)patternColor
{
	return [UIColor colorWithPatternImage:self];
}

///画圆角
- (UIImage *)drawRectWithRoundedCornerWithSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius
{
    CGRect rect = (CGRect){0.f, 0.f, sizeToFit};
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
}


#pragma mark -- 

//生成圆角图片
- (UIImage *)imageWithSize:(CGSize)size corner:(CGFloat)corner
{
    CGRect rect = (CGRect){0.f, 0.f, size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:corner].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

//将图片处理成圆形
+ (UIImage *)circleImage:(UIImage*) image
{
    return [[self class] circleImage:image withParam:0];
}

+ (UIImage *)imageWithScrollView:(UIScrollView *)scrollView
{
    UITableView * tableView = (UITableView *)scrollView;
    [tableView.tableFooterView removeFromSuperview];
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, NO, 0.0);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    return image;
}

//将图片处理成圆形
+ (UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    //    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

///使用颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(6.0f, 6.0f)];
}

///使用颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//UIView转换为UIImage
+ (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resImage;
}

///扇形的遮罩图片
+ (UIImage *)imageWithMaskFrame:(CGRect)frame  process:(float)process
{
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //扇形参数
    double radius; //半径
    if(frame.size.width>frame.size.height){
        radius = frame.size.height/2;
    }else{
        radius = frame.size.width/2;
    }
    double startX = frame.size.width/2;       //圆心x坐标
    double startY = frame.size.height/2;      //圆心y坐标
    double pieStart = -90;                    //起始的角度
    double pieCapacity = 360.0f*process;      //角度增量值
    int clockwise = 0;                        //0=顺时针, 1=逆时针
    
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    CGContextSetLineWidth(context, 0);
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddArc(context, startX, startY, radius, (M_PI * (pieStart) / 180.0), (M_PI * (pieCapacity) / 180.0) , clockwise);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}

///将一个指定的图形放大或缩小为指定的size
- (UIImage *)scale:(CGFloat)scale
{
    // 创建一个bitmap的context

    // 并把它设置成为当前正在使用的context
    CGSize size = CGSizeMake(self.size.width * scale, self.size.height * scale);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

///按比例缩放以适应一个size
- (UIImage *)fitSize:(CGSize)size
{
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        return self;
    }
    else if (self.size.width > size.width ||
             self.size.height > size.height)
    {
        CGFloat scale = MIN(size.width / self.size.width, size.height / self.size.height);
        return [self scale:scale];
    }
    else
    {
        return self;
    }
}

///拉升图片到某个大小
- (UIImage *)aspectFillSize:(CGSize)size
{
    if (!kImageSNFoundataion_isFloatEqual(self.size.width, size.width) ||
        !kImageSNFoundataion_isFloatEqual(self.size.height, size.height))
    {
        CGFloat scale = MAX(size.width / self.size.width, size.height / self.size.height);
        return [self scale:scale];
    }
    else
    {
        return self;
    }
}

///从中间截取特定大小
- (UIImage *)cropSize:(CGSize)size
{
    if (self.size.width < size.width ||
        self.size.height < size.height)
    {
        return self;
    }
    else
    {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        [self drawInRect:CGRectMake((size.width - self.size.width) * 0.5, (size.height - self.size.height) * 0.5, self.size.width, self.size.height)];
        UIImage *cropImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return cropImage;
    }
}

///从中间裁取一个正方形
- (UIImage *)squareImage
{
    if (kImageSNFoundataion_isFloatEqual(self.size.width, self.size.height))
    {
        return self;
    }
    else
    {
        CGFloat width = MIN(self.size.width, self.size.height);
        CGSize size = CGSizeMake(width, width);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        CGFloat delta = 0;
        if (self.size.width > self.size.height)
        {
            delta = (self.size.width - self.size.height) * 0.5;
            [self drawInRect:CGRectMake(- delta, 0, self.size.width, self.size.height)];
        }
        else
        {
            delta = (self.size.height - self.size.width) * 0.5;
            [self drawInRect:CGRectMake(0, - delta, self.size.width, self.size.height)];
        }
        
        UIImage *squareImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return squareImage;
    }
}

///将图片处理成圆形
- (UIImage *)circleImageWithInset:(CGFloat)inset
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    //    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, self.size.width - inset * 2.0f, self.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [self drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

///计算一个图片的平均颜色
- (UIColor *)averageColor
{
    CGSize size = {1, 1};
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
    [self drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];
    uint8_t *data = CGBitmapContextGetData(ctx);
    UIColor *color = [UIColor colorWithRed:data[0] / 255.f green:data[1] / 255.f blue:data[2] / 255.f alpha:1];
    UIGraphicsEndImageContext();
    
    return color;
}

///设备的分辨率倍数
+ (CGFloat)sysScale
{
    return [[UIScreen mainScreen] scale];
}

-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    
    return smallImage;
}


#pragma mark - 图片剪裁
#pragma mark --

///将图片压缩到最大20k进行显示 ,[UIImage scaleImage:image maxDataSize:1024 * 20];
+ (UIImage *)scaleImage:(UIImage *)image maxDataSize:(NSUInteger)dataSize
{
    if (image)
    {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        if (imageData.length > dataSize)
        {
            float scaleSize = (dataSize/1.0)/(imageData.length);
            scaleSize = 0.9 * sqrtf(scaleSize);
          
            return [self scaleImage:image toScale:scaleSize maxDataSize:dataSize];
        }
        else
        {
            return image;
        }
    }
    else
    {
        return nil;
    }
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize maxDataSize:(NSUInteger)dataSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize - 1, image.size.height * scaleSize - 1));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData* imageData = UIImageJPEGRepresentation(scaledImage, 1.0);
    if (imageData.length > dataSize)
    {
        float scale = (dataSize / 1.0) / (imageData.length);
        scale = 0.9 * sqrtf(scale);
        
        return [self scaleImage:scaledImage toScale:scale maxDataSize:dataSize];
    }
    
    return scaledImage;
}

/**
 *  裁剪图片
 *  @param clipSize  实际需要剪裁的size，会自动根据scale放大
 */
- (UIImage *)clipSize:(CGSize)clipSize
{
    ///clipRect.size 使我们要生成的大小
    /// 会根据这个scale放大
    UIGraphicsBeginImageContextWithOptions(clipSize, NO, [UIScreen mainScreen].scale);
    
    CGRect clipRect = CGRectMake(0, 0, clipSize.width, clipSize.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:clipRect];
    [path addClip];
    
    [self drawInRect:clipRect];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImg;
}


#pragma mark - 使用blend改变图片颜色
#pragma mark --

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeMultiply];//kCGBlendModeMultiply kCGBlendModeOverlay
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn)
    {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

@end
