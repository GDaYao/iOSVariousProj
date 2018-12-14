//
//  UIColor+Hex.m

#import "UIColor+Hex.h"



@implementation UIColor (Hex)


#pragma mark - hex string convert to color object
+ (UIColor *) colorWithHexString:(NSString *)hexString{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //hexString should six-eight character
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    //if hexString has @"0X" prefix
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    //if hexString has @"#"" prefix
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    // 如果hexString 有@"..FF"后缀...必须是在cString.length长度大于6的情况下
    if (cString.length > 6) {
        if ([cString hasSuffix:@"FF"]) {
            cString = [cString substringToIndex:cString.length-2];
        }
    }
    if ([cString length] != 6)
        return [UIColor clearColor];
    //RGB exchange
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R
    NSString *rString = [cString substringWithRange:range];
    
    //G
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //B
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // unsigned int object
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

#pragma mark - color string  covert to 'R+G+B' int sum
+ (int)RGBSumWithHexString:(NSString *)hexString{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //hexString应该6到8个字符
    if ([cString length] < 6) {
        return 0;
    }
    
    //如果hexString 有@"0X"前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    //如果hexString 有@"#""前缀
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    // 如何hexString 有@"..FF"后缀...必须是在cString.length长度大于6的情况下
    if (cString.length > 6) {
        if ([cString hasSuffix:@"FF"]) {
            cString = [cString substringToIndex:cString.length-2];
        }
    }
    
    if ([cString length] != 6)
        return 0;
    
    //RGB转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R
    NSString *rString = [cString substringWithRange:range];
    
    //G
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //B
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    //
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return r+g+b;
}

#pragma  mark -  UIColor covert to hex string
+ (NSString *) hexFromUIColor: (UIColor*) color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#XXX", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

#pragma mark - color object covert to NSString object
- (NSString*)hexString {
    return [NSString stringWithFormat:@"0x%08x", [self hex]];
}
- (uint)hex {
    CGFloat red, green, blue, alpha;
    if (![self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        [self getWhite:&red alpha:&alpha];
        green = red;
        blue = red;
    }
    
    red = roundf(red * 255.f);
    green = roundf(green * 255.f);
    blue = roundf(blue * 255.f);
    alpha = roundf(alpha * 255.f);
    
    return ((uint)alpha << 24) | ((uint)red << 16) | ((uint)green << 8) | ((uint)blue);
}


#pragma mark - from current color to gray color
/* para:
 scale: scale rate
 type: 1/2 gray deep/shallow
 back: int gray color value
 */
+ (int)RGBAddValueWithHextString:(NSString *)hexString colorFloat:(float)colorValue scale:(float)scale operateType:(int)type{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //hexString应该6到8个字符
    if ([cString length] < 6 && colorValue == 0.0) {
        return 1;
    }
    
    //如果hexString 有@"0X"前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    //如果hexString 有@"#""前缀
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if (cString.length > 6) {
        if ([cString hasSuffix:@"FF"]) {
            cString = [cString substringToIndex:cString.length-2];
        }else if ([cString hasPrefix:@"FF"]) {
            cString = [cString substringFromIndex:2];
        }
        
        
    }
    
    if ([cString length] != 6 && colorValue == 0.0)
        return 1;
    
    //RGB转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R
    NSString *rString = [cString substringWithRange:range];
    
    //G
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //B
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    //
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (colorValue != 0.0) {
        r = g = b = colorValue;
    }
    
    float cr=0.0;
    float cg=0.0;
    float cb=0.0;
    if (type == 1) {
        cr = r + 0.5*scale;
        cg = g + 0.5*scale;
        cb = b + 0.5*scale;
    }else if(type == 2)
    {
        cr = r - 0.5*scale;
        cg = g - 0.5*scale;
        cb = b - 0.5*scale;
    }
    
    /// 这里输出RGB色值，根据每次重绘放大比例增大 以50为基数
    if( cr >= 255)
    {
        cr = 255;
    }
    if( cg >=255)
    {
        cg = 255;
    }
    if(cb >= 255)
    {
        cb = 255;
    }
    
    return cr*0.2989+cg*0.5870+cb*0.1140;
    
}

#pragma mark - generate random color
+ (UIColor *) randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}




@end






