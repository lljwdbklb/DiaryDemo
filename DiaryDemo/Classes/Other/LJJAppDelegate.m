//
//  LJJAppDelegate.m
//  DiaryDemo
//
//  Created by Jun on 14-1-14.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import "LJJAppDelegate.h"

#import "LJSQLite.h"
#import "LJJArticle.h"

@implementation LJJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * verson = [defaults objectForKey:@"verson"];
    if (!verson) {//判断是否第一次加载
        [[LJSQLite sharedLJSQLite] createTable:[LJJArticle class] autoincrement:YES];
        [defaults setObject:verson forKey:@"verson"];
        [defaults synchronize];
    }
    
    return YES;
}

@end
