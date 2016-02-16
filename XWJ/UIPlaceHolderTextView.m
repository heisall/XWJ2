//
//  UIPlaceHolderTextView.m
//  MIX
//
//  Created by tinny on 14-4-3.
//  Copyright (c) 2014年 hisense. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

#import "UIPlaceHolderTextView.h"

@interface UIPlaceHolderTextView ()<UITextViewDelegate>

@property (nonatomic, retain) UILabel *placeHolderLabel;

@end

@implementation UIPlaceHolderTextView
{
    BOOL isInit;
}
CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    [_placeHolderLabel release]; _placeHolderLabel = nil;
    [_placeholderColor release]; _placeholderColor = nil;
    [_placeholder release]; _placeholder = nil;
    [super dealloc];
#endif
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    [self drawUI];
    isInit = NO;
}

-(void)drawUI
{
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 55, self.frame.size.height -5, 62, 14)];
    [self cleanStatus];
    self.countLabel.font = [UIFont systemFontOfSize:14];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    self.countLabel.textColor = [UIColor lightGrayColor];
    self.countLabel.tag = 1000;
    self.delegate = self;
    [[self superview]addSubview:self.countLabel];
    self.tintColor = [UIColor blueColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)textViewDidChange:(UITextView *)textView
{
    int len = (int)textView.text.length;
    
    //调整textView大小
    if (isInit) {
        if (textView.contentSize.height >= 44) {
            CGRect frame = textView.frame;
            frame.size.height = textView.contentSize.height;
            CGFloat diff = textView.contentSize.height - textView.frame.size.height;
            frame.origin.y = textView.frame.origin.y - diff;
            textView.frame = frame;
            UILabel *count = (UILabel *)[textView viewWithTag:1000];
            count.frame =CGRectMake(frame.size.width - 50, frame.size.height - 15, 50, 14);
        }
    }
    if (len > [self.maxCount intValue]) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i/%@",len,self.maxCount]];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,[NSString stringWithFormat:@"%i",len].length)];
        self.countLabel.attributedText = string;
        if (textView.markedTextRange == nil && textView.text.length > [self.maxCount intValue]) {
            // Perform change
            NSString *subString =  [textView.text substringToIndex:[self.maxCount intValue]];
            textView.text = subString;
            
            self.countLabel.text=[NSString stringWithFormat:@"%@/%@",self.maxCount,self.maxCount];
            self.countLabel.textColor = [UIColor lightGrayColor];

        }
    } else {
        self.countLabel.text=[NSString stringWithFormat:@"%i/%@",len,self.maxCount];
        self.countLabel.textColor = [UIColor lightGrayColor];

    }
    
}

//初始化尺寸
- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [self drawUI];
        isInit = YES;
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
        if([[self text] length] == 0)
        {
            [[self viewWithTag:999] setAlpha:1];
        }
        else
        {
            [[self viewWithTag:999] setAlpha:0];
        }
    }];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if (_placeHolderLabel == nil )
        {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

-(void)setCountLabelHidden:(BOOL)hidden
{
    if (self.countLabel)
    {
        self.countLabel.hidden = hidden;

    }
}


-(void)cleanStatus
{
    if (self.tag == 0) {
        self.maxCount = @70;
    } else {
        self.maxCount = [NSNumber  numberWithInteger: self.tag];
    }
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    self.countLabel.text = [NSString stringWithFormat:@"0/%@",self.maxCount];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *finalString = [textView.text stringByAppendingString:text];
    if (finalString.length <= [self.maxCount intValue] || [text isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}
@end
