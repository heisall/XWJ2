//
//  XWJGZJudgeViewController.m
//  XWJ
//
//  Created by Sun on 15/12/12.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJGZJudgeViewController.h"
#import "RatingBar/RatingBar.h"
@interface XWJGZJudgeViewController ()
@property (weak, nonatomic) IBOutlet UIView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UITextView *conTV;
@property RatingBar *bar;
@end

@implementation XWJGZJudgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title  = @"评价";
    
    _bar = [[RatingBar alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width-200, 0, 180, 30)];
    _bar.backgroundColor = XWJColor(235.0, 237.0, 239.0);

    self.content.text = self.miaoshu;
    [self.rateView addSubview:_bar];

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

- (IBAction)submit:(UIButton *)sender {
    
    /*
     id	物业维修、投诉的id	String
     evaluate	评价内容	String
     star	星级	String
     */
    NSString *url = GETGUZHANGPINGJIA_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setValue:self.gzid forKey:@"id"];
    [diction setValue:self.conTV.text forKey:@"evaluate"];
    [diction setValue:[NSString stringWithFormat:@"%ld",self.bar.starNumber] forKey:@"star"];
    
    //        XWJAccount *account = [XWJAccount instance];
    //        [dict setValue:account.uid forKey:@"id"];
    //        if (self.type==1) {
    //
    //            [dict setValue:@"维修" forKey:@"type"];
    //        }else
    //            [dict setValue:@"投诉" forKey:@"type"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:diction success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            NSString *errCode = [dic objectForKey:@"errorCode"];
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertview.delegate = self;
            [alertview show];
            [self.navigationController popViewControllerAnimated:YES];
            
            //            NSMutableArray * array = [NSMutableArray array];
            //            XWJCity *city  = [[XWJCity alloc] init];
            
            //            NSArray *arr  = [dic objectForKey:@"data"];
            //            [self.houseArr removeAllObjects];
            //            [self.houseArr addObjectsFromArray:arr];
            //            [self.tableView reloadData];
            NSLog(@"dic %@",dic);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
    
    
    
    NSLog(@"rate %ld",(long)_bar.starNumber);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_conTV resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
