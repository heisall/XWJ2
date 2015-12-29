//
//  XWJShangmenViewController.m
//  XWJ
//
//  Created by Sun on 15/12/25.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJShangmenViewController.h"
#import "LCBannerView.h"
#import "XWJADViewController.h"
#import "XWJShuoListViewController.h"
@interface XWJShangmenViewController ()<LCBannerViewDelegate>
@property NSMutableArray *adArr;
@property NSMutableArray *thumb;
@property UIView *adView;
@property UIScrollView *scroll;
@end
#define PADDINGTOP 64.0
#define PADDINGBOTTOM 44.0
@implementation XWJShangmenViewController
@synthesize scroll;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.adView =[[UIView alloc] initWithFrame:CGRectMake(0, PADDINGTOP, SCREEN_SIZE.width, SCREEN_SIZE.height/4)];
    
    scroll =  [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.adView.frame.origin.y+self.adView.bounds.size.height+10, SCREEN_SIZE.width, SCREEN_SIZE.height-PADDINGBOTTOM-PADDINGTOP-self.adView.bounds.size.height)];
    
    self.navigationItem.title = @"便民信息";
    
    [self.view addSubview:self.adView];
    [self.view addSubview:scroll];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getShangmen];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getShangmen{
    NSString *url = GETSHANGMENAD_URL;
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
            
            self.adArr = [dic objectForKey:@"ad"];
            self.thumb = [dic objectForKey:@"thumb"];
            NSMutableArray *URLs = [NSMutableArray array];
            for (NSDictionary
                 *dic in self.adArr) {
                [URLs addObject:[dic valueForKey:@"Photo"]];
                
            }
            [self addView];
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

- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
    NSLog(@"you clicked image in %@ at index: %ld", bannerView, (long)index);

    
        XWJADViewController *acti= [[XWJADViewController alloc] init];
        acti.dic  = [self.adArr objectAtIndex:index];
//                acti.type = [acti.dic valueForKey:@"Types"];
    
        [self.navigationController showViewController:acti sender:nil];
    
}

-(void)addView{
    
    NSInteger count = self.thumb.count;
    CGFloat width  = SCREEN_SIZE.width/2-10;
    CGFloat height  = 60.0;
    for (int i =0; i<count; i++) {
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(i%2*width,i/2*(height+5) , width, height)];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(1,1 , height-1, height-1)];
        img.tag = 1000+i;
        img.userInteractionEnabled = YES;
        UILabel * label  =  [[UILabel alloc] initWithFrame:CGRectMake(width-60, 15, 60, 30)];
        [img sd_setImageWithURL:[NSURL URLWithString:[[self.thumb objectAtIndex:i] valueForKey:@"thumb"]]];
        label.text = [[self.thumb objectAtIndex:i] valueForKey:@"cateName"];
        
        
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1;
        [img addGestureRecognizer:singleRecognizer];
        
        [view addSubview:img];
        [view addSubview:label];
        [scroll addSubview:view];
        scroll.contentSize = CGSizeMake(0, height
                                        *(count/2+1)+PADDINGBOTTOM);
    }
    
}

-(void)singleTap:(UITapGestureRecognizer *)image{
    NSInteger index = image.view.tag;
    NSLog(@"single tap %lu",index);
    XWJShuoListViewController * list= [[XWJShuoListViewController alloc] init];
    list.dic = [self.thumb objectAtIndex:index-1000];
    [self.navigationController showViewController:list sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
