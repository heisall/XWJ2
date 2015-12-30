//
//  XWJSHuoViewController.m
//  XWJ
//
//  Created by Sun on 15/12/20.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJSHuoViewController.h"
#import "XWJWebViewController.h"
#import "LCBannerView.h"
#import "XWJShuoListViewController.h"
#define PADDINGTOP 64.0
@interface XWJSHuoViewController()<LCBannerViewDelegate>{
    CGFloat typeBtnheight;
}

@property NSMutableArray *array1;
@property NSMutableArray *array2;
@property NSMutableArray *array3;
@property NSMutableArray *array4;
@property NSInteger selecttype;
@property NSMutableArray *adArr;
@property NSMutableArray *adleftArr;
@property NSMutableArray *adrightArr;

@property NSMutableArray *thumbArr;

@property NSMutableArray *btn;
@property UIView * typeContainView;
@property UIView *adView;
@property UIScrollView *scroll;
@end

@implementation XWJSHuoViewController

@synthesize array1,array2,array3,array4,scroll;
-(void)viewDidLoad{
    [super viewDidLoad];
    
    array1 =[NSMutableArray array ];
    array2 =[NSMutableArray array ];
    array3 =[NSMutableArray array ];
    array4 =[NSMutableArray array ];

    self.automaticallyAdjustsScrollViewInsets = NO;
    scroll  =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    [self.view addSubview:scroll];
    scroll.contentSize = CGSizeMake(SCREEN_SIZE.width, SCREEN_SIZE.height+100);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    [self addView];
    [self getGShuoAD];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    UIImage *image = [UIImage imageNamed:@"gouwuche"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(gouwuche) forControlEvents:UIControlEventTouchUpInside];
//    [btn setTitle:@"购物车" forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.navigationItem.title = @"生活";

//    self.view.backgroundColor = [UIColor redColor];
    
//    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
//    label.text = @"HIELLO";
//    label.backgroundColor = [UIColor redColor];
//    [self.view addSubview:label];

}
-(void)gouwuche{
            UIStoryboard *car  = [UIStoryboard storyboardWithName:@"XWJCarStoryboard" bundle:nil];
    [self.navigationController showViewController:[car instantiateInitialViewController] sender:self];
}
- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
    NSLog(@"you clicked image in %@ at index: %ld", bannerView, (long)index);
    
    if (self.adArr) {
        if ([[[self.adArr objectAtIndex:index] objectForKey:@"Types"] isEqualToString:@"外链"]) {
            XWJWebViewController *web = [[XWJWebViewController alloc] init];
            
            NSString *url  = [[self.adArr objectAtIndex:index] objectForKey:@"url"];
            web.url = url;
            [self.navigationController  showViewController:web sender:self];
        }
    }
    //        UIStoryboard *FindStory =[UIStoryboard storyboardWithName:@"FindStoryboard" bundle:nil];
    //        UIViewController *mesCon = [FindStory instantiateViewControllerWithIdentifier:@"activityDetail"];
    //        XWJNoticeViewController *notice = [self.storyboard instantiateViewControllerWithIdentifier:@"noticeController"];
    //        [self.navigationController showViewController:notice sender:nil];
    NSLog(@"notice click");
    
}

-(void)addView{
    self.adView =[[UIView alloc] initWithFrame:CGRectMake(0, PADDINGTOP, SCREEN_SIZE.width, SCREEN_SIZE.height/4)];
    
    self.btn = [NSMutableArray array];
    NSInteger count = 4;
    CGFloat width = self.view.bounds.size.width/4;
    CGFloat height = 60;
    CGFloat btny = self.adView.frame.origin.y+self.adView.bounds.size.height+10;
    NSArray * title = [NSArray arrayWithObjects:@"上门",@"商户",@"商品",@"家装", nil];
    for (int i=0; i<count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width*i, btny, width, height);
        button.tag = i;
        
        [button setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"shuoselect"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"shuonormal"] forState:UIControlStateNormal];
        
        [button setTitleColor:XWJColor(77, 78, 79) forState:UIControlStateNormal];
        [button setTitleColor:XWJGREENCOLOR forState:UIControlStateSelected];
        
        //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        ////        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        //        [button setImageEdgeInsets:UIEdgeInsetsMake(5, 20, 0, 0)];
        //        [button setTitleEdgeInsets:UIEdgeInsetsMake(45, -25, 0, 0)];
        //        button.backgroundColor = [UIColor whiteColor];
        
        [button addTarget:self action:@selector(typeclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn addObject:button];
        [scroll addSubview:button];
    }
    ((UIButton*)self.btn[0]).selected=YES;
    _typeContainView = [[UIView alloc] initWithFrame:CGRectMake(0, btny+60, SCREEN_SIZE.width, SCREEN_SIZE.height-btny)];
//    _typeContainView.backgroundColor = [UIColor redColor];
    [scroll addSubview:_typeContainView];
    [scroll addSubview:self.adView];
}

-(void)addTypeOneView:(NSArray*)arr{
    NSInteger hang = 4;
    CGFloat paddingLeft =20;
    CGFloat paddingTop = 110;
    NSInteger count = arr.count;
    CGFloat width = self.view.bounds.size.width/hang;
    CGFloat height = width;
//    NSArray * title = [NSArray arrayWithObjects:@"上门",@"商户",@"商品",@"家装", nil];
    for (int i=0; i<count; i++) {
        
        if (i>7) {
            break;
        }

            UIImageView *button = [[UIImageView alloc] init];
            
            button.frame = CGRectMake(width*(i%hang)+paddingLeft/2, paddingLeft+i/hang*paddingTop, width-paddingLeft, height-paddingLeft);
            button.tag = 1000+i;
            button.userInteractionEnabled = YES;
            
            NSString *url;
            if ([[arr objectAtIndex:i] valueForKey:@"thumb"] != [NSNull null]) {
                url = [[arr objectAtIndex:i] valueForKey:@"thumb"];
            }else{
                url = @"";
            }
            
            [button sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
            UITapGestureRecognizer* singleRecognizer;
            singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
            //点击的次数
            singleRecognizer.numberOfTapsRequired = 1;
            [button addGestureRecognizer:singleRecognizer];
            UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(width*(i%hang)+width/3.5, paddingLeft+i/hang*paddingTop+height-20, 50, 30)];

            label.text = [[arr objectAtIndex:i] valueForKey:@"cateName"];
            [self.typeContainView addSubview:label];
            [self.typeContainView addSubview:button];

    }
    
    CGFloat img_width = self.view.bounds.size.width/2;
    CGFloat img_height = width;
    
    for (int i=0; i<2; i++) {
        
        UIImageView *button = [[UIImageView alloc] init];
        
        button.frame = CGRectMake((img_width+5)*(i), 2*height+60+self.typeContainView.frame.origin.y+paddingLeft+i/hang*paddingTop, img_width, img_height-paddingLeft);
        button.tag = 1000+i;
        button.userInteractionEnabled = YES;
        
        NSString *url ;
        if (i==0) {
            url = [NSString stringWithFormat:@"%@",[[self.adleftArr objectAtIndex:0]objectForKey:@"Photo"]];
        }else
            url = [NSString stringWithFormat:@"%@",[[self.adrightArr objectAtIndex:0]objectForKey:@"Photo"]];

        [button sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgesingleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1;
        [button addGestureRecognizer:singleRecognizer];
        [self.scroll addSubview:button];
    }
}

-(void)imgesingleTap:(UITapGestureRecognizer *)image{
}
-(void)singleTap:(UITapGestureRecognizer *)image{
    NSInteger index = image.view.tag;
    NSLog(@"single tap %lu",index);
    NSArray *array ;
    switch (_selecttype) {
        case 1:
            array = array1;
            break;
        case 2:
            array = array2;
            break;
        case 3:
            array = array3;
            break;
        case 4:
            array = array4;
            break;
        default:
            break;
    }
    
    XWJShuoListViewController * list= [[XWJShuoListViewController alloc] init];
    list.dic = [array objectAtIndex:index-1000];
    [self.navigationController showViewController:list sender:self];
}

-(void)getGShuoAD{
    NSString *url = GETLIFEAD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

//    NSString *aid = [[NSUserDefaults standardUserDefaults] objectForKey:@"a_id"];
    
//    [dict setValue:@"1" forKey:@"a_id"];
//    [dict setValue:[XWJAccount instance].uid forKey:@"userid"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            
            _selecttype = 1;
            self.adArr = [dic objectForKey:@"ad"];
            self.adleftArr = [dic objectForKey:@"ad_left"];
            self.adrightArr = [dic objectForKey:@"ad_right"];

//            self.thumbArr = [dic objectForKey:@"jz"];
            self.array1 =  [dic objectForKey:@"sm"];
            self.array2 =  [dic objectForKey:@"sh"];
            self.array3 =  [dic objectForKey:@"sp"];
            self.array4 =  [dic objectForKey:@"jz"];
            
            NSMutableArray *URLs = [NSMutableArray array];
            for (NSDictionary
                 *dic in self.adArr) {
                [URLs addObject:[dic valueForKey:@"Photo"]];
            }
            
            
//            for (NSDictionary *d in self.thumbArr) {
//                NSNumber *num  =[d objectForKey:@"parent_id"];
//                switch ([num intValue]) {
//                    case 1:
//                        [self.array1 addObject:d];
//                        break;
//                    case 2:
//                        [self.array2 addObject:d];
//                        break;
//                    case 3:
//                        [self.array3 addObject:d];
//                        break;
//                    case 4:
//                        [self.array4 addObject:d];
//                        break;
//                    default:
//                        break;
//                }
//                
//            }
            [self addTypeOneView:self.array1];

            if(URLs&&URLs.count>0)
                [self.adView addSubview:({
                    
                    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                                                            self.adView.bounds.size.height)
                                                
                                                                        delegate:self
                                                                       imageURLs:URLs
                                                                placeholderImage:@"devAdv_default"
                                                                   timerInterval:3.0f
                                                   currentPageIndicatorTintColor:[UIColor redColor]
                                                          pageIndicatorTintColor:[UIColor whiteColor]];
                    bannerView;
                })];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)typeclick:(UIButton *)butn{
    NSInteger index = butn.tag;
    for (UIButton *b in self.btn) {
        b.selected = NO;
    }
    butn.selected = !butn.selected;
    _selecttype = index+1;
    
    for (UIView * v in self.typeContainView.subviews) {
        [v removeFromSuperview];
    }
    NSArray *array ;
    switch (_selecttype) {
        case 1:
            array = array1;
            break;
        case 2:
            array = array2;
            break;
        case 3:
            array = array3;
            break;
        case 4:
            array = array4;
            break;
        default:
            break;
    }
    
    [self addTypeOneView:array];
}

@end
