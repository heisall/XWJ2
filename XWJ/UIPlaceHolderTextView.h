//
//  UIPlaceHolderTextView.h
//  MIX
//
//  Created by tinny on 14-4-3.
//  Copyright (c) 2014年 hisense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic, retain) NSNumber *maxCount;
@property (nonatomic, retain) UILabel *countLabel;

-(void)textChanged:(NSNotification*)notification;
-(void)cleanStatus;
-(void)setCountLabelHidden:(BOOL)hidden;
@end
