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
#import "XWJZFDetailViewController.h"
#import "XWJZFTableViewCell.h"
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface MyChuShouViewController ()<UITableViewDataSource,UITableViewDelegate>
@property NSMutableArray *houseArr;
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
//获取出售房屋的信息
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
    parameters[@"countperpage"] = @"100";
    parameters[@"userid"] = uid;
    
    [manager POST:loginUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         CLog(@"房屋出售%@",dict);
         self.houseArr = [dict objectForKey:@"data"];
        for (NSDictionary *czDict in self.houseArr) {
            chushouModel *czmodel = [[chushouModel alloc]init];
            [czmodel setValuesForKeysWithDictionary:czDict];
        
//        下载广告图片生成model
            [_dataSource addObject:czmodel];
            
         
        }
        [_tableV reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"请求失败");
    }];
    
}
//创建展示房屋信息的tabelview
-(void)createTableV{
    
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 110)];
    _tableV.delegate = self;
    _tableV.dataSource =self;
    
    [_tableV registerNib:[UINib nibWithNibName:@"XWJZFTableCell" bundle:nil] forCellReuseIdentifier:@"zftablecell"];
    [self.view addSubview:_tableV];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"XWJZFStoryboard" bundle:nil];
    XWJZFDetailViewController *detail = [story instantiateViewControllerWithIdentifier:@"2fdatail"];

    detail.dic = [self.houseArr objectAtIndex:indexPath.row];
    detail.type = HOUSE2;
    [self.navigationController showViewController: detail sender:self];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XWJZFTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"zftablecell"];
    if (!cell) {
        cell = [[XWJZFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zftablecell"];
    }
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"demo"]];
//    城市小区
    NSString * qu = [NSString stringWithFormat:@"%@%@",[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"city"]==[NSNull null]?@"":[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"city"],[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"area"]==[NSNull null]?@"":[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"area"]];
//   几室几厅
    NSString * shi = [NSString stringWithFormat:@"%@室%@厅%@卫 %@平米",[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"house_Indoor"],[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"house_living"],[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"house_Toilet"],[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"buildingArea"]==[NSNull null]?@"":[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"buildingArea"]];
//    价格
    NSString *money = [NSString stringWithFormat:@"%@万元",[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"rent"]==[NSNull null]?@"0":[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"rent"]];
    
    cell.label1.text = [NSString stringWithFormat:@"%@",[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"buildingInfo"]==[NSNull null]?@"":[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"buildingInfo"]];
    cell.label2.text = shi;
    cell.label3.text = qu;
    cell.label4.text = money;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.houseArr.count;
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
