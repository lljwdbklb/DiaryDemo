//
//  LJJEditorViewController.m
//  DiaryDemo
//
//  Created by Jun on 14-1-14.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import "LJJEditorViewController.h"

#import "LJJTextView.h"

#import "LJJArticle.h"

#import "LJSQLite.h"
#import "NSString+Helper.h"


@interface LJJEditorViewController ()
@property (weak, nonatomic) IBOutlet LJJTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@end

@implementation LJJEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.placeholder = @"分享新鲜事";
    
    if (_article) {
        _textView.text = _article.text;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //键盘变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

#pragma mark 键盘变化通知
- (void)keyboardChangeFrame:(NSNotification *)notification  {
    NSLog(@"%@",notification.userInfo);
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (frame.origin.y >= self.view.frame.size.height) {
        _bottom.constant = 0.0;
    } else {
        _bottom.constant = frame.size.height;
    }
}

#pragma mark - 返回
- (void)back {
    LJJArticle * article = _article;
    if (article == nil && [_textView.text trimString].length > 0) {//为空才添加新数据
        article = [[LJJArticle alloc]init];
        article.text = [self.textView.text trimString];
        [[LJSQLite sharedLJSQLite] addObject:article];
    } else if(![article.text isEqualToString:_textView.text]){//数据不重复才更新
        article.text = [self.textView.text trimString];
        article.update_time = [NSDate date];
        [[LJSQLite sharedLJSQLite] updateObject:article];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
