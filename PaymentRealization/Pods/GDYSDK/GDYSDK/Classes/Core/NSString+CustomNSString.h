//
//  NSString+CustomNSString.h

// func: achieve NSString usually fun

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CustomNSString)


/**
 method -- intercept string
 mark some character and change text color in specifily character
 (such as "<em>xx</em>")
 */
+ (NSMutableAttributedString *)useMatchSetTextColor:(NSString *)string AndColor:(UIColor *)vaColor withFirstReplaceStr:(NSString *)firstStr secondReplaceStr:(NSString *)secondStr;




/**
 money code covert money tag

 @param langCode The language or control code.
 @return each country or area money code.
 */
+ (NSString *)eachContryMoneyTagWithLangCode:(NSString *)langCode;





@end




NS_ASSUME_NONNULL_END


