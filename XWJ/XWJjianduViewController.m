//
//  XWJjianduViewController.m
//  XWJ
//
//  Created by Sun on 15/12/2.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJjianduViewController.h"
#import "WuyeTableViewCell.h"
#import "XWJdef.h"
#import "XWJCity.h"
#import "XWJjianduDetailViewController.h"
@interface XWJjianduViewController ()

@property (weak, nonatomic) IBOutlet UIView *adView;
@property(nonatomic)UIScrollView *scrollview;
@property NSMutableArray *yuangong;
@property NSMutableArray *work;
@end
@implementation XWJjianduViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    

//    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40.0)];
////    view.backgroundColor = [UIColor grayColor];
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
//    view.backgroundColor = [UIColor whiteColor];
//    title.text = @"物业员工";
//    title.textColor  = MJColor(0, 147, 141);
//    [view addSubview:title];
//    self.tableView.tableHeaderView = view;
    
    self.work = [NSMutableArray array];
    self.yuangong = [NSMutableArray array];

//    self.scrollview.frame = CGRectMake(self.scrollview.frame.origin.x, self.scrollview.frame.origin.y, self.scrollview.frame.size.width, SCREEN_SIZE.height/7);
}

- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
        
    XWJjianduDetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"jiandudetail"];
    detail.dic = [self.work objectAtIndex:index];
    [self.navigationController showViewController:detail sender:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"物业监督";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
//    self.scrollview.frame = CGRectMake(self.scrollview.frame.origin.x, self.scrollview.frame.origin.y, self.scrollview.frame.size.width, SCREEN_SIZE.height/7);
    [self getWuye];

}

-(void)addViews{
    NSMutableArray *URLs = [NSMutableArray array] ;
    
    for (NSDictionary *dic in self.work) {
        [URLs addObject:[dic objectForKey:@"photo"]];
    }
//
//    [self.adScrollView addSubview:({
//        
//        LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
//                                                                                self.adScrollView.bounds.size.height)
//                                    
//                                                            delegate:self
//                                                           imageURLs:URLs
//                                                    placeholderImage:nil
//                                                       timerInterval:5.0f
//                                       currentPageIndicatorTintColor:[UIColor redColor]
//                                              pageIndicatorTintColor:[UIColor whiteColor]];
//        bannerView;
//    })];
    
    NSInteger count = self.work.count;
    CGFloat width = 2*self.view.bounds.size.width/3;
    CGFloat height = self.adScrollView.bounds.size.height;
    self.adScrollView.contentSize = CGSizeMake(width*(count)+60, height);
    for (int i=0; i<count; i++) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(i*(width+10), 0, width, height-10)];
        
        UIImageView *im =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, backView.bounds.size.height)];
        im.userInteractionEnabled = YES;
        im.tag = i;
        
        [im sd_setImageWithURL:[NSURL URLWithString:URLs[i]]placeholderImage:nil];

        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1;
        [im addGestureRecognizer:singleRecognizer];
      
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(width-100,0, 100, 25)];
        label.textColor = [UIColor whiteColor];
        NSString *type = [[self.work objectAtIndex:i] valueForKey:@"Types"];
        label.text = type;
        label.textAlignment = NSTextAlignmentCenter;
        if ([type isEqualToString:@"工作进展"]) {
            label.backgroundColor = XWJColor(67, 164, 83);
        }else if ([type isEqualToString:@"工作记录"]){
            label.backgroundColor = XWJColor(234, 116, 13);
        }else{
            label.backgroundColor = XWJColor(255,44, 56);
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, backView.bounds.size.height-60, width, 60)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.7;
        UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, width-20, 20)];
        label1.textColor = [UIColor whiteColor];
        label1.text = [[self.work objectAtIndex:i] valueForKey:@"Content"];
        label1.font = [UIFont systemFontOfSize:14.0];
//        label1.
        label1.lineBreakMode = NSLineBreakByWordWrapping;
        UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 100, 20)];
        label2.textColor = [UIColor whiteColor];
        label2.text = [[self.work objectAtIndex:i] valueForKey:@"ReleaseTime"];
        label2.font = [UIFont systemFontOfSize:14.0];
        UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 50, 20)];
        label3.textColor = [UIColor whiteColor];
        label3.text = [NSString stringWithFormat:@"点击 %@",[[self.work objectAtIndex:i] objectForKey:@"ClickPraiseCount"]];
        label3.font = [UIFont systemFontOfSize:14.0];
        
        [view addSubview:label1];
        [view addSubview:label2];
        [view addSubview:label3];
        [backView addSubview:im];
        [backView addSubview:label];
        [backView addSubview:view];
        [self.adScrollView addSubview:backView];
    }
}

-(void)click:(UITapGestureRecognizer *)ges{
    
    [self bannerView:nil didClickedImageIndex:ges.view.tag];
    NSLog(@"click");
}

-(void)getWuye{
    NSString *url = GETWUYE_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[XWJCity instance].aid  forKey:@"id"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        /*
         Name = "\U674e\U56db";
         Phone = 13888888888;
         Position = "\U5ba2\U670d\U4e3b\U7ba1";
         photo = "http://www.hisenseplus.com/HisenseUpload/supervise/u=2084087811,2896369697&fm=21&gp=02015127101117.jpg";
         
         ClickPraiseCount = 0;
         Content = "\U6211\U4eec\U7684\U65b0\U5199\U5b57\U697c";
         LeaveWordCount = 0;
         ReleaseTime = "12-13 20:19";
         ShareQQCount = 0;
         Types = "\U5c0f\U533a\U6574\U6539";
         id = 7;
         photo = "http://www.hisenseplus.com/HisenseUpload/work/20151213201949760.jpg";
         
         */
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            NSNumber *res =[dic objectForKey:@"result"];
            if ([res intValue] == 1) {
                
                [self.yuangong addObjectsFromArray:[dic objectForKey:@"supervise"] ] ;
                [self.work addObjectsFromArray:[dic objectForKey:@"work"]];
                
                [self.tableView reloadData];
                
                [self addViews];

            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden =NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 30.0;
//}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"物业员工";
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.yuangong.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WuyeTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"wuyecell"];
    if (!cell) {
        cell = [[WuyeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wuyecell"];
    }
    // Configure the cell...
//    cell.headImg.image = [UIImage imageNamed:@"mor_icon_default"];
//    cell.nameLabel.text = @"王琳";
//    cell.positionLabel.text = @"主管";
//    cell.photoLabel.text = @"13666666666";

//    cell.headImg.tag =[[self.yuangong objectAtIndex:indexPath.row] objectForKey:@"photo"]];
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[[self.yuangong objectAtIndex:indexPath.row] objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"mor_icon_default"]];
    cell.nameLabel.text = [[self.yuangong objectAtIndex:indexPath.row] objectForKey:@"Name"];
    cell.positionLabel.text = [[self.yuangong objectAtIndex:indexPath.row] objectForKey:@"Position"];
    cell.photoLabel.text = [[self.yuangong objectAtIndex:indexPath.row] objectForKey:@"Phone"];
    
    cell.dialBtn.tag = indexPath.row;
    [cell.dialBtn addTarget:self action:@selector(dial:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.dialBtn setImage:[] forState:<#(UIControlState)#>]
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 69, self.view.bounds.size.width,1)];
//    view.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell addSubview:view];
    return cell;
}

-(void)dial:(UIButton *)sender{
    NSString *phone=  [[self.yuangong objectAtIndex:sender.tag] objectForKey:@"Phone"];

    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
//        [self.navigationController showViewController:[storyboard instantiateViewControllerWithIdentifier:@"suggestStory"] sender:nil];
    }
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
