//
//  LJJTextView.m
//  DiaryDemo
//
//  Created by Jun on 14-1-14.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import "LJJTextView.h"

@implementation LJJTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
        
        // 2.默认颜色
        _placeholderColor = [UIColor grayColor];
    }
    return self;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)note {
    if (_placeholder.length == 0) return;
    [self setNeedsDisplay];
}

- (void)textDidChange:(NSNotification *)note
{
    if (_placeholder.length == 0) return;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    if (_placeholder.length == 0) return;
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if (_placeholder.length == 0 || self.text.length != 0) return;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    if (_placeholder.length == 0 || self.text.length != 0) return;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.text.length == 0) {
        [_placeholderColor set];
        CGFloat padding = 8;
        CGRect placeholderRect = CGRectMake(padding, padding, rect.size.width - padding * 2, rect.size.height - padding);
        [_placeholder drawInRect:placeholderRect withFont:self.font];
    }
}

@end
