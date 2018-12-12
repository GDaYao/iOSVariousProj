//
//  UILabel+CustomLabInit.m


#import "UILabel+CustomLabInit.h"
#import "UIColor+Hex.h"

@implementation UILabel (CustomLabInit)


#pragma mark - `UILabel` init method
+ (UILabel *)InitLabWithBGColor:(NSString *)hexStr textColor:(UIColor *)txC fontName:(NSString *)fontName fontSize:(CGFloat)fontSize labText:(NSString *)labText txAlignment:(NSTextAlignment)txAlignment
{
    UILabel *lab = [[UILabel alloc]init];
    if ([hexStr isEqualToString:@"0"] || !hexStr) {
        lab.backgroundColor = [UIColor clearColor];
    }else{
        lab.backgroundColor = [UIColor colorWithHexString:hexStr];
    }
    if(fontName &&  (fontSize != 0)){
        lab.font = [UIFont fontWithName:fontName size:fontSize];
    }
    lab.text = labText;
    lab.textColor = txC;
    lab.textAlignment = txAlignment;
    lab.numberOfLines = 0;
    return lab;

}


#pragma mark - `UILabel` change line space
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

#pragma mark - `UILabel` change word space
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

#pragma mark - `UILabel` change line+word space
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}






@end



