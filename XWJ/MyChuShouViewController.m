//
//  MyChuShouViewController.m
//  XWJ
//
//  Created by 聚城科技 on 15/12/23.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "MyChuShouViewController.h"
#import "chushouModel.h"
#import "chushouTableViewCell.h"
#import "XWJAccount.h"
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface MyChuShouViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyChuShouViewController{

    UITableView *_tableV;
    NSMutableArray *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource =  [[NSMutableArray alloc]init];
    [self downLoadData];
    
        [self createTableV];
    // Do any additional setup after loading the view.
}
-(void)downLoadData{
    
    NSString *loginUrl = @"http://www.hisenseplus.com:8100/appPhone/rest/user/mySales";
    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //请求参数
    NSMutableDictionary *parameters =[[NSMutableDictionary alloc] init];
    //16位md5加密
    //    NSString *passwordString = [self getMd5_16Bit_String:_pwdtext.text];
    NSString *uid = [XWJAccount instance].uid;
    parameters[@"pageindex"] = @"0";
    parameters[@"countperpage"] = @"1";
    parameters[@"userid"] = uid;
    //     parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] valueForKey:@"account"];
    //    NSLog(@"sdfasdfsdf%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Accout"]);
    
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:[[self.notices objectAtIndex:index] valueForKey:@"id"]  forKey:@"id"];
    //    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    
    
    [manager POST:loginUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析服务器返回的数据responseObject
        //    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //  NSLog(@"------%@",str);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"房屋出售%@",dict);
//    NSDictionary *czDict = [dict objectForKey:@"data"];
         NSArray *array = [dict objectForKey:@"data"];
        for (NSDictionary *czDict in array) {
            chushouModel *czmodel = [[chushouModel alloc]init];
            [czmodel setValuesForKeysWithDictionary:czDict];
           //  chushouModel *czmodel = [[chushouModel alloc]initWithDictionary:czDict error:nil];
        
//        下载广告图片生成model
       
   //
//        czmodel.buildingArea = [czDict objectForKey:@"buildingArea"];
//        czmodel.buildingInfo = [czDict objectForKey:@"buildingInfo"];
//        czmodel.photo = [czDict objectForKey:@"photo"];
//        czmodel.rent = [czDict objectForKey:@"rent"];
//        czmodel.house_Indoor = [czDict objectForKey:@"house_Indoor"];
//        czmodel.house_Toilet = [czDict objectForKey:@"house_Toilet"];
//        czmodel.house_living = [czDict objectForKey:@"house_living"];
//        czmodel.house_living = [czDict objectForKey:@"city"];
     //   NSLog(@"-----%d",czmodel.house_Toilet);
//            buildingArea;
//            buildingInfo;
//            photo;
//            rent;
//            house_Indoor;
//            house_Toilet;
//            house_living;
//            city;
            [_dataSource addObject:czmodel];
            
         
        }
        [_tableV reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
}
-(void)createTableV{
    
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 110)];
    _tableV.delegate = self;
    _tableV.dataSource =self;
  //  _tableV.backgroundColor = [UIColor redColor];
    [self.view addSubview:_tableV];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    chushouTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[chushouTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    chushouModel *chushouM = [[chushouModel alloc]init];
        chushouM = _dataSource[indexPath.row];
    
    // NSLog(@"------%@",skM);
    
    [cell setCsModel:chushouM];
    
    return cell;
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //    if (!cell) {
    //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    //    }
    //    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return _dataSource.count;
  //  return 30;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
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
