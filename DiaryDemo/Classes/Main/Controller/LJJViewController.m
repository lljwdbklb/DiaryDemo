//
//  LJJViewController.m
//  DiaryDemo
//
//  Created by Jun on 14-1-14.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import "LJJViewController.h"

#import "LJSQLite.h"
#import "LJJArticle.h"
#import "NSDate+String.h"

#import "LJJEditorViewController.h"

@interface LJJViewController ()
{
    NSMutableArray * _dataList;
}
@end

@implementation LJJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _dataList = [NSMutableArray arrayWithArray:[[LJSQLite sharedLJSQLite]objectsWithObjClass:[LJJArticle class] whereParams:nil orderBy:@{@"create_time":kOrderByDESC} limit:NSMakeRange(0, 0) count:nil]];
    [self.tableView reloadData];
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellID = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    LJJArticle * article = _dataList[indexPath.row];
    cell.textLabel.text = article.text;
    cell.detailTextLabel.text = [article.update_time currentTimeStr];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
//        NSLog(@"删除");
        LJJArticle * a = _dataList[indexPath.row];
        [[LJSQLite sharedLJSQLite] deleteObject:a];
        [_dataList removeObject:a];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LJJArticle * a = _dataList[indexPath.row];
    [self performSegueWithIdentifier:@"EditorSeg" sender:a];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender) {
        LJJEditorViewController * edit = segue.destinationViewController;
        edit.article = sender;
    }
}

#pragma mark - 点击事件
- (IBAction)clickAdd:(id)sender {
    [self performSegueWithIdentifier:@"EditorSeg" sender:nil];
}

@end
