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
         self.houseArr = [dict objectForKey:@"data"];
        for (NSDictionary *czDict in self.houseArr) {
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
    
    [_tableV registerNib:[UINib nibWithNibName:@"XWJZFTableCell" bundle:nil] forCellReuseIdentifier:@"zftablecell"];
    [self.view addSubview:_tableV];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"XWJZFStoryboard" bundle:nil];
    XWJZFDetailViewController *detail = [story instantiateViewControllerWithIdentifier:@"2fdatail"];
    //        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //        [dic setValue:@"" forKey:@""];
    detail.dic = [self.houseArr objectAtIndex:indexPath.row];
    detail.type = HOUSE2;
    [self.navigationController showViewController: detail sender:self];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    chushouTableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[chushouTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//    
//    chushouModel *chushouM = [[chushouModel alloc]init];
//        chushouM = _dataSource[indexPath.row];
//    
//    // NSLog(@"------%@",skM);
//    
//    [cell setCsModel:chushouM];
//    
//    return cell;
    
    XWJZFTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"zftablecell"];
    if (!cell) {
        cell = [[XWJZFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zftablecell"];
    }
    // Configure the cell...
    //    cell.headImageView.image = [UIImage imageNamed:@"xinfangbackImg"];
    //    cell.label1.text = @"海信湖岛世家";
    //    cell.label2.text = @"3室2厅2卫 110平米";
    //    cell.label3.text = @"青岛市四方区";
    //    cell.label4.text = @"150万元";
    

    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"demo"]];
    
    NSString * qu = [NSString stringWithFormat:@"%@%@",[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"city"]==[NSNull null]?@"":[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"city"],[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"area"]==[NSNull null]?@"":[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"area"]];
    
    NSString * shi = [NSString stringWithFormat:@"%@室%@厅%@卫 %@平米",[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"house_Indoor"],[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"house_living"],[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"house_Toilet"],[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"buildingArea"]==[NSNull null]?@"":[[self.houseArr objectAtIndex:indexPath.row] objectForKey:@"buildingArea"]];
    
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
