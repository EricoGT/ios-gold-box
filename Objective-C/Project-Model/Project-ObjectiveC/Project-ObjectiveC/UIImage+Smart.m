//
//  UIImage+Smart.m
//  Project-ObjectiveC
//
//  Created by Erico Teixeira - Terceiro on 24/04/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "UIImage+Smart.h"
#import <ImageIO/ImageIO.h>

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif

@implementation UIImage (Smart)

#pragma mark - Commum

+ (UIImage * _Nullable) decodeBase64StringToImage:(NSString * _Nonnull)base64string
{
    if (base64string != nil && ![base64string isEqualToString:@""]){
        NSData *data;
        @try {
            data = [[NSData alloc]initWithBase64EncodedString:base64string options:NSDataBase64DecodingIgnoreUnknownCharacters];
        } @catch (NSException *exception) {
            NSLog(@"UIImage+Smart >> Error >> decodedBase64StringToImage: >> %@", [exception reason]);
        }
        return data ? [UIImage imageWithData:data] : nil;
    }else{
        return nil;
    }
}

- (NSString * _Nullable) encodeImageToBase64String
{
    NSData *iData = UIImagePNGRepresentation(self);
    NSString *base64;
    @try {
        base64 = [iData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    } @catch (NSException *exception) {
        NSLog(@"UIImage+Smart >> Error >> encodedImageToBase64String: >> %@", [exception reason]);
    }
    return base64 ? base64 : nil;
}

- (UIImage *_Nonnull)clone
{
    if (self.images.count > 1){
        UIImage *animationImage = [UIImage animatedImageWithImages:self.images duration:self.duration];
        return animationImage;
    }else{
        NSData *iData = UIImagePNGRepresentation(self);
        UIImage *image = [UIImage imageWithData:iData];
        return image;
    }
}

#pragma mark - Animation

static int delayCentisecondsForImageAtIndex(CGImageSourceRef const source, size_t const i) {
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
    if (properties) {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        if (gifProperties) {
            NSNumber *number = fromCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
            if (number == NULL || [number doubleValue] == 0) {
                number = fromCF CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            }
            if ([number doubleValue] > 0) {
                // Even though the GIF stores the delay as an integer number of centiseconds, ImageIO “helpfully” converts that to seconds for us.
                delayCentiseconds = (int)lrint([number doubleValue] * 100);
            }
        }
        CFRelease(properties);
    }
    return delayCentiseconds;
}

static void createImagesAndDelays(CGImageSourceRef source, size_t count, CGImageRef imagesOut[count], int delayCentisecondsOut[count]) {
    for (size_t i = 0; i < count; ++i) {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = delayCentisecondsForImageAtIndex(source, i);
    }
}

static int sum(size_t const count, int const *const values) {
    int theSum = 0;
    for (size_t i = 0; i < count; ++i) {
        theSum += values[i];
    }
    return theSum;
}

static int pairGCD(int a, int b) {
    if (a < b)
        return pairGCD(b, a);
    while (true) {
        int const r = a % b;
        if (r == 0)
            return b;
        a = b;
        b = r;
    }
}

static int vectorGCD(size_t const count, int const *const values) {
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i) {
        // Note that after I process the first few elements of the vector, `gcd` will probably be smaller than any remaining element.  By passing the smaller value as the second argument to `pairGCD`, I avoid making it swap the arguments.
        gcd = pairGCD(values[i], gcd);
    }
    return gcd;
}

static NSArray *frameArray(size_t const count, CGImageRef const images[count], int const delayCentiseconds[count], int const totalDurationCentiseconds) {
    int const gcd = vectorGCD(count, delayCentiseconds);
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        UIImage *const frame = [UIImage imageWithCGImage:images[i]];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
            frames[f++] = frame;
        }
    }
    return [NSArray arrayWithObjects:frames count:frameCount];
}

static void releaseImages(size_t const count, CGImageRef const images[count]) {
    for (size_t i = 0; i < count; ++i) {
        CGImageRelease(images[i]);
    }
}

static UIImage *animatedImageWithAnimatedGIFImageSource(CGImageSourceRef const source) {
    size_t const count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delayCentiseconds[count]; // in centiseconds
    createImagesAndDelays(source, count, images, delayCentiseconds);
    int const totalDurationCentiseconds = sum(count, delayCentiseconds);
    NSArray *const frames = frameArray(count, images, delayCentiseconds, totalDurationCentiseconds);
    UIImage *const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    releaseImages(count, images);
    return animation;
}

static UIImage *animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceRef CF_RELEASES_ARGUMENT source) {
    if (source) {
        UIImage *const image = animatedImageWithAnimatedGIFImageSource(source);
        CFRelease(source);
        return image;
    } else {
        return nil;
    }
}

+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)data {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithData(toCF data, NULL));
}

+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)url {
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithURL(toCF url, NULL));
}

+ (UIImage * _Nullable)animatedImageWithImages:(NSArray<UIImage *> * _Nonnull)images durations:(NSArray<NSNumber *> * _Nonnull)durations {
    
    if (images.count != durations.count){
        return nil;
    }
    
    int count = (int)images.count;
    
    int delayCentiseconds[count];
    int totalDurationCentiseconds = 0;
    for (size_t i = 0; i < count; ++i) {
        delayCentiseconds[i] = [durations[i] intValue];
        totalDurationCentiseconds += delayCentiseconds[i];
    }
    
    int const gcd = vectorGCD(count, delayCentiseconds);
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i) {
        UIImage *const frame = [UIImage imageWithCGImage:images[i].CGImage];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j) {
            frames[f++] = frame;
        }
    }
    NSArray *iArray = [NSArray arrayWithObjects:frames count:frameCount];
    
    UIImage *finalImage = [UIImage animatedImageWithImages:iArray duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    
    return finalImage;
    
}

- (BOOL)isAnimated
{
    if (self.images.count > 1){
        return YES;
    }
    return NO;
}

#pragma mark - Transforms

- (UIImage * _Nullable)imageOrientedToUP
{
    if (self.imageOrientation == UIImageOrientationUp || self.CGImage == nil || (self.size.width == 0 || self.size.height == 0)) {
        return self;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default: break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            // CORRECTION: Need to assign to transform here
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            // CORRECTION: Need to assign to transform here
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default: break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height, CGImageGetBitsPerComponent(self.CGImage), CGImageGetBytesPerRow(self.CGImage), CGImageGetColorSpace(self.CGImage), kCGImageAlphaPremultipliedLast);
    
    CGContextConcatCTM(ctx, transform);
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    
    return [UIImage imageWithCGImage:cgImage];
}

- (UIImage * _Nullable)imageRotatedClockwise
{
    return [self imageRotatedByDegrees:90.0];
}

- (UIImage * _Nullable)imageRotatedCounterClockwise
{
    return [self imageRotatedByDegrees:-90.0];
}

- (UIImage * _Nullable)imageRotatedByDegrees:(CGFloat)degrees
{
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0)) {
        return self;
    }
    
    CGFloat rotation = [self DegreesToRadians:degrees];
    
    // Calculate Destination Size
    CGAffineTransform t = CGAffineTransformMakeRotation(rotation);
    CGRect sizeRect = (CGRect) {.size = self.size};
    CGRect destRect = CGRectApplyAffineTransform(sizeRect, t);
    CGSize destinationSize = destRect.size;
    
    // Draw image
    UIGraphicsBeginImageContext(destinationSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, destinationSize.width / 2.0f, destinationSize.height / 2.0f);
    CGContextRotateCTM(context, rotation);
    [self drawInRect:CGRectMake(-self.size.width / 2.0f, -self.size.height / 2.0f, self.size.width, self.size.height)];
    
    // Save image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage * _Nullable)imageFlippedHorizontally
{
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0)) {
        return self;
    }
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:self];
    ciImage = [ciImage imageByApplyingTransform:transform];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:ciImage fromRect:[ciImage extent]];
    
    UIImage *flippedImage = [UIImage imageWithCGImage:cgimg];
    
    return flippedImage;
}

- (UIImage * _Nullable)imageFlippedVertically
{
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0)) {
        return self;
    }
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:self];
    ciImage = [ciImage imageByApplyingTransform:transform];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:ciImage fromRect:[ciImage extent]];
    
    UIImage *flippedImage = [UIImage imageWithCGImage:cgimg];
    
    return flippedImage;
}

- (UIImage * _Nullable) resizedImageToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //
    return newImage;
}

- (UIImage * _Nullable) resizedImageToScale:(CGFloat)newScale
{
    CGSize newSize = CGSizeMake(self.size.width * newScale, self.size.height * newScale);
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //
    return newImage;
}


- (UIImage * _Nullable) resizedImageToViewFrame:(CGSize)frameSize
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat ratio = width / height;
    //
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat maxWidth = frameSize.width * scale;
    CGFloat maxHeight = frameSize.height * scale;
    //
    if (width > maxWidth){
        width = maxWidth;
        height = width / ratio;
    }else if(height > maxHeight){
        height = maxHeight;
        width = height * ratio;
    }
    //
    CGSize newSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //
    return newImage;
}

- (UIImage * _Nullable) cropImageUsingFrame:(CGRect)frame
{
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0)) {
        return self;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, frame);
    UIImage* outImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    //
    return outImage;
}

- (UIImage * _Nullable) circularCropImageUsingFrame:(CGRect)frame
{
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2
    
    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;
    
    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [self drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Effects

- (UIImage * _Nullable) applyFilter:(NSString * _Nonnull)filterName usingParameters:(NSDictionary * _Nullable)parameters
{
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0)) {
        return self;
    }
    
    CIImage* ciImage = [CIImage imageWithCGImage:self.CGImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    //
    CIFilter *ciFilter = [CIFilter filterWithName:filterName];
    [ciFilter setValue:ciImage forKey:kCIInputImageKey];
    //
    if(parameters){
        @try {
            [ciFilter setValuesForKeysWithDictionary:parameters];
        } @catch (NSException *exception) {
            NSLog(@"UIImage+Smart >> Error >> applyFilter:usingParameters: >> %@", [exception reason]);
        }
    }
    //
    CIImage *outputImage = [ciFilter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(cgimg);
    context = nil;
    //
    return newImage;
}

- (UIImage * _Nullable) compressImageUsingQuality:(CGFloat)quality
{
    CGFloat q = (quality < 0.0) ? 0.0 : ((quality > 1.0 ? 1.0 : quality));
    
    if (q == 1.0){
        //Lossless compression
        NSData *iData = UIImagePNGRepresentation(self);
        UIImage *image = [UIImage imageWithData:iData];
        return image;
    }else{
        //Lossy compression (remove transparency)
        NSData *iData = UIImageJPEGRepresentation(self, q);
        UIImage *image = [UIImage imageWithData:iData];
        return image;
    }
}

- (UIImage * _Nullable) mergeImageAbove:(UIImage * _Nonnull)aboveImage inPosition:(CGPoint)position blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha scale:(CGFloat)superImageScale
{
    CGFloat widthB = self.size.width;
    CGFloat heightB = self.size.height;
    CGSize baseSize = CGSizeMake(widthB, heightB);
    //
    CGFloat widthS = aboveImage.size.width * superImageScale;
    CGFloat heightS = aboveImage.size.height * superImageScale;
    CGSize superSize = CGSizeMake(widthS, heightS);
    
    UIGraphicsBeginImageContext(baseSize);
    
    //Desenhando a imagem base:
    [self drawInRect:CGRectMake(0, 0, baseSize.width, baseSize.height)];
    
    //Desenhando a imagem superior:
    [aboveImage drawInRect:CGRectMake(position.x, position.y, superSize.width, superSize.height) blendMode:blendMode alpha:alpha];
    
    //Obtendo a imagem final:
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage * _Nullable) mergeImageBelow:(UIImage * _Nonnull)belowImage inPosition:(CGPoint)position blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha scale:(CGFloat)superImageScale
{
    CGFloat widthB = belowImage.size.width;
    CGFloat heightB = belowImage.size.height;
    CGSize baseSize = CGSizeMake(widthB, heightB);
    //
    CGFloat widthS = self.size.width * superImageScale;
    CGFloat heightS = self.size.height * superImageScale;
    CGSize subSize = CGSizeMake(widthS, heightS);
    
    UIGraphicsBeginImageContext(baseSize);
    
    //Desenhando a imagem inferior:
    [belowImage drawInRect:CGRectMake(0, 0, baseSize.width, baseSize.height)];
    
    //Desenhando a imagem superior:
    [self drawInRect:CGRectMake(position.x, position.y, subSize.width, subSize.height) blendMode:blendMode alpha:alpha];
    
    //Obtendo a imagem final:
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage * _Nullable) maskWithImage:(UIImage * _Nonnull)maskImage
{
    if (self.CGImage == nil || maskImage.CGImage == nil) {
        return self;
    }
    
    CGImageRef imageReference = self.CGImage;
    CGImageRef maskReference = maskImage.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    return maskedImage;
}

#pragma mark - Utils

- (CGFloat)DegreesToRadians:(CGFloat)degree{
    return degree * M_PI / 180;
}

- (CGFloat)RadiansToDegrees:(CGFloat)radius{
    return radius * 180 / M_PI;
}

@end
