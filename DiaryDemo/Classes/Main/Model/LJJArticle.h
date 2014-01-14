//
//  LJJArticle.h
//  DiaryDemo
//
//  Created by Jun on 14-1-14.
//  Copyright (c) 2014年 Jun. All rights reserved.
//
//  文章
//

#import <Foundation/Foundation.h>

@interface LJJArticle : NSObject
@property (assign, nonatomic)long long ID;
@property (copy, nonatomic)NSString * text;
@property (strong, nonatomic)NSDate * create_time;
@property (strong, nonatomic)NSDate * update_time;
@end
