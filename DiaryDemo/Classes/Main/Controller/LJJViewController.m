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

@interface LJJViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSMutableArray * _dataList;
    NSMutableArray * _searchResults;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation LJJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"记事本";
    //用于隐藏searchBar
    self.tableView.contentOffset = CGPointMake(0, CGRectGetMaxY(_searchBar.frame));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _dataList = [NSMutableArray arrayWithArray:[[LJSQLite sharedLJSQLite]objectsWithObjClass:[LJJArticle class] whereParams:nil orderBy:@{@"create_time":kOrderByDESC} limit:NSMakeRange(0, 0) count:nil]];
    [self.tableView reloadData];
}

#pragma mark - searchBar代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchResults = [NSMutableArray array];
    NSString * whereStr = [NSString stringWithFormat:@" WHERE text LIKE '%%%@%%' ",searchBar.text];
    
    _searchResults = [NSMutableArray arrayWithArray:[[LJSQLite sharedLJSQLite] objectsWithObjClass:[LJJArticle class] whereStr:whereStr orderBy:@{@"create_time":kOrderByDESC} limit:NSMakeRange(0, 0) count:nil]];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark - tableview数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {//搜索tableview
        return _searchResults.count;
    }
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellID = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    LJJArticle * article = nil;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {//搜索tableview
        article = _searchResults[indexPath.row];
    } else {
        article = _dataList[indexPath.row];
    }
    
    cell.textLabel.text = article.text;
    cell.detailTextLabel.text = [article.update_time currentTimeStr];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle && ![tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
//        NSLog(@"删除");
        LJJArticle * a = _dataList[indexPath.row];
        [[LJSQLite sharedLJSQLite] deleteObject:a];
        [_dataList removeObject:a];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LJJArticle * article = nil;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {//搜索tableview
        article = _searchResults[indexPath.row];
    } else {
        article = _dataList[indexPath.row];
    }
    //跳转
    [self performSegueWithIdentifier:@"EditorSeg" sender:article];
}
#pragma mark 用Storyboard push跳转中介方法
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
