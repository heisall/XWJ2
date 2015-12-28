//
//  TitleView.m
//  LoveFood
//
//  Created by qianfeng on 15/11/19.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView
{
    UIScrollView * scrollView;
    NSMutableArray * _array;
    UIView * _view;
    CGFloat _width;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _array = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setTitles:(NSArray *)titles
{
    [self addsubviewsWithTitles:titles];
}

-(void)addsubviewsWithTitles:(NSArray*)titles
{
    
    
    CGFloat width = self.frame.size.width/titles.count;
    CGFloat height = self.frame.size.height;
    _width = width;
    _view = [[UIView alloc]init];
    _view.backgroundColor = [UIColor colorWithRed:0.00 green:0.64 blue:0.65 alpha:1.00];
    _view.frame = CGRectMake(0, 40, width, 4);
    [self addSubview:_view];
    
    for (int i = 0; i < titles.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width*i, 0, width, height);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.58 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.00 green:0.64 blue:0.65 alpha:1] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        [_array addObject:button];
        
    }
}

-(void)buttonClick:(UIButton*)button
{
    int i = 0;
    for (UIButton * but in _array) {
        if (button == but ) {
            but.selected = YES;
            self.buttonSelectAtIndex(i);
            [UIView animateWithDuration:0.2 animations:^{
                _view.frame = CGRectMake(i*_width, 40, _width, 4);
            }];
            
        }else{
            but.selected = NO;
        }
        
        i++;
    }
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    
    for (int i = 0 ; i < _array.count; i++) {
        UIButton * button = _array[i];
        if (i == currentPage) {
            button.selected = YES;
            [UIView animateWithDuration:0.2 animations:^{
                _view.frame = CGRectMake(i*_width, 40, _width, 4);
            }];
        }else{
            button.selected = NO;
        }
    }
}

@end
