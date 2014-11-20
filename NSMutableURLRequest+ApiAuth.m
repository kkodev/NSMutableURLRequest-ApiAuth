//
//  NSMutableURLRequest+ApiAuth.m
//  NSMutableURLRequest+ApiAuth
//
//  Created by Kamil Kocemba on 19/08/2014.
//  Copyright (c) 2014 Kamil Kocemba. All rights reserved.
//

#import "NSMutableURLRequest+ApiAuth.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSMutableURLRequest (ApiAuth)

- (void)api_signRequestWithAccessId:(NSString *)accessId secretKey:(NSString *)secretKey {
    [self _setTimestamp];
    NSString *canonicalString = [self _canonicalString];
    
    const char *cKey = [secretKey cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [canonicalString cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *signature = [HMAC base64EncodedStringWithOptions:0];
    NSString *authorization = [NSString stringWithFormat:@"APIAuth %@:%@", accessId, signature];
    
    [self setValue:authorization forHTTPHeaderField:@"Authorization"];
}

#pragma mark - Private

- (void)_setTimestamp {
    
    NSLocale *safeLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = safeLocale;

    dateFormatter.dateFormat = @"EE, d MMM YYYY HH:mm:ss";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    NSString *dateString = [NSString stringWithFormat:@"%@ GMT", [dateFormatter stringFromDate:[NSDate date]]];
    [self setValue:dateString forHTTPHeaderField:@"Date"];
}

- (NSString *)_canonicalString {
    NSArray *contentTypeHeaders = @[ @"CONTENT-TYPE", @"CONTENT_TYPE", @"HTTP_CONTENT_TYPE" ];
    NSArray *contentMD5Headers = @[ @"CONTENT-MD5", @"CONTENT_MD5", @"HTTP_CONTENT_MD5" ];
    NSArray *timestampHeaders = @[ @"DATE", @"HTTP_DATE" ];
    
    NSString *contentType = [self _findHeaderWithKeys:contentTypeHeaders];
    NSString *contentMD5= [self _findHeaderWithKeys:contentMD5Headers];
    NSString *timestamp = [self _findHeaderWithKeys:timestampHeaders];
    NSString *uri = self.URL.path;
    
    NSString *params = self.URL.parameterString;
    if (params) {
        uri = [uri stringByAppendingFormat:@";%@",params];
    }
    
    NSString *query = self.URL.query;
    if (query) {
        uri = [uri stringByAppendingFormat:@"?%@",query];
    }
    
    NSString *fragment = self.URL.fragment;
    if (fragment) {
        uri = [uri stringByAppendingFormat:@"#%@",fragment];
    }

    return [NSString stringWithFormat:@"%@,%@,%@,%@", contentType, contentMD5, uri, timestamp];
}

- (NSString *)_findHeaderWithKeys:(NSArray *)keys {
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [self.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        headers[key.uppercaseString] = obj;
    }];
    
    __block NSString *value;
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        value = headers[key];
        if (value)
            *stop = YES;
    }];
    return value ?: @"";
}

@end
