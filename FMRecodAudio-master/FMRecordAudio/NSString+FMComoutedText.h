//
//  NSString+FMComoutedText.h
//  FMRecordAudio
//
//  Created by 范明 on 2019/8/2.
//  Copyright © 2019 范明. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSString (FMComoutedText)
/**
 *  判断字符串是否为空
 */
+ (BOOL)isBlankString:(NSString *)string;

/**
 *  去除html标签
 */

+ (NSString *)filterHTML:(NSString *)html;

/**
 *  key,value，设置不同的颜色
 */

+ (NSMutableAttributedString *)setKey:(NSString *)key withValue:(NSString *)value;

/**
 *  UTF8
 */
+ (NSString *)strUTF8Encoding:(NSString *)str;

/**
 *  正则去除标签
 */
+(NSString *)getZZwithString:(NSString *)string;
/**
 *  转化html标签为富文本
 */
+ (NSMutableAttributedString *)praseHtmlStr:(NSString *)htmlStr;

/** 获取系统当前时间 */
+ (NSString*)getCurrentDate;

/** 时间戳转成日期时间 */
+ (NSString*)getSeconds:(NSString*)seconds;

/** 获取生日 */
+ (NSString*)getBirthday:(NSString*)seconds;

/** 日期转成时间戳 */
+ (NSString*)getTimes:(NSString*)date;

+ (NSString*)getData:(NSString*)date;

/** 验证手机号码格式 */
+ (BOOL)verifyPhoneNumber:(NSString*)phonenum;

/** 验证身份证号码格式 */
+ (BOOL)verifyUserIdentifierNumber:(NSString*)identifiernum;

/************
 日期格式请传入：2013-08-05 12:12:12；如果修改日期格式，比如：2013-08-05，则将[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];修改为[df setDateFormat:@"yyyy-MM-dd"];
 ***********/
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02;

+(NSString *)getNowTimeTimestamp2;


+(NSString *)getHHMMSSFromSS:(NSString *)totalTime;


+(NSString *)getTwoMMSSFromSS:(NSString *)totalTime;

+(NSString *)getMMSSFromSS:(NSInteger )second;


//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

//获取年月日，不要时分秒
+ (NSString *)getyyyyMMdd:(NSString *)time;
@end


