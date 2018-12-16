//
//  ToolM.h


// save all others tool method class


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ToolM : NSObject

/**
 app update alert function
 
 @param currentVC Use UIViewController Class to show `UIAlertAction`
 @param appID App only id
 */
+ (void)updateApp:(UIViewController *)currentVC appID:(NSInteger)appID;


/**
 judge current time this user new or older.
 each app need use this method before use old or new user.

 @param isNewUserKey `NSUserDefaults` bool for key
 */
+ (void)newOrOldUsersWithuUserDefault:(NSString *)isNewUserKey;


#pragma mark - time
// get time string from int time
+ (NSString *)getHourMintueSecondStringFromIntTime:(NSInteger)integerTime;
// get differ time string from int time
+ (NSString *)getDifferHourMintueSecondStringFromIntTime:(NSInteger)integerTime;
// get timestamp
+ (long)currentTimestamp;
// get formatter time string
+ (NSString *)getCurrentTimeFormatterString;
// get date components for day/hour/minue/second ...
+ (NSDateComponents *)getDateComponents;
//  calculate week date each day  -- para:NSDate*
+ (NSString *)calculateWeek:(NSDate *)date;
// NSDate is "yesday"/"today"/"tomorrow"
+ (NSString *)compareDate:(NSDate *)date;


#pragma mark - get language
+(NSString *)getLanguageCode;

#pragma mark - verification
// verification phone number valid
+ (BOOL) isValidateMobile:(NSString *)mobile;

// verification email valid
+ (BOOL) validateEmail: (NSString *) strEmail;

// judge illegal character
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content;

// have digital
+ (BOOL)hasDigital:(NSString *)string;

// has letter (return YES-have,NO-no)
+ (BOOL)hasLetter:(NSString *)string;

#pragma mark - json/NSDictionary/string convert

/**
 parse Bundle json file and return `NSDictionary`
 
 @param jsonName Json form file
 @return `NSDictionay *`
 */
+ (NSDictionary *)parseBundleJsonWith:(NSString *)jsonName;

// #pragma mark NSDictionary => json format string
+(NSString*)dictionaryToJson:(NSDictionary *)dic;

// #pragma mark json fromat string => NSDictioinary
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


#pragma mark - judge blank string
+ (BOOL)isBlankString:(NSString *)string;


#pragma mark - ----alertView use----
+ (void)showAlertViewWithoutVCTitle:(NSString *)title message:(NSString *)msg okBtnStr:(NSString *)okStr cancelBtnStr:(NSString *)cancelStr;
+ (void)showAlertViewWithSelfTitle:(NSString *)title message:(NSString *)msg okBtnStr:(NSString *)okStr okAction:(void(^)(UIAlertAction * _Nonnull action))okaction cancelBtnStr:(NSString *)cancelStr  cancelAction:(void(^)(UIAlertAction * _Nonnull action))cancelaction withVC:(UIViewController *)selfVC;

#pragma mark - judge machine type
+ (NSString*)judgeiOSType;





@end


