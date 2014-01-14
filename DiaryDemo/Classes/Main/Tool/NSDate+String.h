//
//  NSDate+String.h
//  DiaryDemo
//
//  Created by Jun on 14-1-14.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (String)
- (NSDateComponents *)components;
- (NSString *)currentTimeStr;
@end
