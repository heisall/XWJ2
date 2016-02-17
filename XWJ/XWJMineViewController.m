//
//  XWJMineViewController.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMineViewController.h"
#import "XWJHeader.h"
#import "XWJMyMessageController.h"
#import "XWJMyHouseController.h"
#import "XWJMyZSViewController.h"
#import "XWJGZaddViewController.h"
#import "XWJGuzhangViewController.h"
#import "XWJMyFindViewController.h"
#import "XWJZuShouViewController.h"
#import "XWJSuggestionController.h"
#import "MyChuShouViewController.h"
#import "MyChuZuViewController.h"
#import "XWJMyInfoViewController.h"
#import "XWJAboutViewController.h"
#import "XWJMyMessageController.h"
#import "XWJForgetPwdViewController.h"
#import "XWJMyOrderViewController.h"
#import "XWJFindViewController.h"
#import "XWJAddressController.h"
#import "XWJAccount.h"


#define  CELL_HEIGHT 30.0
#define  COLLECTION_NUMSECTIONS 2
#define  COLLECTION_NUMITEMS 4

@interface XWJMineViewController()<UIAlertViewDelegate>
@property NSArray *mine;
@property NSDictionary *dicuser;

@end
@implementation XWJMineViewController
static NSString *kcellIdentifier = @"collectionCellID";
NSArray *myImgs;

//-(void)viewWillAppear:(BOOL)animated{
//    
//}
-(void)viewDidLoad{
   
    NSDictionary *dicuser = [[NSDictionary alloc]init];
    [self downLoadData];

    self.tableData = [NSArray arrayWithObjects:@"关于信我家",@"修改密码",@"修改建议" ,@"退出登录" ,nil];

    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    tableViewCellHeight = self.tableview.bounds.size.height/(self.tableData.count+1);

    myImgs = [NSArray arrayWithObjects:@"mine1",@"mine2",@"mine3",@"mine4",@"mine5",@"图层-1@2x",@"mine6",@"", nil];
    self.collectionData = [NSArray arrayWithObjects:@"我的消息",@"我的发现",@"我的租售",@"我的订单",@"我的报修",@"投诉表扬",@"收件地址",@"",nil];
    self.collcitonView.dataSource = self;
    self.collcitonView.delegate = self;
    [self.collcitonView registerNib:[UINib nibWithNibName:@"XWJCollectionCell" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier];

    UIViewController *m1 = [[XWJMyMessageController alloc] init];
    UIViewController *m2 = [[XWJMyMessageController alloc] init];
    UIViewController *m3 = [self.storyboard instantiateViewControllerWithIdentifier:@"zscontroller"];
    UIViewController *m4 = [[XWJGZaddViewController alloc]init];
    _mine = [NSArray arrayWithObjects:m1,m2,m3,m4,nil];
//    XWJMyInfoViewController *info = [[XWJMyInfoViewController alloc] init];
//    [self getPersonInfo];
    
//    给我的头的图片增加手势
    UIImageView *imageV  = (UIImageView *)[self.view viewWithTag:1993];
    imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickImage)];
    [imageV addGestureRecognizer:singleTap];
   
    [imageV sd_setImageWithURL:[NSURL URLWithString:[XWJAccount instance].headPhoto]placeholderImage:[UIImage imageNamed:@"demo"]];
    imageV.layer.cornerRadius = imageV.frame.size.width/2;
    imageV.layer.masksToBounds = YES;
    
    CLog(@"%@",[self.dicuser objectForKey:@"jifen"]);
    
    self.scrollView.contentSize = CGSizeMake(0, SCREEN_SIZE.height+100);
}
//获取个人信息
-(void)downLoadData{
    NSString *url = LOGIN_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[XWJAccount instance].account forKey:@"account"];
    [dict setValue:[XWJAccount instance].password forKey:@"password"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        CLog(@"%@",dic);

        if ([dic objectForKey:@"data"]!=[NSNull null]) {
            
            self.dicuser = [[dic objectForKey:@"data"] objectForKey:@"user"];
            [XWJAccount instance].jifen = [self.dicuser valueForKey:@"jifen"];
            CLog(@"%@",[self.dicuser objectForKey:@"jifen"]);
            self.scoreLabel.text = [NSString stringWithFormat:@"%@",[self.dicuser objectForKey:@"jifen"]==[NSNull null]?@"":[NSString stringWithFormat:@"%@",[self.dicuser objectForKey:@"jifen"]]];
            self.NickNameLabel.text = [NSString stringWithFormat:@"%@",[self.dicuser objectForKey:@"NickName"]==[NSNull null]?@"":[self.dicuser objectForKey:@"NickName"]];
            [XWJAccount instance].headPhoto = [NSString stringWithFormat:@"%@",[dic valueForKey:@"Photo"]];
            
            [self.tableview reloadData];
        }
//        - (void)setObject:(id)value forKey:(NSString *)defaultName;
//        - (void)removeObjectForKey:(NSString *)defaultName;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"请求失败");
    }];
}
//点击图片的时候可以跳转到修改信息界面
-(void)whenClickImage{

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    XWJMyInfoViewController *detail = [story instantiateViewControllerWithIdentifier:@"myInfoStory"];
    [self.navigationController showViewController: detail sender:self];
    
}

//修改个人信息的方法
-(void)getPersonInfo{
    NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
    NSString *imgstr = [usr valueForKey:@"photo"];
    NSString *nickname = [usr valueForKey:@"nicheng"]==[NSNull null]?@"": [usr valueForKey:@"nicheng"];
    if (nickname) {
        self.NickNameLabel.text = nickname;
    }
    
    if (imgstr) {
        NSData *imgData = [[NSData alloc] initWithBase64EncodedString:imgstr options:0];
        self.headImage.layer.cornerRadius = self.headImage.frame.size.width/2;    
        self.headImage.layer.masksToBounds = YES;
        self.headImage.image = [UIImage imageWithData:imgData];
    }


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"我的";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;

    [self downLoadData];
    [self getPersonInfo];

}

- (IBAction)goMyHouse:(id)sender {
    UIViewController *con = [[XWJMyHouseController alloc] init];
    [self.navigationController showViewController:con sender:nil];
}

#pragma mark -CollectionView datasource
//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    collectionCellHeight = self.collcitonView.frame.size.height/COLLECTION_NUMSECTIONS-1;
    collectionCellWidth = self.collcitonView.frame.size.width/COLLECTION_NUMITEMS-1;
    return COLLECTION_NUMSECTIONS;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return COLLECTION_NUMITEMS;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    UICollectionViewCell *cell = [self.collcitonView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    //赋值
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
//    NSString *imageName = [NSString stringWithFormat:@"mor_icon_default"];
    
    NSString * imageStr = [myImgs objectAtIndex:indexPath.section*COLLECTION_NUMITEMS+indexPath.row];
    [imageView setImage:[UIImage imageNamed:imageStr]];
//    imageView.image = [UIImage imageNamed:@"mor_icon_default"];
    label.textColor = XWJGRAYCOLOR;
    label.text = self.collectionData[indexPath.section*COLLECTION_NUMITEMS+indexPath.row];
    
//    cell.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:70.0/255.0 blue:71.0/255.0 alpha:1.0];
;
    return cell;
    
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionCellWidth, collectionCellHeight);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 0, 0);//分别为上、左、下、右
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={0,0};
    return size;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            XWJMyMessageController *message = [[XWJMyMessageController alloc]init];
            [self.navigationController pushViewController:message animated:YES];
        }
        if (indexPath.row == 1) {
            
            XWJMyFindViewController *find = [[XWJMyFindViewController alloc]init];
            [self.navigationController pushViewController:find animated:YES];
        }
        if (indexPath.row == 2) {
            XWJZuShouViewController *find = [[XWJZuShouViewController alloc]init];
            [self.navigationController pushViewController:find animated:YES];
        }
        if (indexPath.row == 3) {
            XWJMyOrderViewController *order = [[XWJMyOrderViewController alloc]init];
            [self.navigationController pushViewController:order animated:YES];
        }
    }
    
    if(indexPath.section == 1){
//        if (indexPath.row == 0) {
//        
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GuzhanStoryboard" bundle:[NSBundle mainBundle]];
//                UIViewController *baoxiu = [storyboard instantiateViewControllerWithIdentifier:@"guzhangbaoxiu"];
//            [self.navigationController showViewController:baoxiu sender:nil];
//                        }
        if(indexPath.row == 0){
            UIStoryboard *guzhang = [UIStoryboard storyboardWithName:@"GuzhanStoryboard" bundle:nil];
            XWJGuzhangViewController *gz2 = [guzhang instantiateInitialViewController];
            gz2.type = 1;
            [self.navigationController showViewController:gz2 sender:nil];
        }
        if(indexPath.row == 1){
            UIStoryboard *guzhang = [UIStoryboard storyboardWithName:@"GuzhanStoryboard" bundle:nil];
            XWJGuzhangViewController *gz2 = [guzhang instantiateInitialViewController];
            gz2.type = 2;
            [self.navigationController showViewController:gz2 sender:nil];
        }
        if(indexPath.row == 2){
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"XWJCarStoryboard" bundle:nil];
            XWJAddressController *addr = [story instantiateViewControllerWithIdentifier:@"address"];
            addr.con =nil;
            [self.navigationController pushViewController:addr animated:YES];
        }

    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;

    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    // Configure the cell...
    cell.textLabel.text = self.tableData[indexPath.row];
    cell.textLabel.textColor = XWJGRAYCOLOR;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewCellHeight-1, self.view.bounds.size.width,1)];
    view.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell addSubview:view];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        XWJAboutViewController *about = [[XWJAboutViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
    if (indexPath.row == 1) {
        
        UIStoryboard *changePassWord = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
        XWJForgetPwdViewController *forgotPassWord = [changePassWord instantiateViewControllerWithIdentifier:@"forget1"];
        forgotPassWord.getpassWord =@"1";
        [self.navigationController showViewController:forgotPassWord sender:nil];
    }
    if (indexPath.row == 2) {
        
        XWJSuggestionController *sug = [[XWJSuggestionController alloc]init];
        [self.navigationController pushViewController:sug animated:YES];
    }
    if (indexPath.row == 3) {
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出登陆？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertview.delegate = self;
        [alertview show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
//清空所有的缓存到本地的信息
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
        NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults]dictionaryRepresentation];
        for (NSString *key in [defaultsDictionary allKeys]) {    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
        self.view.window.rootViewController = [loginStoryboard instantiateInitialViewController];
    }
}

@end
