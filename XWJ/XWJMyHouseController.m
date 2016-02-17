//
//  XWJMyHouseController.m
//  XWJ
//
//  Created by Sun on 15/11/29.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMyHouseController.h"
#import "XWJdef.h"
#import "XWJAccount.h"
#import "XWJBindHouseOneViewController.h"
#import "XWJXuanZeViewController.h"
#import "XWJBindHouseTableViewController.h"
#import "XWJCity.h"
#import "XWJAboutViewController.h"
#import "XWJMyHouseCell.h"
#import "XWJTabViewController.h"
#import "XWJLoginViewController.h"
#import "XRQJpush.h"

@interface XWJMyHouseController()<XWJBindHouseDelegate,UITableViewDataSource,UITableViewDelegate>{
}

@property UITableView *tableView;
@property NSMutableArray *titles;
@property NSMutableArray *subTitles;
@property NSMutableArray *danyuan;
@property NSMutableArray *louhao;
@property NSMutableArray *JURID;
@property NSMutableArray *isDefault;
@property NSString *guanjiaM;

@end
@implementation XWJMyHouseController

static NSString *kcellIdentifier = @"cell";

-(void)viewDidLoad{
    [super viewDidLoad];
    [self downLoadData];
    self.navigationItem.title = @"我的房产";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _titles =[[NSMutableArray alloc]init];
    _subTitles =[[NSMutableArray alloc]init];
    _danyuan =[[NSMutableArray alloc]init];
    _louhao =[[NSMutableArray alloc]init];
    _JURID =[[NSMutableArray alloc]init];
    _isDefault =[[NSMutableArray alloc]init];
    _guanjiaM = [[NSString alloc]init];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 50)];
    view.backgroundColor = XWJColor(235, 235, 234);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"bindfy"];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:@"继续绑定房源" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 200, image.size.height);
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btn addTarget:self action:@selector(bind) forControlEvents:UIControlEventTouchUpInside];
    btn.center = view.center;
    [view addSubview:btn];
    _tableView.tableHeaderView = view;
    
    [_tableView registerNib:[UINib nibWithNibName:@"XWJMyhouseTableCell" bundle:nil] forCellReuseIdentifier:kcellIdentifier];
    [self.view addSubview:_tableView];
}


-(void)bind{
    
    XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
    bind.title = @"城市选择";

    bind.delegate = self;
    bind->mode = HouseCity;
    [self.navigationController showViewController:bind sender:nil];

}
#pragma bindhouse delegate
-(void)didSelectAtIndex:(NSInteger)index Type:(HouseMode)type{
    XWJCity *city = [XWJCity instance];
    switch (type) {
        case HouseCity:{
            
            [city selectCity:index];
            XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
            bind.title = @"小区选择";
                      bind.delegate = self;
            bind->mode = HouseCommunity;
            
            [self.navigationController showViewController:bind sender:nil];
            
        }
            break;
        case HouseCommunity:{
            
            [city selectDistrict:index];
            
            XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
            bind.title = @"楼座选择";
            bind.delegate = self;
            bind->mode = HouseFlour;
            [self.navigationController showViewController:bind sender:nil];
        }
            break;
        case HouseFlour:{
            
            [city selectBuilding:index];
            
            XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
            bind.title = @"房间选择";
            bind.delegate = self;
            bind->mode = HouseRoomNumber;
            [self.navigationController showViewController:bind sender:nil];
        }
            break;
        case HouseRoomNumber:{
            
            [city selectRoom:index];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
            [self.navigationController showViewController:[story instantiateViewControllerWithIdentifier:@"bindhouse1"] sender:nil];
            
        }
            break;
        default:
            break;
    }
}


-(void)downLoadData{
    NSString *houseUrl = @"http://www.hisenseplus.com:8100/appPhone/rest/build/myRooms";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    XWJAccount *account = [XWJAccount instance];
    [dict setValue:account.uid forKey:@"userid"];
    [manager POST:houseUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"%@",responseObject);
        if(responseObject){
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSArray *array  =[[NSArray alloc]init];
            array = [dict objectForKey:@"data"];
            for (NSMutableDictionary *d in array) {
                [_subTitles addObject:[d objectForKey:@"B_name"]];
                [_titles addObject:[d objectForKey:@"A_name"]];
                [_danyuan addObject:[d objectForKey:@"R_dy"]];
                [_louhao addObject:[d objectForKey:@"R_id"]];
                [_JURID addObject:[d objectForKey:@"JU_RID"]];
                [_isDefault addObject:[d objectForKey:@"isDefault"]];
                CLog(@"%@",_isDefault);

            }
        }

        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    UITableViewCell *cell;
    //    cell = [_tableView dequeueReusableCellWithIdentifier:kcellIdentifier forIndexPath:indexPath];
    XWJMyHouseCell *cell = [XWJMyHouseCell xwjMyHouseCellInitWithTableView:tableView];
    //    UILabel *title = (UILabel *)[cell viewWithTag:1];
    //    UILabel *subtitle = (UILabel *)[cell viewWithTag:2];
    //
    //    title.text = [_titles objectAtIndex:indexPath.row];
    //    subtitle.text = [NSString stringWithFormat:@"%@%@单元%@",[_subTitles objectAtIndex:indexPath.row],[_danyuan objectAtIndex:indexPath.row],[_louhao objectAtIndex:indexPath.row]];
    //
    //    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.titleLabel.text = [_titles objectAtIndex:indexPath.row];
    cell.DetailLabel.text =[NSString stringWithFormat:@"%@%@单元%@",[_subTitles objectAtIndex:indexPath.row],[_danyuan objectAtIndex:indexPath.row],[_louhao objectAtIndex:indexPath.row]];
    CLog(@"_isDefault:%@",_isDefault);
    NSString *str= [NSString stringWithFormat:@"%@",_isDefault[indexPath.row]];
    if ([str isEqualToString:@"1"]) {
        cell.imageview.hidden = NO;
    }else{
        cell.imageview.hidden = YES;
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [tableView visibleCells];
    for (XWJMyHouseCell *cell in array) {
        if (cell.selected == YES) {
            cell.imageview.hidden = NO;
        }else{
            cell.imageview.hidden = YES;
        }
    }
    XWJMyHouseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //    UIImageView *image = cell.imageView;
    cell.imageview.hidden = NO;
    
    //向服务器发送数据请求把房产信息传到服务器
    NSString *changeUrl = @"http://www.hisenseplus.com:8100/appPhone/rest/build/changeDefault";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    NSMutableDictionary *housedict = [NSMutableDictionary dictionary];
    
    XWJAccount *account = [XWJAccount instance];
    [housedict setValue:account.uid forKey:@"userid"];
    [housedict setValue:self.JURID[indexPath.row] forKey:@"JU_RID"];
    //    CLog(@"哈哈哈%@",self.JURID[indexPath.row]);
    [manager POST:changeUrl parameters:housedict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            CLog(@"%@",responseObject);
        if(responseObject){
            
        }
      //  [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];

    [self login:[XWJAccount instance].account :[XWJAccount instance].password];;
}
-(void)login:(NSString *)username :(NSString *)pwd{
    if (username.length>0&&pwd.length>0) {
        
        //        NSString *url = @"http://www.hisenseplus.com:8100/appPhone/rest/user/userLogin";
        NSString *url = LOGIN_URL;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:username forKey:@"account"];
        [dict setValue:pwd forKey:@"password"];
        
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            NSNumber * result = [dic valueForKey:@"result"];
            
            /*
             Account = 15092245487;
             AccountCount = 0;
             DictValue = "<null>";
             LastLoginIP = "<null>";
             LastLoginTime = "<null>";
             NAME = "<null>";
             NickName = "<null>";
             PhoneType = iPhone;
             Photo = "<null>";
             "R_id" = 24215;
             RegisterIP = "168.0.0.1";
             RegisterTime = "2015-12-07";
             TEL = "<null>";
             Types = 1;
             "U_id" = 1;
             gxqm = "<null>";
             id = 13;
             sex = "<null>";
             */
            if ([result intValue]== 1) {
                
                [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:@"password"];
                //                NSString *uname = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
                //                NSString *pass = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
                //                //            [XWJAccount instance].uid = ;
                //                if (![username isEqualToString:uname]) {
                //
                //                    //                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"bind"];
                //                    [[NSUserDefaults standardUserDefaults] synchronize];
                //                }else if(![pwd isEqualToString:pass]){
                //                    [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:@"password"];
                //                }
                
                NSDictionary *userDic = [[dic objectForKey:@"data"] objectForKey:@"user"];
                NSString *sid = [userDic valueForKey:@"id"];
                CLog(@"sid %@",sid);
                [XWJAccount instance].uid = sid;
                [XWJAccount instance].account = [userDic valueForKey:@"Account"];
                [XWJAccount instance].password = pwd;
                [XWJAccount instance].NickName =[userDic valueForKey:@"NickName"];
                [XWJAccount instance].name = [userDic valueForKey:@"NAME"];
                [XWJAccount instance].Sex = [userDic valueForKey:@"sex"];
                [XWJAccount instance].phone = [userDic valueForKey:@"TEL"];
                [XWJAccount instance].jifen = [userDic valueForKey:@"jifen"];
                [XWJAccount instance].headPhoto = [NSString stringWithFormat:@"%@",[userDic valueForKey:@"Photo"]];
                //设置别名
                [XRQJpush setBieming:[XWJAccount instance].uid];
                CLog(@"******别名*****%@",[XWJAccount instance].uid);
                /*
                 "A_id" = 4;
                 "A_name" = "\U9ea6\U5c9b\U91d1\U5cb8";
                 isDefault = 1;
                 */
                [XWJAccount instance].array = [[dic objectForKey:@"data"] valueForKey:@"area"];
                if ([XWJAccount instance].array&&[XWJAccount instance].array.count>0) {
                    [XWJAccount instance].isYouke = NO;
                    for (NSDictionary *di in [XWJAccount instance].array ) {
                        if ([[di valueForKey:@"isDefault" ] integerValue]== 1) {
                            [XWJAccount instance].aid = [NSString stringWithFormat:@"%@",[di valueForKey:@"A_id"]];
                        }
                    }
                }
                
                //                BOOL isBind = [[NSUserDefaults standardUserDefaults] boolForKey:@"bind"];
                BOOL isBind = [XWJAccount instance].aid?TRUE:FALSE;
                if (!isBind) {
                    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"xuanzefangshi"];
                    
                    [self.navigationController showViewController:view sender:nil];
                    
                    //                    XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
                    //                    bind.title = @"城市选择";
                    //                    bind.delegate = self;
                    //                    bind->mode = HouseCity;
                    //                    [self.navigationController showViewController:bind sender:nil];
                }else{
                    
                    XWJTabViewController *tab = [[XWJTabViewController alloc] init];
                    //                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    self.view.window.rootViewController = tab;
                }
            }else{
                NSString *errCode = [dic objectForKey:@"errorCode"];
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertview.delegate = self;
                [alertview show];
            }
            

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            CLog(@"log fail ");
            //        dispatch_async(dispatch_get_main_queue(), ^{
            //            XWJTabViewController *tab = [[XWJTabViewController alloc] init];
            //            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //            window.rootViewController = tab;            //        });
            
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"服务端返回异常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertview.delegate = self;
            [alertview show];
        }];
    }else{
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入用户名和密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertview.delegate = self;
        [alertview show];
        //    if ([self.tFieldUserName.text isEqualToString:username]&&[self.tFieldPassWord.text isEqualToString:pwd]) {
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;
        //    }
    }
    
    /*
     XWJBindHouseTableViewController *bind = [[XWJBindHouseTableViewController alloc] init];
     bind.title = @"城市选择";
     bind.dataSource = [NSArray arrayWithObjects:@"青岛市",@"济南市",@"威海市", nil];
     bind.delegate = self;
     bind->mode = HouseCity;
     [self.navigationController showViewController:bind sender:nil];
     */
}
//-(void)login{
//
//    NSString *url = LOGIN_URL;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:[XWJAccount instance].account forKey:@"account"];
//    [dict setValue:[XWJAccount instance].password forKey:@"password"];
//    
//    
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
//    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        
//        NSDictionary *dic = (NSDictionary *)responseObject;
//        CLog(@"dic%@",dic);
//       
//        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
//        self.view.window.rootViewController = tab;
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//      
//    }];
//
//}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    //    self.scrollView.contentSize = CGSizeMake(0, SCREEN_SIZE.width+60);
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
-(void)viewDidAppear:(BOOL)animated
{

}

@end
