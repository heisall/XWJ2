//
//  XWJGuanjiaViewController.m
//  XWJ
//
//  Created by Sun on 15/12/7.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJGuanjiaViewController.h"
#import "AFNetworking.h"
@interface XWJGuanjiaViewController ()
@property NSMutableArray *notices;
@property NSMutableArray *shows ;
@end

@implementation XWJGuanjiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//NSString *url = GETAD_URL;
//AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//NSMutableDictionary *dict = [NSMutableDictionary dictionary];
////    [dict setValue:[XWJCity instance].aid  forKey:@"a_id"];
//[dict setValue:@"1"  forKey:@"a_id"];
//
//
//manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
//[manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    NSLog(@"%s success ",__FUNCTION__);
//    
//    if(responseObject){
//        NSDictionary *dic = (NSDictionary *)responseObject;
//        NSLog(@"dic %@",dic);
//        
//        self.notices = [dic objectForKey:@"notices"];
//        self.shows = [dic objectForKey:@"topad"];
//        
//        NSMutableArray *titls = [NSMutableArray array];
//        for (NSDictionary *dic in self.notices) {
//            [titls addObject:[dic valueForKey:@"title"]];
//        }
//        
//        NSMutableArray *URLs = [NSMutableArray array];
//        for (NSDictionary
//             *dic in self.shows) {
//            [URLs addObject:[dic valueForKey:@"Photo"]];
//            
//        }
//        
//        if(URLs&&URLs.count>0)
//            [self.adScrollView addSubview:({
//                
//                LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
//                                                                                        self.adScrollView.bounds.size.height)
//                                            
//                                                                    delegate:self
//                                                                   imageURLs:URLs
//                                                            placeholderImage:@"devAdv_default"
//                                                               timerInterval:3.0f
//                                               currentPageIndicatorTintColor:[UIColor redColor]
//                                                      pageIndicatorTintColor:[UIColor whiteColor]];
//                bannerView;
//            })];
//        
//        if (titls&&titls.count>0)
//            [self.mesScrollview addSubview:({
//                
//                LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
//                                                                                        self.mesScrollview.bounds.size.height)
//                                            
//                                                                    delegate:self
//                                                                      titles:titls timerInterval:2.0
//                                               currentPageIndicatorTintColor:[UIColor clearColor] pageIndicatorTintColor:[UIColor clearColor]];
//                bannerView;
//            })];
//        
//    }
//    
//    
//} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    NSLog(@"%s fail %@",__FUNCTION__,error);
//    
//}];

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
