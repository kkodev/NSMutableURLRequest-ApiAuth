//
//  NSMutableURLRequest+ApiAuth.h
//  NSMutableURLRequest+ApiAuth
//
//  Created by Kamil Kocemba on 19/08/2014.
//  Copyright (c) 2014 Kamil Kocemba. All rights reserved.
//

@interface NSMutableURLRequest (ApiAuth)

- (void)api_signRequestWithAccessId:(NSString *)accessId secretKey:(NSString *)secretKey;

@end
