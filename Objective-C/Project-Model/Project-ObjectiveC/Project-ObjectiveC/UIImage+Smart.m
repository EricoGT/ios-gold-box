//
//  UIImage+Smart.m
//  Project-ObjectiveC
//
//  Created by Erico Teixeira - Terceiro on 24/04/19.
//  Copyright © 2019 Atlantic Solutions. All rights reserved.
//

#import "UIImage+Smart.h"
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)
#else
#define toCF (CFTypeRef)
#define fromCF (id)
#endif

@implementation UIImage (Smart)

#pragma mark - UIColor

+ (UIColor * _Nonnull)COLOR_R:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a
{
    CGFloat red = r < 0.0 ? 0.0 : (r > 1.0 ? 1.0 : r);
    CGFloat green = g < 0.0 ? 0.0 : (g > 1.0 ? 1.0 : g);
    CGFloat blue = b < 0.0 ? 0.0 : (b > 1.0 ? 1.0 : b);
    CGFloat alpha = a < 0.0 ? 0.0 : (a > 1.0 ? 1.0 : a);
    //
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0];
}

+ (UIColor * _Nonnull)COLOR_HEX:(unsigned int)hex
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor * _Nonnull)COLOR_HEXSTR:(NSString * _Nonnull)hexSTR
{
    NSString *colorString = [[hexSTR stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            alpha = 1.0f;
            red   = 0.0f;
            green = 0.0f;
            blue  = 0.0f;
            break;
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (struct ColorComponents)COLOR_COMPONENTS:(UIColor * _Nonnull)color
{
    struct ColorComponents cc;
    [color getRed:&cc.red green:&cc.green blue:&cc.blue alpha:&cc.alpha];
    cc.red = cc.red * 255.0f;
    cc.green = cc.green * 255.0f;
    cc.blue = cc.blue * 255.0;
    cc.alpha = cc.alpha * 255.0f;
    return cc;
}

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
    if ([self isAnimated]){
        return nil;
    }
    
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
        //copiando animações
        UIImage *animationImage = [UIImage animatedImageWithImages:self.images duration:self.duration];
        return animationImage;
    }else{
        //copiando imagem única
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
    if (self.imageOrientation == UIImageOrientationUp || self.CGImage == nil || (self.size.width == 0 || self.size.height == 0 || [self isAnimated])) {
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
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0 || [self isAnimated])) {
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
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0 || [self isAnimated])) {
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
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0 || [self isAnimated])) {
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
    if ([self isAnimated]){
        
        //Imagem animada
        NSMutableArray *iList = [NSMutableArray new];
        for (UIImage *image in self.images){
            UIGraphicsBeginImageContext(newSize);
            [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            UIImage *frame = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            //
            [iList addObject:frame];
        }
        UIImage *newImage = [UIImage animatedImageWithImages:iList duration:self.duration];
        //
        return newImage;
        
    }else{
        
        //Imagem simples
        UIGraphicsBeginImageContext(newSize);
        [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //
        return newImage;
    }
}

- (UIImage * _Nullable) resizedImageToScale:(CGFloat)newScale
{
     if ([self isAnimated]){
         
         //Imagem animada
         NSMutableArray *iList = [NSMutableArray new];
         for (UIImage *image in self.images){
             CGSize newSize = CGSizeMake(self.size.width * newScale, self.size.height * newScale);
             UIGraphicsBeginImageContext(newSize);
             [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
             UIImage *frame = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             //
             [iList addObject:frame];
         }
         UIImage *newImage = [UIImage animatedImageWithImages:iList duration:self.duration];
         //
         return newImage;
         
     }else{
         
         //Imagem simples
         CGSize newSize = CGSizeMake(self.size.width * newScale, self.size.height * newScale);
         UIGraphicsBeginImageContext(newSize);
         [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
         UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         //
         return newImage;
     }
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
    
    if ([self isAnimated]){
        
        //Imagem animada
        NSMutableArray *iList = [NSMutableArray new];
        for (UIImage *image in self.images){
            CGSize newSize = CGSizeMake(width, height);
            UIGraphicsBeginImageContext(newSize);
            [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            UIImage *frame = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            //
            [iList addObject:frame];
        }
        UIImage *newImage = [UIImage animatedImageWithImages:iList duration:self.duration];
        //
        return newImage;
        
    }else{
        
        //Imagem simples
        CGSize newSize = CGSizeMake(width, height);
        UIGraphicsBeginImageContext(newSize);
        [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //
        return newImage;
    }
    
}

- (UIImage * _Nullable) cropImageUsingFrame:(CGRect)frame
{
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0 || [self isAnimated])) {
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
    UIImage *cropedImage = [self cropImageUsingFrame:frame];
    
    if (cropedImage == self || cropedImage == nil){
        return self;
    }
    
    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(cropedImage.size.width, cropedImage.size.height), NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat rectWidth = cropedImage.size.width;
    CGFloat rectHeight = cropedImage.size.height;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2.0;
    CGFloat imageCentreY = rectHeight/2.0;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = MIN(rectWidth, rectHeight)/2.0;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, cropedImage.size.width, cropedImage.size.height);
    [cropedImage drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage * _Nullable) roundedCornerImageWithCornerRadius:(CGFloat)radius andCorners:(UIRectCorner)corners
{
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0 || radius <= 1.0 || [self isAnimated])) {
        return self;
    }
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.size.width, self.size.height) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width, self.size.height), NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath (context);
    CGContextAddPath(context, rounded.CGPath);
    CGContextClosePath (context);
    CGContextClip (context);
   
    CGRect iRect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:iRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

- (UIImage * _Nullable) imageByClippingPath:(CGPathRef _Nonnull)path
{
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0 || [self isAnimated])) {
        return self;
    }
    
    CGRect boxPath = CGPathGetBoundingBox(path);
    UIImage *workImage = [UIImage imageWithData:UIImagePNGRepresentation(self)];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(workImage.size.width, workImage.size.height), NO, workImage.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath (context);
    CGContextAddPath(context, path);
    CGContextClosePath (context);
    CGContextClip (context);
    
    CGRect iRect = CGRectMake(0, 0, workImage.size.width, workImage.size.height);
    [workImage drawInRect:iRect];
    
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *finalImage = [tempImage cropImageUsingFrame:boxPath];
    
    return finalImage;
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
    //In case no parameter is passed, the input image will already be in the filter by default:
    [ciFilter setValue:ciImage forKey:kCIInputImageKey];
    //
    if(parameters){
        @try {
            [ciFilter setValuesForKeysWithDictionary:parameters];
        } @catch (NSException *exception) {
            NSLog(@"UIImage+Smart >> Error >> applyFilter:usingParameters: >> %@", [exception reason]);
            //
            return self;
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

- (UIImage * _Nullable) maskWithGrayscaleImage:(UIImage * _Nonnull)grayscaleMaskImage
{
    if (self.CGImage == nil || grayscaleMaskImage.CGImage == nil){
        return self;
    }
    
    NSString *filterName = @"CIBlendWithMask";
    
    CIImage* inputImage = [CIImage imageWithCGImage:self.CGImage];
    //CIImage* inputBackgroundImage = [CIImage imageWithCGImage:[self imageRotatedClockwise].CGImage];
    CIImage* inputMaskImage = [CIImage imageWithCGImage:grayscaleMaskImage.CGImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    //
    CIFilter *ciFilter = [CIFilter filterWithName:filterName];
    [ciFilter setValue:inputImage forKey:kCIInputImageKey];
    //[ciFilter setValue:inputBackgroundImage forKey:kCIInputBackgroundImageKey];
    [ciFilter setValue:inputMaskImage forKey:kCIInputMaskImageKey];
    //
    CIImage *outputImage = [ciFilter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(cgimg);
    context = nil;
    //
    return newImage;
}

- (UIImage * _Nullable) maskWithAlphaImage:(UIImage * _Nonnull)alphaMaskImage
{
    if (self.CGImage == nil || alphaMaskImage.CGImage == nil){
        return self;
    }
    
    NSString *filterName = @"CIBlendWithAlphaMask";
    
    CIImage* inputImage = [CIImage imageWithCGImage:self.CGImage];
    //CIImage* inputBackgroundImage = [CIImage imageWithCGImage:[self imageRotatedClockwise].CGImage];
    CIImage* inputMaskImage = [CIImage imageWithCGImage:alphaMaskImage.CGImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    //
    CIFilter *ciFilter = [CIFilter filterWithName:filterName];
    [ciFilter setValue:inputImage forKey:kCIInputImageKey];
    //[ciFilter setValue:inputBackgroundImage forKey:kCIInputBackgroundImageKey];
    [ciFilter setValue:inputMaskImage forKey:kCIInputMaskImageKey];
    //
    CIImage *outputImage = [ciFilter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(cgimg);
    context = nil;
    //
    return newImage;
}

- (CGImageRef)createMaskWithImage:(CGImageRef)image
{
    size_t maskWidth               = CGImageGetWidth(image);
    size_t maskHeight              = CGImageGetHeight(image);
    //  round bytesPerRow to the nearest 16 bytes, for performance's sake
    size_t bytesPerRow             = (maskWidth + 15) & 0xfffffff0;
    size_t bufferSize              = bytesPerRow * maskHeight;
    
    //  allocate memory for the bits
    CFMutableDataRef dataBuffer = CFDataCreateMutable(kCFAllocatorDefault, 0);
    CFDataSetLength(dataBuffer, bufferSize);
    
    //  the data will be 8 bits per pixel, no alpha
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef ctx            = CGBitmapContextCreate(CFDataGetMutableBytePtr(dataBuffer),
                                                        maskWidth, maskHeight,
                                                        8, bytesPerRow, colourSpace, kCGImageAlphaNone);
    //  drawing into this context will draw into the dataBuffer.
    CGContextDrawImage(ctx, CGRectMake(0, 0, maskWidth, maskHeight), image);
    CGContextRelease(ctx);
    
    //  now make a mask from the data.
    CGDataProviderRef dataProvider  = CGDataProviderCreateWithCFData(dataBuffer);
    CGImageRef mask                 = CGImageMaskCreate(maskWidth, maskHeight, 8, 8, bytesPerRow,
                                                        dataProvider, NULL, FALSE);
    
    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(colourSpace);
    CFRelease(dataBuffer);
    
    return mask;
}

- (UIImage * _Nullable) applyBorderWithColor:(UIColor * _Nonnull)borderColor andWidth:(CGFloat)borderWidth
{
    CGSize size = [self size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //
    CGFloat red, green, blue, alpha;
    [borderColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    //
    CGContextSetLineWidth(context, borderWidth);
    //
    CGContextStrokeRect(context, rect);
    UIImage *resultImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //
    return resultImage;
}

- (UIImage * _Nullable) tintImageWithColor:(UIColor * _Nonnull)color
{
    UIImage *newImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(self.size, NO, newImage.scale);
    [color set];
    [newImage drawInRect:CGRectMake(0, 0, self.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //
    return newImage;
}

- (UIImage * _Nullable) bluredImageWithRadius:(CGFloat)radius tintColor:(UIColor * _Nullable)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage * _Nullable)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        return nil;
    }
    if (!self.CGImage) {
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        return nil;
    }
    if ([self isAnimated]){
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = [self clone];
    
    BOOL hasBlur = radius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = radius * [[UIScreen mainScreen] scale];
            uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

//- (NSArray<UIImage*>* _Nullable) detectedFacesImages
- (void) detectFacesImagesWithCompletionHandler:(void(^_Nonnull)(NSArray<UIImage*>* _Nullable detectedFaces)) handler
{
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0) || [self isAnimated]) {
        handler(nil);
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        CIContext *context = [CIContext context];
        NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
        
        opts = @{ CIDetectorImageOrientation : @(self.imageOrientation)};
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:self.CGImage] options:opts];
        
        NSMutableArray *iFaces = [NSMutableArray new];
        
        for (CIFaceFeature *feature in features){
            CGRect originalBounds = feature.bounds;
            CGRect extendedBounds = originalBounds;
            
            //face rect realign
            if (feature.hasLeftEyePosition && feature.hasRightEyePosition){
                CGFloat dEyes = feature.rightEyePosition.x - feature.leftEyePosition.x;
                CGFloat side = dEyes * 3.5;
                //
                CGFloat minX = MIN(feature.leftEyePosition.x, feature.rightEyePosition.x);
                CGFloat maxX = MAX(feature.leftEyePosition.x, feature.rightEyePosition.x);
                CGFloat minY = MIN(feature.leftEyePosition.y, feature.rightEyePosition.y);
                CGFloat maxY = MAX(feature.leftEyePosition.y, feature.rightEyePosition.y);
                //
                CGPoint centerEyes = CGPointMake(minX + ((maxX - minX) / 2.0), minY + ((maxY - minY) / 2.0));
                extendedBounds = CGRectMake(centerEyes.x - (side / 2.0), centerEyes.y - (side / 2.0), side, side);
            }else{
                extendedBounds = CGRectMake(originalBounds.origin.x - ((originalBounds.size.width * 1.4 - originalBounds.size.width) / 2.0), originalBounds.origin.y, originalBounds.size.width * 1.4, originalBounds.size.height * 2.0);
            }
            
            UIImage *faceImage = [self cropImageUsingFrame:extendedBounds];
            if (faceImage != self && faceImage != nil){
                [iFaces addObject:faceImage];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            handler([NSArray arrayWithArray:iFaces]);
        });
    });
}

- (void) detectQRCodeMessageWithCompletionHandler:(void(^_Nonnull)(NSArray<NSString*>* _Nullable detectedMessages)) handler
{
    if (self.CGImage == nil || (self.size.width == 0 || self.size.height == 0) || [self isAnimated]) {
        handler(nil);
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        CIContext *context = [CIContext context];
        NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:opts];
        
        opts = @{ CIDetectorImageOrientation : @(self.imageOrientation)};
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:self.CGImage] options:opts];
        
        NSMutableArray *iMessages = [NSMutableArray new];
        
        for (CIQRCodeFeature *feature in features){
            if (feature.messageString){
                [iMessages addObject:feature.messageString];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            handler([NSArray arrayWithArray:iMessages]);
        });
    });
}

- (UIImage * _Nullable) filterImageColorWithHueMin:(CGFloat)minHue andHueMax:(CGFloat)maxHue
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:self];
    
    // 1
    const unsigned int size = 64; 
    const size_t cubeDataSize = size * size * size * 4;
    NSMutableData* cubeData = [[NSMutableData alloc] initWithCapacity:(cubeDataSize * sizeof(float))];
    
    // 2
    for (int z = 0; z < size; z++) {
        CGFloat blue = ((double)z)/(size-1);
        for (int y = 0; y < size; y++) {
            CGFloat green = ((double)y)/(size-1);
            for (int x = 0; x < size; x++) {
                CGFloat red = ((double)x)/(size-1);
                
                // 3
                CGFloat hue = [self hueFromRed:red green:green blue:blue];
                float alpha = (hue >= minHue && hue <= maxHue) ? 0 : 1;
                
                // 4
//                float premultipliedRed = red * alpha;
//                float premultipliedGreen = green * alpha;
//                float premultipliedBlue = blue * alpha;
//                [cubeData appendBytes:&premultipliedRed length:sizeof(float)];
//                [cubeData appendBytes:&premultipliedGreen length:sizeof(float)];
//                [cubeData appendBytes:&premultipliedBlue length:sizeof(float)];
//                [cubeData appendBytes:&alpha length:sizeof(float)];
                
               
                
                float premultipliedRed = red * 0.299f + green * 0.587f + blue * 0.114f;
                float premultipliedGreen = red * 0.299f + green * 0.587f + blue * 0.114f;
                float premultipliedBlue = red * 0.299f + green * 0.587f + blue * 0.114f;
                [cubeData appendBytes:&premultipliedRed length:sizeof(float)];
                [cubeData appendBytes:&premultipliedGreen length:sizeof(float)];
                [cubeData appendBytes:&premultipliedBlue length:sizeof(float)];
                [cubeData appendBytes:&alpha length:sizeof(float)];
                
            }
        }
    }
    
    // 5
    CIFilter* chromaKeyFilter = [CIFilter filterWithName:@"CIColorCube"];
    [chromaKeyFilter setValue:@(size) forKey:@"inputCubeDimension"];
    [chromaKeyFilter setValue:cubeData forKey:@"inputCubeData"];
    [chromaKeyFilter setValue:ciImage forKey:kCIInputImageKey];
    
    //6
    CIImage *outputImage = [chromaKeyFilter outputImage];
    if (outputImage){
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[ciImage extent]];
        UIImage *uiImage = [UIImage imageWithCGImage:cgimg scale:self.scale orientation:self.imageOrientation];
        return uiImage;
    }else{
        return nil;
    }
}

- (UIImage * _Nullable) filterImageColorWithBaseColor:(UIColor * _Nonnull)baseColor andDelta:(CGFloat)delta
{
    CGFloat hue = [UIImage hueFromColor:baseColor];
    delta = delta < 0.0 ? 0.0 : (delta > 1.0 ? 1.0 : delta);
    CGFloat minHue = hue - (hue * delta);
    CGFloat maxHue = hue + (hue * delta);
    minHue = minHue < 0.0 ? 0.0 : (minHue > 1.0 ? 1.0 : minHue);
    maxHue = maxHue < 0.0 ? 0.0 : (maxHue > 1.0 ? 1.0 : maxHue);
    //
    return [self filterImageColorWithHueMin:minHue andHueMax:maxHue];
}

+ (CGFloat)hueFromColor:(UIColor * _Nonnull)color
{
    CGFloat hue, saturation, brightness;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:nil];
    //
    return hue;
}

#pragma mark - Utils

- (CGFloat)DegreesToRadians:(CGFloat)degree{
    return degree * M_PI / 180;
}

- (CGFloat)RadiansToDegrees:(CGFloat)radius{
    return radius * 180 / M_PI;
}

- (CGFloat) hueFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    CGFloat hue, saturation, brightness;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:nil];
    return hue;
}

- (CGFloat)clamp255:(CGFloat)value{
    return value < 0.0 ? 0.0 : (value > 255.0 ? 255.0 : value);
}

- (BOOL)compareValue:(CGFloat)v1 withValue:(CGFloat)v2 andDelta:(CGFloat)delta{
    
    CGFloat minV2 = v2 - (v2 * delta);
    CGFloat maxV2 = v2 + (v2 * delta);
    //
    return (v1 >= minV2 && v1 <= maxV2);
}

- (UIImage * _Nullable) imageReplacingColor:(UIColor * _Nonnull)baseColor toColor:(UIColor * _Nullable)newColor usingTolerance:(CGFloat)tolerance andInteretRect:(CGRect)interestRect
{
    if ([self isAnimated]){
        return self;
    }
    
    UIImage *pngImage = [UIImage imageWithData:UIImagePNGRepresentation(self)];
    
    CGImageRef imageRef = [pngImage CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    //base color
    CGFloat baseRed = 0.0;
    CGFloat baseGreen = 0.0;
    CGFloat baseBlue = 0.0;
    CGFloat baseAlpha = 0.0;
    [baseColor getRed:&baseRed green:&baseGreen blue:&baseBlue alpha:&baseAlpha];
    baseRed = baseRed * 255.0;
    baseGreen = baseGreen * 255.0;
    baseBlue = baseBlue * 255.0;
    baseAlpha = baseAlpha * 255.0;
    if (baseAlpha != 0.0){
        baseRed = baseRed / baseAlpha;
        baseGreen = baseGreen / baseAlpha;
        baseBlue = baseBlue/ baseAlpha;
    }
    
    //new color
    CGFloat newRed = 0.0;
    CGFloat newGreen = 0.0;
    CGFloat newBlue = 0.0;
    CGFloat newAlpha = 0.0;
    BOOL useNewColor = NO;
    if (newColor){
        [newColor getRed:&newRed green:&newGreen blue:&newBlue alpha:&newAlpha];
        newRed = newRed * 255.0;
        newGreen = newGreen * 255.0;
        newBlue = newBlue * 255.0;
        newAlpha = newAlpha * 255.0;
        if (newAlpha != 0.0){
            newRed = newRed / newAlpha;
            newGreen = newGreen / newAlpha;
            newBlue = newBlue/ newAlpha;
        }
        
        useNewColor = YES;
    }
    
    NSUInteger byteIndex = 0;

    for (int i = 0 ; i < width * height ; ++i)
    {
        CGPoint actualPixel = CGPointMake(i / width, i % width); //converting array to line and column
        if (CGRectContainsPoint(interestRect, actualPixel)){
            
            //Red
            CGFloat red = ((CGFloat) rawData[byteIndex]     );
            
            //Green
            CGFloat green = ((CGFloat) rawData[byteIndex + 1] );
            
            //Blue
            CGFloat blue  = ((CGFloat) rawData[byteIndex + 2] );
            
            //Alpha
            CGFloat alpha = ((CGFloat) rawData[byteIndex + 3] ); // /255.0f
            
            if (alpha != 0.0){
                
                //Red
                red = red / alpha;
                
                //Green
                green = green / alpha;
                
                //Blue
                blue  = blue / alpha;
                
            }
            
            if ([self compareValue:baseRed withValue:red andDelta:tolerance] && [self compareValue:baseGreen withValue:green andDelta:tolerance] && [self compareValue:baseBlue withValue:blue andDelta:tolerance]){
                
                if (useNewColor){
                    
                    //R:
                    rawData[byteIndex] = (unsigned char)(newRed * alpha);
                    //G:
                    rawData[byteIndex+1] = (unsigned char)(newGreen * alpha);
                    //B:
                    rawData[byteIndex+2] = (unsigned char)(newBlue * alpha);
                    //A:
                    //rawData[byteIndex+3] = (int)newAlpha;
                    
                }
                else{
                    
                    rawData[byteIndex+3] = (unsigned char)(0);
                    
                }
                
            }
            
        }

        byteIndex += bytesPerPixel;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                bitsPerComponent,
                                bytesPerRow,
                                colorSpace,
                                kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    imageRef = CGBitmapContextCreateImage (ctx);
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    free(rawData);
    
    return rawImage;
}

#pragma mark - Info

- (UIImage * _Nullable)labeledImageWithText:(NSString * _Nonnull)text contentRect:(CGRect)rect roundingCorners:(UIRectCorner)rectCorners cornerRadii:(CGSize)cornerSize textAlign:(NSTextAlignment)textAligment internalMargin:(UIEdgeInsets)margin font:(UIFont * _Nonnull)font fontColor:(UIColor * _Nonnull)fontColor backgroundColor:(UIColor * _Nullable)backColor shadow:(NSShadow * _Nullable)shadow autoHeightAdjust:(BOOL)adjust;
{
    if (self.size.width == 0 || self.size.height == 0 || [self isAnimated]) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 1.0f);
    
    [self drawInRect:CGRectMake(0.0f ,0.0f ,self.size.width, self.size.height)];
    
    CGRect textRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    CGSize constraintRect = CGSizeMake(rect.size.width, CGFLOAT_MAX);
    CGRect boundingBox = [text boundingRectWithSize:constraintRect options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
    
    if (adjust){
        textRect = CGRectMake(textRect.origin.x, textRect.origin.y, textRect.size.width, boundingBox.size.height);
    }
    
    //RECT
    if (backColor){
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:textRect byRoundingCorners:rectCorners cornerRadii:cornerSize];
        [backColor setFill];
        [rounded fill];
    }
    
    if (boundingBox.size.height <= textRect.size.height){
        textRect = CGRectMake(textRect.origin.x, textRect.origin.y + (textRect.size.height - boundingBox.size.height) / 2.0, textRect.size.width, textRect.size.height);
    }
    
    //INTERNAL_MARGIN
    textRect = CGRectMake(textRect.origin.x + margin.left, textRect.origin.y + margin.top, textRect.size.width - (margin.left + margin.right), textRect.size.height - (margin.top + margin.bottom));
    
    //TEXT
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = textAligment;
    paragraphStyle.minimumLineHeight = font.pointSize;
    paragraphStyle.maximumLineHeight = font.pointSize * 1.5;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSMutableDictionary *att = [NSMutableDictionary new];
    [att setObject:font forKey:NSFontAttributeName];
    [att setObject:fontColor forKey:NSForegroundColorAttributeName];
    [att setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    if (shadow){
        [att setObject:shadow forKey:NSShadowAttributeName];
    }
    [text drawInRect:textRect withAttributes:att];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end


