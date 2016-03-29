//
//  XWJGZmiaoshuViewController.m
//  XWJ
//
//  Created by Sun on 15/12/12.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJGZmiaoshuViewController.h"
#import "XWJGZJudgeViewController.h"
#import "ProgressHUD.h"
#import "XWJWebViewController.h"
@interface XWJGZmiaoshuViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *guzhangDanhao;
@property (weak, nonatomic) IBOutlet UILabel *connent;
@property (weak, nonatomic) IBOutlet UIScrollView *jinchangScroll;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel3;
@property (weak, nonatomic) IBOutlet UILabel *shoujihao;

@property (weak, nonatomic) IBOutlet UILabel *chuliRen;
@property (weak, nonatomic) IBOutlet UIImageView *gzStartImageV;
@property (weak, nonatomic) IBOutlet UIImageView *gzMidImageV;
@property (weak, nonatomic) IBOutlet UIImageView *gzEndImageV;

@property NSArray *imageArray;
@end

@implementation XWJGZmiaoshuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [[NSArray alloc]init];
    // Do any additional setup after loading the view.
    if (self.type == 1) {
        self.navigationItem.title = @"报修详情";
    }else{
        self.navigationItem.title = @"投诉详情";
        UILabel *label = (UILabel*)[self.view viewWithTag:1992];
        label.text = @"投诉受理进程";
    }
    
    [self getGZDetail];

}
-(void)createScrollV{
    
    UIView *v = (UIView *)[self.view viewWithTag:1995];
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 24, v.bounds.size.height)];
    scrollV.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.93 alpha:1];
    // scrollV.backgroundColor = [UIColor lightGrayColor];
    scrollV.delegate = self;
    
    scrollV.pagingEnabled = YES;
    scrollV.bounces = YES;
    scrollV.contentOffset = CGPointMake(0, 0);
    scrollV.contentSize = CGSizeMake(self.imageArray.count *85, v.bounds.size.height);
    
    [v addSubview:scrollV];
    
    for (int i=0; i<_imageArray.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(85*i, 0, 80, v.bounds.size.height);
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]]placeholderImage:nil];
        CLog(@"//////%@",_imageArray[i]);
        UITapGestureRecognizer* singleRecognizer;
        imageV.userInteractionEnabled = YES;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgclick:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1;
        imageV.tag = i +666;
        [imageV addGestureRecognizer:singleRecognizer];
        [scrollV addSubview:imageV];
    }
}

-(void)imgclick:(UITapGestureRecognizer*)sender{
    
    XWJWebViewController * web = [[XWJWebViewController alloc] init];
    UITapGestureRecognizer * singleTap = (UITapGestureRecognizer *)sender;
    NSString *urls = _imageArray[(long)[singleTap view].tag-666]==[NSNull null]?@"":_imageArray[(long)[singleTap view].tag-666];
    
    NSArray *url = [urls componentsSeparatedByString:@","];
    web.url = [url objectAtIndex:0];
    //   self.shareImageStr = [url firstObject];
    [self.navigationController pushViewController:web animated:NO];
}

    


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.jinchangScroll.frame = CGRectMake(self.jinchangScroll.frame.origin.x, self.jinchangScroll.frame.origin.y, SCREEN_SIZE.width, self.jinchangScroll.frame.size.height+30);
    self.tabBarController.tabBar.hidden =YES;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden =NO;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getGZDetail{
        NSString *url = GETFGUZHANGDETAIL_URL;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[self.detaildic objectForKey:@"id"] forKey:@"id"];
//        XWJAccount *account = [XWJAccount instance];
//        [dict setValue:account.uid forKey:@"id"];
//        if (self.type==1) {
//
//            [dict setValue:@"维修" forKey:@"type"];
//        }else
//            [dict setValue:@"投诉" forKey:@"type"];
        
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            CLog(@"%s success ",__FUNCTION__);
            CLog(@"%@", responseObject);
            
            
            /*
             {"result":"1","data":{"id":20,"code":"1-20151214020","createtime":"12-14 13:10","miaoshu":"内容","zt":"未受理","hfzt":null,"xing":-1,"yytime":"12-14 13:10","yytime1":"1-1 shangwu","slname":null,"gbtime":null,"lwpgsj":null,"lwclr":null,"leixing":"维修"},"errorCode":null}
             */
            if(responseObject){
                NSDictionary *dic = (NSDictionary *)responseObject;
                CLog(@"dic !!!!!!%@",dic);
                 self.detaildic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"data"]];
                NSDictionary *imagedic = [[NSDictionary alloc]init];
                imagedic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"data"]];
                CLog(@"dic%@",[imagedic objectForKey:@"fj"]);
                NSString *str = [[NSString alloc]init];
                str = [imagedic objectForKey:@"fj"];
                _imageArray = [str componentsSeparatedByString:@","];
                CLog(@"***%@",_imageArray);
                [self updateView];
                [self createScrollV];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            CLog(@"%s fail %@",__FUNCTION__,error);
            
        }];
    
}

-(void)updateView{
    self.guzhangDanhao.text = [NSString stringWithFormat:@"%@",[self.detaildic objectForKey:@"code"]];
    self.connent.text  = [NSString stringWithFormat:@"%@",[self.detaildic objectForKey:@"miaoshu"]];
//    self.chuliRen.text = [NSString stringWithFormat:@"处理人：%@",[self.detaildic objectForKey:@"lwclr"]==[NSNull null]?@"":[self.detaildic objectForKey:@"lwclr"]];
//    self.shoujihao.text = [NSString stringWithFormat:@"手机号：%@",[self.detaildic objectForKey:@"lwpgsj"]==[NSNull null]?@"":[self.detaildic objectForKey:@"lwpgsj"]];
    self.timeLabel1.text = [NSString stringWithFormat:@"%@",[self.detaildic objectForKey:@"yytime"]==[NSNull null]?@"":[self.detaildic objectForKey:@"yytime"]];
    self.timeLabel2.text = [NSString stringWithFormat:@"%@",[self.detaildic objectForKey:@"yytime1"]==[NSNull null]?@"":[self.detaildic objectForKey:@"yytime1"]];
    self.timeLabel3.text = [NSString stringWithFormat:@"%@",[self.detaildic objectForKey:@"gbtime"]==[NSNull null]?@"":[self.detaildic objectForKey:@"gbtime"]];
    UIButton *btn = (UIButton*)[self.view viewWithTag:1991];
    self.gzStartImageV.image = [UIImage imageNamed:@"tsstart1"];
    self.gzMidImageV.image = [UIImage imageNamed:@"tsmid"];
    self.gzEndImageV.image = [UIImage imageNamed:@"tsend"];
    btn.hidden = YES;
        if ([self.detaildic objectForKey:@"lwpgsj"]==[NSNull null]) {
            self.gzMidImageV.image = [UIImage imageNamed:@"tsmid"];
            self.gzEndImageV.image = [UIImage imageNamed:@"tsend"];
            btn.hidden = YES;
            UILabel *label  = (UILabel*)[self.view viewWithTag:1996];
            label.hidden = YES;
            UILabel *label1  = (UILabel*)[self.view viewWithTag:1997];
            label1.hidden = YES;
            UILabel *label2  = (UILabel*)[self.view viewWithTag:1998];
            label2.hidden = YES;
        }else{
            self.gzMidImageV.image = [UIImage imageNamed:@"tsmid1"];
            if ([self.detaildic objectForKey:@"gbtime"]==[NSNull null]) {
                self.gzEndImageV.image = [UIImage imageNamed:@"tsend"];
                btn.hidden = YES;
                UILabel *label  = (UILabel*)[self.view viewWithTag:1996];
                label.hidden = NO;
                UILabel *label1  = (UILabel*)[self.view viewWithTag:1997];
                label1.hidden = YES;
                UILabel *label2  = (UILabel*)[self.view viewWithTag:1998];
                label2.hidden = YES;

               
            }else{
                self.gzEndImageV.image = [UIImage imageNamed:@"tsend1"];
                btn.hidden = NO;
                UILabel *label  = (UILabel*)[self.view viewWithTag:1996];
                label.hidden = NO;
                UILabel *label1  = (UILabel*)[self.view viewWithTag:1997];
                label1.hidden = NO;
                UILabel *label2  = (UILabel*)[self.view viewWithTag:1998];
                label2.hidden = NO;

            }
        }
    }


- (IBAction)pingjia:(UIButton *)sender {
    
    NSString *xing = [NSString  stringWithFormat:@"%@",[self.detaildic objectForKey:@"xing"]];
    if ([xing intValue]==-1) {
        XWJGZJudgeViewController *jubge = [self.storyboard instantiateViewControllerWithIdentifier:@"gzpingjia"];
        jubge.gzid = [self.detaildic objectForKey:@"id"];
        jubge.miaoshu = [self.detaildic objectForKey:@"miaoshu"];
        [self.navigationController pushViewController:jubge animated:YES ];
    }else{
        [ProgressHUD showSuccess:@"已评价"];
    }
}


@end
