//
//  LJJArticle.m
//  DiaryDemo
//
//  Created by Jun on 14-1-14.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import "LJJArticle.h"

@implementation LJJArticle
- (id)init {
    if (self = [super init]) {
        self.create_time = [NSDate date];
    }
    return self;
}

- (NSDate *)update_time {
    return _update_time == nil?[NSDate date]:_update_time;
}
@end
