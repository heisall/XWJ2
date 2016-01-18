//
//  MyChuZuViewController.m
//  XWJ
//
//  Created by 聚城科技 on 15/12/23.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "MyChuZuViewController.h"
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width
#import "chuzuTableViewCell.h"
#import "chuzuModel.h"
#import "XWJAccount.h"
@interface MyChuZuViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyChuZuViewController{
    
    UITableView *_tableV;
    NSMutableArray *_dataSource;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc]init];
    [self createTableV];
    [self downLoadData];
    // Do any additional setup after loading the view.
}
-(void)downLoadData{
    
    NSString *loginUrl = @"http://www.hisenseplus.com:8100/appPhone/rest/user/myRents";
    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //请求参数
    NSMutableDictionary *parameters =[[NSMutableDictionary alloc] init];
    //16位md5加密
    //    NSString *passwordString = [self getMd5_16Bit_String:_pwdtext.text];
    parameters[@"pageindex"] = @"0";
    parameters[@"countperpage"] = @"100";
    NSString *uid = [XWJAccount instance].uid;
    parameters[@"userid"] = uid;
    
    [manager POST:loginUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析服务器返回的数据responseObject
    //    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
      //  NSLog(@"------%@",str);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"出租数据%@",dict);
        
        NSArray *array = [dict objectForKey:@"data"];
        for (NSDictionary *czDict in array) {
            chuzuModel *czmodel = [[chuzuModel alloc]init];
            [czmodel setValuesForKeysWithDictionary:czDict];
            
            [_dataSource addObject:czmodel];
            // NSLog(@"-----%ld",_dataSource.count);
            
            [_tableV reloadData];
           
        }
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
}


-(void)createTableV{
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 110)];
    _tableV.delegate = self;
    _tableV.dataSource =self;
    [self.view addSubview:_tableV];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        chuzuTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[chuzuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
    
        chuzuModel *chuzuM = [[chuzuModel alloc]init];
        chuzuM = _dataSource[indexPath.row];
    
        // NSLog(@"------%@",skM);
    
        [cell setCzModel:chuzuM];
    
        return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
