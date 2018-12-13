//
//  ToolM.m

#import "ToolM.h"
#import "NetworkMgr.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>

@implementation ToolM

#pragma mark -  'update app' network request

+ (void)requestNewVersionWithAppID:(NSInteger)appID block:(void(^)(NSArray *resultArr))blockArr{    
    NSString *appstoreStr =[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%ld",(long)appID]; //@"<kAppID>"
    [NetDataMgr AFHttpDataTaskGETMethodWithURLString:appstoreStr parameters:nil success:^(id  _Nullable responseObject) {
        if(responseObject)
        {
            NSArray *resultArray;
            if ([[responseObject allKeys]containsObject:@"results"]) {
                resultArray = responseObject[@"results"];
            }
            if (![resultArray count]) {
                NSLog(@"Your app info is nil,network shop don't have your app");
            }else
            {
                blockArr(resultArray);
            }
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"check for update error：%@", error.description);
    }];
}

#pragma mark use update app
+ (void)updateApp:(UIViewController *)currentVC appID:(NSInteger)appID{
    [self requestNewVersionWithAppID:appID block:^(NSArray *resultArr) {
        if(resultArr.count == 0){
            return ;
        }
        //接收封装的网络获取版本信息的字典
        NSDictionary *infoDict = [resultArr objectAtIndex:0]; //开发者id
        //获取服务器上应用的最新版本号
        NSString *updateVersion = infoDict[@"version"];
        NSString *trackName = infoDict[@"trackName"];
        //_trackViewUrl : 更新的时候用到的地址
        NSString *trackViewUrl = infoDict[@"trackViewUrl"];
        //获取当前设备中应用的版本号
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        // 判断两个版本是否相同
        NSString *titleStr = [NSString stringWithFormat:@"%@:%@",@"Check for update",trackName];
        NSString *updateJudgeT = [updateVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        if ([updateJudgeT integerValue] > [currentVersion integerValue]) {
            NSString *messageStr = [NSString stringWithFormat:@"%@(%@)",@"Find new version",updateVersion];
            UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:titleStr   message:messageStr               preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"update" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
                                                                 }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                                   
                                                                 }];
            [alertCon addAction:cancelAction];
            [alertCon addAction:updateAction];
            [currentVC presentViewController:alertCon animated:YES completion:nil];
        }
    }];
}

#pragma mark - new or old users
+ (void)newOrOldUsersWithuUserDefault:(NSString *)isNewUserKey{
    NSString * const saveVersionKey = @"saveUserInfoVersion";
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:saveVersionKey];
    if(!saveVersion){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isNewUserKey];
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:saveVersionKey];
    }else {
        currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        saveVersion = [saveVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        if ([currentVersion integerValue] > [saveVersion integerValue]) {
            // old user update
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isNewUserKey];
        }
    }
}


#pragma mark - ---- time ----
#pragma mark get time string from int time. s ==> 00:00:00
+ (NSString *)getHourMintueSecondStringFromIntTime:(NSInteger)integerTime{
    NSInteger H=0;
    NSInteger M=0;
    NSInteger S=0;
    if (integerTime >= 3600) {
        H = integerTime / 3600;
        M = (integerTime - 3600)/60;
        S = (integerTime -3600)%60;
    }else{
        H = 0;
        M = integerTime / 60;
        S = integerTime % 60;
    }
    NSString *HStr;
    NSString *MStr;
    NSString *SStr;
    if (H<=9) {
        HStr = [NSString stringWithFormat:@"0%ld",H];
    }else{
        HStr = [NSString stringWithFormat:@"%ld",H];
    }
    if (M<=9) {
        MStr = [NSString stringWithFormat:@"0%ld",M];
    }else{
        MStr = [NSString stringWithFormat:@"%ld",M];
    }
    if (S<=9) {
        SStr = [NSString stringWithFormat:@"0%ld",S];
    }else{
        SStr = [NSString stringWithFormat:@"%ld",S];
    }
    
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@:%@",HStr,MStr,SStr];
    return timeStr;
}
#pragma mark get differ time string from int time. s ==> 00:00:00| 00:00
+ (NSString *)getDifferHourMintueSecondStringFromIntTime:(NSInteger)integerTime{
    NSInteger H=0;
    NSInteger M=0;
    NSInteger S=0;
    if (integerTime >= 3600) {
        H = integerTime / 3600;
        M = (integerTime - 3600)/60;
        S = (integerTime -3600)%60;
    }else{
        H = 0;
        M = integerTime / 60;
        S = integerTime % 60;
    }
    NSString *HStr;
    NSString *MStr;
    NSString *SStr;
    
    BOOL hBool = NO;
    if (H == 0) {
        hBool = YES;
    }else  if (H<=9) {
        HStr = [NSString stringWithFormat:@"0%ld",H];
    }else{
        HStr = [NSString stringWithFormat:@"%ld",H];
    }
   if (M<=9) {
        MStr = [NSString stringWithFormat:@"0%ld",M];
    }else{
        MStr = [NSString stringWithFormat:@"%ld",M];
    }
    if (S<=9) {
        SStr = [NSString stringWithFormat:@"0%ld",S];
    }else{
        SStr = [NSString stringWithFormat:@"%ld",S];
    }
    
    NSString *timeStr;
    if (hBool) {
        timeStr = [NSString stringWithFormat:@"%@:%@",MStr,SStr];
    }else{
       timeStr = [NSString stringWithFormat:@"%@:%@:%@",HStr,MStr,SStr];
    }
    return timeStr;
}





#pragma mark get timestamp 
+ (long)currentTimestamp{
    // timestamp --- thirteen number is 'ms' | ten number is 's'
    // 时间戳为13位是精确到毫秒的，10位精确到秒
    NSDate *currentDate = [NSDate date];
    long nowTime = currentDate.timeIntervalSince1970;
    return nowTime;
}
#pragma mark get formatter time string
+ (NSString *)getCurrentTimeFormatterString{
    NSDate *currentDate = [NSDate date];
    // 'dateFormatter' form 'NSDate' object
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // set style
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    // 'NSDate' covert 'NSString'
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    return currentDateString;
}
#pragma mark get date components for day/hour/minue/second ...
+ (NSDateComponents *)getDateComponents{
    NSDate *currentDate = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents * dateComps = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitTimeZone fromDate:currentDate];
    // you can return dateComps.year,dateComps.month,dateComps.day,dateComps.hour,dateComps.minute,dateComps.second,dateComps.weekday,dateComps.month ......
    return dateComps;
}
#pragma mark calculate week date each day  -- para:NSDate*
+ (NSString *)calculateWeek:(NSDate *)date{
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[myCalendar components:NSCalendarUnitWeekday fromDate:date] weekday];
    switch (week) {
        case 1:{
            return @"周日";
        }
        case 2:{
            return @"周一";
        }
        case 3:{
            return @"周二";
        }
        case 4:{
            return @"周三";
        }
        case 5:{
            return @"周四";
        }
        case 6:{
            return @"周五";
        }
        case 7:{
            return @"周六";
        }
    }
    return @"";
}

#pragma mark NSDate is "yesday"/"today"/"tomorrow" string
+ (NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"Tod"; // today
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"Yes"; // yesday
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"Tom"; // tomorrow
    }
    else
    {
        return dateString;
    }
}

#pragma mark - ---- get language ----
+(NSString *)getLanguageCode{
    NSString *lang = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSArray<NSString *> *tmp = [lang componentsSeparatedByString:@"-"];
    int count = (int)tmp.count;
    if(count < 2) {
        lang = tmp[0];
    } else {
        lang = tmp[0];
        for (int i=1; i<count-1; i++) {
            lang = [NSString stringWithFormat:@"%@-%@", lang, tmp[i]];
        }
    }
    lang = lang ? lang : @"en";
    return lang;
}


#pragma mark - ----verification----

#pragma mark verification phone number valid
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    /*
     //手机号以13， 15，18开头，八个 \\d 数字字符
     NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\\\D])|(18[0,0-9]))\\\\d{8}$";
     NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
     return [phoneTest evaluateWithObject:mobile];
     */
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"1[34578]([0-9]){9}"];
    return [phoneTest evaluateWithObject:mobile];
}
#pragma mark verification email valid
+ (BOOL) validateEmail: (NSString *) strEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:strEmail];
}
#pragma mark judge illegal character (return YES-have,NO-no)
+ (BOOL)judgeTheillegalCharacter:(NSString *)content{
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}

#pragma mark has digital (return YES-have,NO-no)
+ (BOOL)hasDigital:(NSString *)string
{
    for(int i = 0; i < string.length ; i++){
        unichar a = [string characterAtIndex:i];
        if ((a >= '0' && a <= '9' )) {
            return YES;
        }
    }
    return NO;
}


#pragma mark has letter (return YES-have,NO-no)
+ (BOOL)hasLetter:(NSString *)string{
    for(int i = 0; i < string.length ; i++){
        unichar a = [string characterAtIndex:i];
        if ((a >= 'A' && a <= 'Z' ) || (a >= 'a' && a <= 'z')) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - json/NSDictionary/string convert

#pragma mark local Bundle json parse
+ (NSDictionary *)parseBundleJsonWith:(NSString *)jsonName{
    NSString *path  =[[NSBundle mainBundle]pathForResource:jsonName ofType:@"json"];
    NSData *jsonLocalData = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonLocalData options:NSJSONReadingAllowFragments error:nil];
    return jsonDic;
    /**
    NSMutableArray *modelMutArr = [NSMutableArray array];
    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [modelMutArr addObject:[[Model alloc]initWithDictionary:obj]]; // create `initWithDictionary`
    }];
     */
}

#pragma mark NSDictionary => json format string
+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *base =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    base = [base stringByReplacingOccurrencesOfString:@"\r\n" withString : @"" ];
    
    base = [base stringByReplacingOccurrencesOfString:@"\n" withString : @"" ];
    
    base = [base stringByReplacingOccurrencesOfString:@"\t" withString : @"" ];
    base = [base stringByReplacingOccurrencesOfString:@" " withString : @"" ];
    base = [base stringByReplacingOccurrencesOfString:@"/n" withString : @"" ];
    return base;
}

#pragma mark json fromat string => NSDictioinary
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r\n" withString : @"" ];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString : @"" ];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString : @"" ];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - judge blank string
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}



#pragma mark - alert show | ActionSheet
/**
 Alert show
 */
+ (void)showAlertViewWithoutVCTitle:(NSString *)title message:(NSString *)msg okBtnStr:(NSString *)okStr cancelBtnStr:(NSString *)cancelStr{
    
    
    UIAlertView *alert;
    if (cancelStr.length == 0 || !cancelStr) {
        alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:okStr otherButtonTitles:nil];
    }else{
        alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:okStr otherButtonTitles:cancelStr,nil];
    }
    [alert show];
}
+ (void)showAlertViewWithSelfTitle:(NSString *)title message:(NSString *)msg okBtnStr:(NSString *)okStr okAction:(void(^)(UIAlertAction * _Nonnull action))okaction cancelBtnStr:(NSString *)cancelStr  cancelAction:(void(^)(UIAlertAction * _Nonnull action))cancelaction withVC:(UIViewController *)selfVC{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okA = [UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        okaction(action);
    }];
    [alertVC addAction:okA];
    if (cancelStr.length || cancelStr) {
        UIAlertAction *cancelA = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancelaction(action);
        }];
        [alertVC addAction:cancelA];
    }
    [selfVC presentViewController:alertVC animated:YES completion:nil];
}

/**
 ActionSheet
 because of `otherButtonTitles` parameter number isn't determinate.
 */
- (void)showActionSheetWithTitle:(NSString *)titleStr delegate:(id)deleSelf cancelBtn:(NSString *)cancelBtnTitle destructiveBtn:(NSString *)destruBtnTitle OtherBtn:(NSString *)otherBtnStr showView:(UIView *)showV{
    [[[UIActionSheet alloc] initWithTitle:titleStr
                                 delegate:deleSelf
                        cancelButtonTitle:cancelBtnTitle
                   destructiveButtonTitle:destruBtnTitle
                        otherButtonTitles:otherBtnStr] showInView:showV];
}
// action delegate,so need subclass <UIActionSheet>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // you need three custome method
    SEL selectors[] = {
        @selector(actionOne),
        @selector(actionTwo),
    };
    NSLog(@"%ld----%ld-------%ld",buttonIndex,sizeof(selectors),sizeof(SEL));
    if (buttonIndex < sizeof(selectors) / sizeof(SEL)) {
        //  方法名 -> 方法id -> 方法内存地址 -> 根据方法地址调用方法
        void(*imp)(id, SEL) = (typeof(imp))[self methodForSelector:selectors[buttonIndex]];
        imp(self, selectors[buttonIndex]);
    }
    
}



#pragma mark - judge machine type
/**
    need import "#import <sys/utsname.h>"
 */
+ (NSString*)judgeiOSType {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"]) return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"]) return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"]) return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"]) return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"]) return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"]) return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"]) return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"]) return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"]) return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"]) return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"]) return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"]) return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"]) return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"]) return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"]) return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"]) return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"]) return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"]) return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"]) return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"]) return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"]) return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"]) return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"]) return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"]) return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"]) return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"]) return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"]) return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"]) return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"]) return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"]) return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"]) return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"]) return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"]) return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"]) return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"]) return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"]) return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"]) return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"]) return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"]) return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"]) return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"]) return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"]) return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"]) return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"]) return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"]) return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"]) return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"]) return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"]) return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"]) return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"]) return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"]) return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"]) return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"]) return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"]) return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"]) return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"]) return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"]) return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"]) return@"iPhone Simulator";
    
    return platform;
    
}



#pragma mark - 注销方法




@end




