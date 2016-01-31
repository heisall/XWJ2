//
//  XWJMyFindViewController.m
//  XWJ
//
//  Created by 聚城科技 on 15/12/21.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMyFindViewController.h"
#import "XWJMyFindViewCell.h"
#import "UIImageView+WebCache.h"
#import "XWJAccount.h"
#import "qingganViewController.h"
#import "XWJFindDetailViewController.h"


#define  COLLECTION_NUMSECTIONS 3
#define  COLLECTION_NUMITEMS 2
#define  SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define  CELL_HEIGHT 250.0
#define  vspacing 40


@interface XWJMyFindViewController ()<UITableViewDataSource , UITableViewDelegate>

@property NSMutableArray *finddetailArr;
@property NSMutableDictionary *dic;
@property NSMutableArray *idArray;

@end

@implementation XWJMyFindViewController
{
    NSArray *Arr;

}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tabaleView  = [[UITableView alloc] initWithFrame:CGRectMake(10, -10, SCREEN_WIDTH-20, Height ) style:UITableViewStylePlain];
    [self.view addSubview:self.tabaleView];
    self.tabaleView.dataSource = self;
    self.tabaleView.delegate = self;
    self.tabaleView.backgroundColor = [UIColor colorWithRed:229/255.0 green:230/255.0 blue:231/255.0 alpha:1];
    self.tabaleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getFindInfoSuccess:^(id a) {
        NSArray *arr = (NSArray *)a;
        Arr = arr;
        [self.tabaleView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];

    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (Arr.count%2==0) {
        return Arr.count/2;
    }else{
        return Arr.count/2+1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XWJMyFindViewCell *cell = [XWJMyFindViewCell XWJmyFindViewCellWithTabaleView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor colorWithRed:229/255.0 green:230/255.0 blue:231/255.0 alpha:1];
    //cell上的标签
    //标题
    UILabel *titleLabel1 = (UILabel *)[cell viewWithTag:1];
    UILabel *titleLabel2 = (UILabel *)[cell viewWithTag:2];
    //图片
    UIImageView *img1 = (UIImageView *)[cell viewWithTag:3];
    UIImageView *img2 = (UIImageView *)[cell viewWithTag:4];
    //二手车
    UILabel *carLabel1 = (UILabel *)[cell viewWithTag:5];
    UILabel *carLabel2 = (UILabel *)[cell viewWithTag:6];
    //评论数
    UILabel *comLabel1 = (UILabel *)[cell viewWithTag:7];
    UILabel *comLabel2 = (UILabel *)[cell viewWithTag:8];
    //时间
    UILabel *time1 = (UILabel *)[cell viewWithTag:9];
    UILabel *time2 = (UILabel *)[cell viewWithTag:10];
    
    //赋值
    
    //
    if (Arr.count%2==0) {
        if (indexPath.row == 0) {
            titleLabel1.text = Arr[indexPath.row][@"Memo"];
            titleLabel2.text = Arr[indexPath.row + 1][@"Memo"];
            NSURL *photo = [NSURL URLWithString:Arr[indexPath.row][@"Photo"]];
            NSURL *photo2 = [NSURL URLWithString:Arr[indexPath.row + 1][@"Photo"]];
            [img1 sd_setImageWithURL:photo];
            [img2 sd_setImageWithURL:photo2];
            carLabel1.text = Arr[indexPath.row ][@"content"];
            carLabel2.text = Arr[indexPath.row + 1][@"content"];
//
            comLabel1.text = [NSString stringWithFormat:@"%@", Arr[indexPath.row ][@"LeaveWordCount"]];
            comLabel2.text = [NSString stringWithFormat:@"%@", Arr[indexPath.row  + 1][@"LeaveWordCount"]];
            
            time1.text = Arr[indexPath.row][@"ReleaseTime"];
            time2.text = Arr[indexPath.row + 1][@"ReleaseTime"];
            
        }else{
            titleLabel1.text = Arr[2*indexPath.row][@"Memo"];
            titleLabel2.text = Arr[2*indexPath.row + 1][@"Memo"];
            NSURL *photo = [NSURL URLWithString:Arr[indexPath.row * 2][@"Photo"]];
            NSURL *photo2 = [NSURL URLWithString:Arr[indexPath.row * 2 + 1][@"Photo"]];
            [img1 sd_setImageWithURL:photo];
            [img2 sd_setImageWithURL:photo2];
            carLabel1.text = Arr[indexPath.row * 2][@"content"];
            carLabel2.text = Arr[indexPath.row * 2 + 1][@"content"];
            
            comLabel1.text = [NSString stringWithFormat:@"%@", Arr[indexPath.row * 2][@"LeaveWordCount"]];
            comLabel2.text = [NSString stringWithFormat:@"%@", Arr[indexPath.row * 2 + 1][@"LeaveWordCount"]];
//
            time1.text = Arr[indexPath.row *2][@"ReleaseTime"];
            time2.text = Arr[indexPath.row *2 + 1][@"ReleaseTime"];
            
        }
        
    }else{
        if (indexPath.row + 1 == (Arr.count +1)/2) {
            cell.View2.hidden = YES;
            titleLabel1.text = Arr[2*indexPath.row][@"Memo"];
            //            titleLabel2.text = Arr[2*indexPath.row + 1][@""];
            NSURL *photo = [NSURL URLWithString:Arr[indexPath.row * 2][@"Photo"]];
            //            NSURL *photo2 = [NSURL URLWithString:Arr[indexPath.row * 2 + 1][@"photo"]];
            [img1 sd_setImageWithURL:photo];
            //            [img2 sd_setImageWithURL:photo2];
            carLabel1.text = Arr[indexPath.row * 2][@"content"];
            //            carLabel2.text = Arr[indexPath.row * 2 + 1][@"content"];
            
            comLabel1.text = [NSString stringWithFormat:@"%@", Arr[indexPath.row * 2][@"LeaveWordCount"]];
//            comLabel2.text = [NSString stringWithFormat:@"%@", Arr[indexPath.row * 2 + 1][@"LeaveWordCount"]];
            
            time1.text = Arr[indexPath.row *2][@"ReleaseTime"];
            //            time2.text = Arr[indexPath.row *2 + 1][@"ReleaseTime"];
        }else{
            if (indexPath.row == 0) {
                titleLabel1.text = Arr[indexPath.row][@"Memo"];
                titleLabel2.text = Arr[indexPath.row + 1][@"Memo"];
                NSURL *photo = [NSURL URLWithString:(NSString*)Arr[indexPath.row][@"Photo"]];
                NSURL *photo2 = [NSURL URLWithString:(NSString*)Arr[indexPath.row + 1][@"Photo"]];
                [img1 sd_setImageWithURL:photo];
                [img2 sd_setImageWithURL:photo2];
                carLabel1.text = Arr[indexPath.row ][@"content"];
                carLabel2.text = Arr[indexPath.row + 1][@"content"];
                
                comLabel1.text = [NSString stringWithFormat:@"%@", Arr[indexPath.row * 2][@"LeaveWordCount"]];
                comLabel2.text = [NSString stringWithFormat:@"%@", Arr[indexPath.row * 2 + 1][@"LeaveWordCount"]];
                
                time1.text = Arr[indexPath.row][@"ReleaseTime"];
                time2.text = Arr[indexPath.row + 1][@"ReleaseTime"];
                
            }else{
                titleLabel1.text = Arr[2*indexPath.row][@"Memo"];
                titleLabel2.text = Arr[2*indexPath.row + 1][@"Memo"];
                NSURL *photo = [NSURL URLWithString:Arr[indexPath.row * 2][@"Photo"]];
                NSURL *photo2 = [NSURL URLWithString:Arr[indexPath.row * 2 + 1][@"Photo"]];
                [img1 sd_setImageWithURL:photo];
                [img2 sd_setImageWithURL:photo2];
                comLabel1.text = [NSString stringWithFormat:@"%@", Arr[indexPath.row * 2][@"LeaveWordCount"]];
                comLabel2.text = [NSString stringWithFormat:@"%@", Arr[indexPath.row * 2 + 1][@"LeaveWordCount"]];
                
//                comLabel1.text = Arr[indexPath.row *2][@"ShareQQCount"];
//                comLabel2.text = Arr[indexPath.row *2 + 1][@"ShareQQCount"];
                carLabel1.text = Arr[indexPath.row *2][@"content"];
                carLabel2.text = Arr[indexPath.row *2+ 1][@"content"];

                time1.text = Arr[indexPath.row *2][@"ReleaseTime"];
                time2.text = Arr[indexPath.row *2 + 1][@"ReleaseTime"];
                
            }
        }
    }
    
    

    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.0;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
        self.navigationItem.title = @"我的发现";//    self.title = @"依云小镇";
    self.navigationItem.leftBarButtonItem = nil;
}




-(void)getFindInfoSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    //修改个人信息 url串；
    NSString *url = @"http://www.hisenseplus.com:8100/appPhone/rest/user/myFind";
//    NSString *messageUrl = @"http://www.hisenseplus.com:8100/appPhone/rest/user/myMsg";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
    NSString *userid = [usr valueForKey:@"username"];
    NSString *a_id = [usr valueForKey:@"a_id"];
    NSLog(@"----->%@,%@",userid,a_id);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"0" forKey:@"pageindex"];
    [dict setObject:@"20" forKey:@"countperpage"];
    [dict setObject:[XWJAccount instance].uid  forKey:@"userid"];
    [dict setObject:[XWJAccount instance].aid forKey:@"a_id"];
//    [dict setObject:@""  forKey:@"userid"];
//    [dict setObject:@"" forKey:@"a_id"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
//            NSLog(@"dic==>%@",responseObject);
            NSDictionary *dic = responseObject;
            self.idArray = [dic objectForKey:@"message"];
            NSLog(@"dic==>%@",dic);
            NSArray *arr = [dic objectForKey:@"message"];
//            NSLog(@"arr:%@",arr);
            NSString *result = [dic valueForKey:@"result"];
            if ([result isEqualToString:@"1"]) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
                success(arr);
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败" message:@"服务器请求异常，请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"---->log fail ");
        
        if (failure) {
            failure(error);
        }
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *find = [UIStoryboard storyboardWithName:@"FindStoryboard" bundle:nil];
    XWJFindDetailViewController * con = [find instantiateViewControllerWithIdentifier:@"findDetail"];
    con.dic  = self.idArray[indexPath.row];
    NSLog(@"****%@",con.dic);
    [self.navigationController showViewController:con sender:nil];
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
