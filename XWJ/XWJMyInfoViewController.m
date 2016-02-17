//
//  XWJMyInfoViewController.m
//  XWJ
//
//  Created by Sun on 15/11/29.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMyInfoViewController.h"
#import "XWJHeader.h"
#import "NichengViewController.h"
#import "xingbieViewController.h"
#import "qingganViewController.h"
#import "xignquaihaoViewController.h"
#import "gexingqianmingViewController.h"
#import "ProgressHUD/ProgressHUD.h"
#import "XWJAccount.h"
#import "UIImageView+WebCache.h"
#import "SDWebImage/SDWebImage/UIButton+WebCache.h"



#define  HEIGHT 85.0
#define  NORMALHGIGHT 44.0
@interface XWJMyInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property NSMutableDictionary *infoDic;


@end

@implementation XWJMyInfoViewController{
    
    UIButton *button;
    NSString *_str;
    NSArray *_arrayNiCheng;
    NSString *_imageStr;
    NSString *_photo;
    NSMutableDictionary *_dict;
    UIImage * _image;
    NSString *imageStr;
    
}
CGRect tableViewCGRect;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.myView.bounds.size.height) style:UITableViewStylePlain];
    self.tableData = [NSArray arrayWithObjects:@"头像",@"昵称",@"性别",@"情感状况",@"兴趣爱好",@"个性签名" ,nil];
    self.tableDetailData = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    [self downLoadInfo];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = FALSE;
    self.tableView.bounces = FALSE;
    self.navigationItem.title = @"个人信息";
    [self.myView addSubview:self.tableView];
}
//获取个人信息的详细信息
-(void)downLoadInfo{
    
    NSString *messageUrl = @"http://www.hisenseplus.com:8100/appPhone/rest/user/getUserInfo";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    XWJAccount *account = [XWJAccount instance];
    [dict setValue:account.uid  forKey:@"id"];
    [manager POST:messageUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSDictionary *dicts = [dict objectForKey:@"data"];
            CLog(@"dict:%@",dict);
            NSString *nickname = [dicts objectForKey:@"NickName"];
            CLog(@"==>%@",nickname);
            if ([nickname isEqual:[NSNull null]]) {
                nickname = @"";
            }
            NSString *sex = dicts[@"sex"];
            if ([sex isEqual:[NSNull null]]) {
                sex = @"";
            }
            NSString *qgzk = dicts[@"qgzk"];
            if ([qgzk isEqual:[NSNull null]]){
                qgzk = @"";
            }
            NSString *xqah = dicts[@"xqah"];
            if ([xqah isEqual:[NSNull null]]) {
                xqah = @"";
            }
            NSString *gxqm = dicts[@"gxqm"];
            if ([gxqm isEqual:[NSNull null]]) {
                gxqm = @"";
            }
            self.tableDetailData = [NSMutableArray arrayWithObjects:nickname,sex,qgzk,xqah,gxqm,nil];
            CLog(@"？？？？dic++++++ %@",self.tableDetailData);
            imageStr = dicts[@"Photo"];
            if (![imageStr isEqual:[NSNull null]]) {
                NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
                _imageStr = [imagedata base64Encoding];
            }else{
                imageStr = @"";
            };
            
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
    
}
- (IBAction)done:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        tableViewCellHeight = HEIGHT;
    }else{
        tableViewCellHeight = NORMALHGIGHT;
    }
    //    CLog(@"seciton %ld row %ld",(long)indexPath.section,(long)indexPath.row);
    return tableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger index = 0;
    
    switch (indexPath.section) {
        case 0:
            tableViewCellHeight = HEIGHT;
            break;
        case 1:
        {
            tableViewCellHeight = NORMALHGIGHT;
            index = indexPath.row + 1;
        }
            break;
        case 2:
        {
            tableViewCellHeight = NORMALHGIGHT;
            index = 5;
        }
            break;
        default:
            break;
    }
    
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    
    
    cell.textLabel.text = self.tableData[index];
    cell.textLabel.textColor = XWJGRAYCOLOR;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,1)];
    headerview.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        //        cell.imageView.image = [UIImage imageNamed:@"mor_icon_default"];
        // cell.imageView.frame = CGRectMake(30, 0, 50, 50);
        for (UIView* view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                //                CLog(@"view%@",view);
                [view removeFromSuperview];
            }
        }
        //85.5-20 =60
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 60, 60)];
        [cell.contentView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr]placeholderImage:[UIImage imageNamed:@"demo"]];
        
        
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 30;
    }else{
        if (indexPath.row == 2 ) {
            switch ([self.tableDetailData[2] integerValue]) {
                case 1:
                    self.tableDetailData[2] = @"未婚";
                    break;
                case 2:
                    self.tableDetailData[2] = @"已婚";
                    break;
                default:
                    break;
            }
        }
        
        cell.detailTextLabel.text = self.tableDetailData[(indexPath.section-1)*4 + indexPath.row];
    }
    
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewCellHeight, self.view.bounds.size.width,1)];
    footerview.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
    [cell addSubview:headerview];
    [cell addSubview:footerview];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
    NSString *account = [usr valueForKey:@"username"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    _photo = [usr objectForKey:@"photo"];
    if (!_photo) {
        _photo = @"";
    }
    
    [dic setValue:self.tableDetailData[0] forKey:@"nickName"];
    [dic setValue:self.tableDetailData[1] forKey:@"sex"];
    [dic setValue:self.tableDetailData[2] forKey:@"qgzk"];
    [dic setValue:self.tableDetailData[3] forKey:@"xqah"];
    [dic setValue:self.tableDetailData[4] forKey:@"gxqm"];
    [dic setObject:account forKey:@"account"];
    [dic setObject:_photo forKey:@"photo"];
    _dict = dic;
    
    
    /*
     字段名	说明	类型及范围
     account	用户账号	String
     nickName	昵称	String
     sex	性别	String
     photo	Base64格式的字符串
     xqah	兴趣爱好	String
     qgzk	情感状况	String
     gxqm	个性签名	String
     */
    
    
    if (indexPath.section == 0) {
        
        [self onButtonClick1];
    }
    if (indexPath.section ==1) {
        if (indexPath.row == 0) {
            NichengViewController *nicheng = [[NichengViewController alloc]init];
            
            nicheng.returnStrBlock = ^(NSString * str){
                //                调用修改新的方法来修改个人信息
                [self postInfoWithDic:dic FromKey:@"nickName" object:(id)str success:^(id s) {
                    CLog(@"成功");
                    [self.tableDetailData replaceObjectAtIndex:0 withObject:str];
                    [usr setObject:str forKey:@"nicheng"];
                    CLog(@".....%@",str);
                    CLog(@"==>%@",self.tableDetailData);
                    [self.tableView reloadData];
                } failure:^(NSError *error){
                    CLog(@"%@",error);
                }];
                
            };
            
            [self.navigationController pushViewController:nicheng animated:YES ];
        }
        if (indexPath.row == 1) {
            xingbieViewController *sex = [[xingbieViewController alloc]init];
            
            sex.returnStrBlock = ^(NSString * str){
                
                [self postInfoWithDic:dic FromKey:@"sex" object:(id)str success:^(id s) {
                    //@"Angela",@"女",@"已婚",@"烹饪",@"开花"
                    CLog(@"成功%@",s);
                    [self.tableDetailData replaceObjectAtIndex:1 withObject:str];
                    [usr setObject:str forKey:@"xingbie"];
                    [self.tableView reloadData];
                } failure:^(NSError *error){
                    CLog(@"%@",error);
                }];
                
            };
            
            [self.navigationController pushViewController:sex animated:YES ];
        }
        if (indexPath.row == 2) {
            qingganViewController *qinggan = [[qingganViewController alloc]init];
            
            qinggan.returnStrBlock = ^(NSString * str){
                
                [self postInfoWithDic:dic FromKey:@"qgzk" object:(id)str success:^(id s) {
                    //@"Angela",@"女",@"已婚",@"烹饪",@"开花"
                    CLog(@"成功%@",s);
                    [self.tableDetailData replaceObjectAtIndex:2 withObject:str];
                    [usr setObject:str forKey:@"hunyin"];
                    [self.tableView reloadData];
                } failure:^(NSError *error){
                    CLog(@"%@",error);
                }];
            };
            
            [self.navigationController pushViewController:qinggan animated:YES ];
        }
        if (indexPath.row == 3) {
            xignquaihaoViewController *xingquaihao = [[xignquaihaoViewController alloc]init];
            
            xingquaihao.returnStrBlock = ^(NSString * str){
                
                [self postInfoWithDic:dic FromKey:@"xqah" object:(id)str success:^(id s) {
                    CLog(@"成功%@",s);
                    [self.tableDetailData replaceObjectAtIndex:3 withObject:str];
                    [usr setObject:str forKey:@"aihao"];
                    [self.tableView reloadData];
                } failure:^(NSError *error){
                    CLog(@"%@",error);
                }];
                
            };
            
            [self.navigationController pushViewController:xingquaihao animated:YES ];
        }
    }
    if (indexPath.section == 2) {
        
        gexingqianmingViewController *gexing = [[gexingqianmingViewController alloc]init];
        gexing.returnStrBlock = ^(NSString * str){
            
            [self postInfoWithDic:dic FromKey:@"gxqm" object:(id)str success:^(id s) {
                [self.tableDetailData replaceObjectAtIndex:4 withObject:str];
                [usr setObject:str forKey:@"qianming"];
                CLog(@"成功");
                
                [self.tableView reloadData];
            } failure:^(NSError *error){
                CLog(@"%@",error);
            }];
            
        };
        [self.navigationController pushViewController:gexing animated:YES];
    }
}



-(void)onButtonClick1{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:0];
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self LoadImageWith:UIImagePickerControllerSourceTypeCamera];
        }
        else
        {
            UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"本机不支持" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [a show];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self LoadImageWith:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)LoadImageWith:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController * pick = [[UIImagePickerController alloc]init];
    pick.sourceType=type;
    pick.delegate=self;
    pick.allowsEditing=self;
    [self presentViewController:pick animated:NO completion:nil];
    
}
//代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取图片并编码；
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);// jpeg
    NSString *baseStr = [imageData base64Encoding];
    _imageStr = baseStr;
    //请求成功后显示图片，并添加到缓存池中；
    _photo = baseStr;
    [self postInfoWithDic:_dict FromKey:@"photo" object:(id)baseStr success:^(id s) {
        CLog(@"成功%@",s);
        NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
        [usr setObject:baseStr forKey:@"photo"];
        [self downLoadInfo];
    } failure:^(NSError *error){
        CLog(@"%@",error);
    }];
    //返回；
    //  cell.imageView.image = [UIImage imageNamed:@"mor_icon_default"];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    CLog(@"已取消选择");
    [self dismissViewControllerAnimated:NO completion:nil];
}

//dict请求的数据体；  //key要改的字段的key； //obj要改的字段的obj；
-(void)postInfoWithDic:(NSMutableDictionary *)dict FromKey:(NSString *)key object:(id)obj success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [ProgressHUD showSuccess:@"正在修改"];
    //修改个人信息 url串；
    NSString *url = @"http://www.hisenseplus.com:8100/appPhone/rest/user/userInfoChange";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *str = @"";
    if ([obj isKindOfClass:[NSString class]]){
        str=obj;
        [dict setObject:str forKey:key];
    }else{
        [dict setObject:obj forKey:str];
    }
    
    //账户
    // [dict setValue:pwd forKey:@"password"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            NSDictionary *dic = responseObject;
            CLog(@"dic==>%@",dic);
            NSString *result = [dic valueForKey:@"result"];
            if ([result isEqualToString:@"1"]) {
                //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                [alert show];
                [ProgressHUD dismiss];
                success(responseObject);
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败" message:@"服务器请求异常，请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"log fail ");
        
        if (failure) {
            failure(error);
        }
    }];
    
}
@end