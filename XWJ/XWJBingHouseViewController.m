//
//  XWJBingHouseViewController.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBingHouseViewController.h"
#import "XWJdef.h"
#import "XWJCity.h"
#import "XWJLoginViewController.h"
#import "XWJTabViewController.h"
#import "XWJHomeViewController.h"
#import "ProgressHUD.h"
#import "XWJAccount.h"
//#define 1000000000
@interface XWJBingHouseViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property NSInteger typeindex;
@property NSInteger phoneindex;
@property NSArray *array;
@property NSArray *phonearray;

@property NSInteger phone1;
@property NSInteger phone2;
@property NSInteger phone3;
@property NSInteger phone4;
@property NSInteger phone5;
@property NSInteger phone6;
@property NSInteger phone7;
@property NSInteger phone8;
@property NSInteger phone9;
@property NSInteger phone10;
@property NSInteger phone11;

@end
#define  TAG 100
@implementation XWJBingHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.txtField4.delegate = self;
    self.txtField5.delegate = self;
    self.txtField6.delegate = self;
    self.txtField7.delegate = self;
    self.txtField8.delegate = self;
    self.txtField9.delegate = self;


    self.txtField4.tag = TAG +1;
    self.txtField5.tag = TAG +2;
    self.txtField6.tag = TAG +3;
    self.txtField7.tag = TAG +4;
    self.txtField8.tag = TAG +5;
    self.txtField9.tag = TAG +6;
    
    XWJCity *cityinstance = [XWJCity instance];
    [cityinstance getInfoValidate:^(NSDictionary *dic) {
        
//        NSString *phone = [cityinstance.yezhu valueForKey:@"mobilePhone"];
        self.array = [dic objectForKey:@"roles"];
        [self.tableView reloadData];
        if ([dic objectForKey:@"info"]!=[NSNull null]) {
            NSString *phone = [[dic objectForKey:@"info"] valueForKey:@"mobilePhone"];
            NSLog(@"phone number %@",phone);
            _phonearray = [phone componentsSeparatedByString:@","];
            [self changeNumber:0];
        }
    }];

//    self.array = [NSArray arrayWithObjects:@"房产正在我名下",@"我是业主家属",@"我是租客", nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:0];
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    _typeindex = 0;
    self.navigationItem.title = @"绑定房源";
}
-(void)viewDidAppear:(BOOL)animated
{
    NSInteger selectedIndex = 0;
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [super viewDidAppear:animated];
}

-(void)changeNumber:(NSInteger)i{
    
    if (_phonearray&&_phonearray.count>0) {
        
        
        NSString *phoneNum = _phonearray[i];
        NSInteger count = phoneNum.length;
        NSMutableArray *numArr = [NSMutableArray array];
        for (int i=0; i<count; i++) {
            
            NSString *s1= [phoneNum substringWithRange:NSMakeRange(i,1)];
            [numArr addObject:s1];
            NSLog(@" %@",s1);
        }
        _phone1 = [[numArr objectAtIndex:0] integerValue];
        _phone2 = [[numArr objectAtIndex:1] integerValue];
        _phone3 = [[numArr objectAtIndex:2] integerValue];
        _phone4 = [[numArr objectAtIndex:3] integerValue];
        _phone5 = [[numArr objectAtIndex:4] integerValue];
        _phone6 = [[numArr objectAtIndex:5] integerValue];
        _phone7 = [[numArr objectAtIndex:6] integerValue];
        _phone8 = [[numArr objectAtIndex:7] integerValue];
        _phone9 = [[numArr objectAtIndex:8] integerValue];
        _phone10 = [[numArr objectAtIndex:9] integerValue];
        _phone11 = [[numArr objectAtIndex:10] integerValue];

                _label1.text = [NSString stringWithFormat:@"%ld",(long)_phone1];
                _label2.text = [NSString stringWithFormat:@"%ld",(long)_phone2];
                _label3.text = [NSString stringWithFormat:@"%ld",(long)_phone3];
                _label10.text = [NSString stringWithFormat:@"%ld",(long)_phone10];
                _label11.text = [NSString stringWithFormat:@"%ld",(long)_phone11];
//        _phone1 = ([_phonearray[i] integerValue]/(int)10000000000);
//        _phone2 = ([_phonearray[i] intValue]/(int)1000000000)%(int)10;
//        _phone3 = ([_phonearray[i] intValue]/(int)100000000)%(int)10;
//        _phone4 = ([_phonearray[i] integerValue]/(int)10000000)%(int)10;
//        _phone5 = ([_phonearray[i] integerValue]/(int)1000000)%(int)10;
//        _phone6 = ([_phonearray[i] integerValue]/(int)100000)%(int)10;
//        _phone7 = ([_phonearray[i] integerValue]/(int)10000)%(int)10;
//        _phone8 = ([_phonearray[i] integerValue]/(int)1000)%(int)10;
//        _phone9 = ([_phonearray[i] integerValue]/(int)100)%(int)10;
//        _phone10 = ([_phonearray[i] integerValue]/(int)10)%(int)10;
//        _phone11 = ([_phonearray[i] integerValue])%(int)10;
//        
//        _label1.text = [NSString stringWithFormat:@"%ld",(long)_phone1];
//        _label2.text = [NSString stringWithFormat:@"%d",_phone2];
//        _label3.text = [NSString stringWithFormat:@"%d",_phone3];
//        _label10.text = [NSString stringWithFormat:@"%ld",(long)_phone10];
//        _label11.text = [NSString stringWithFormat:@"%ld",(long)_phone11];
    }
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
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // Configure the cell...
    
    cell.imageView.image = [UIImage imageNamed:@"jiaoseicon"];
    cell.imageView.highlightedImage = [UIImage imageNamed:@"jiaoseiconselect"];
    cell.textLabel.text = [[self.array objectAtIndex:indexPath.row] objectForKey:@"Memo"];
    cell.textLabel.textColor = XWJGRAYCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    _typeindex = indexPath.row+1;
    _typeindex = indexPath.row;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location > 0 ||string.length>0){
//        if ([string  isEqual:@"\n"]) {
        
            NSInteger tag =  textField.tag;
            switch (tag) {
                case TAG+1:{
                    self.txtField4.text = string;
                   // self.txtField5.text = string;
                    [self.txtField5 becomeFirstResponder];
                
                }
                    break;
                case TAG+2:{
                    self.txtField5.text = string;
                  //  self.txtField6.text = string;

                    [self.txtField6 becomeFirstResponder];
                }
                    break;
                case TAG+3:{
                    self.txtField6.text = string;
                   // self.txtField7.text = string;

                    [self.txtField7 becomeFirstResponder];
                }
                    break;
                case TAG+4:{
                    self.txtField7.text = string;
                  //  self.txtField8.text = string;

                    [self.txtField8 becomeFirstResponder];
                }
                    break;
                case TAG+5:{
                    self.txtField8.text = string;
                   // self.txtField9.text = string;
                    [self.txtField9 becomeFirstResponder];
                }
                    break;
                case TAG+6:{
                    self.txtField9.text = string;

                    [self.txtField9 resignFirstResponder];
                }
                    break;
                default:
                    break;
            }
        for (id text in self.view.subviews) {
            if ([text isKindOfClass:[UITextField class]]) {
                UITextField *textField = text;
                [textField resignFirstResponder];
            }
        }
//        }
        return NO; // return NO to not change text
    }

    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)change:(UIButton *)sender {
    if (_phonearray&&_phonearray.count>0) {
        _phoneindex ++;
        if (_phoneindex >= _phonearray.count) {
            _phoneindex = 0;
        }
        [self changeNumber:_phoneindex];
    }
    
}

-(BOOL)checkphone:(NSInteger) i{
    
    NSInteger n4= [self.txtField4.text integerValue];
    NSInteger n5= [self.txtField5.text integerValue];
    NSInteger n6= [self.txtField6.text integerValue];
    NSInteger n7= [self.txtField7.text integerValue];
    NSInteger n8= [self.txtField8.text integerValue];
    NSInteger n9= [self.txtField9.text integerValue];
    
    if (n4==_phone4&&n5==_phone5&&n6==_phone6&&n7==_phone7&&n8==_phone8&&n9==_phone9) {
        return YES;
    }
   
    return NO;
}


- (IBAction)sure:(UIButton *)sender {
    if ([self checkphone:_phoneindex]) {
        XWJCity *city = [XWJCity instance];
        [city bindRoom:[NSString stringWithFormat:@"%@",[[self.array objectAtIndex:_typeindex ] valueForKey:@"DictValue"]]  :^(NSInteger arr) {
            
            if (arr==1) {
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"绑定成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertview show];
                
//                if ([XWJAccount instance].array.count<0) {
//                
//                    NSString *uname = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
//                    NSString *pass = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
//                    [[XWJAccount instance] login:uname :pass];
//                }
                
                alertview.delegate = self;
            }
        }];
    }else{
        [ProgressHUD showError:@"验证失败"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSArray *views = self.navigationController.viewControllers;
    BOOL isHome = NO;
    for (UIViewController *con  in views) {
        if ([con isKindOfClass:[XWJHomeViewController class]]) {
            isHome = YES;
            break;
        }
    }
    if (isHome) {
        
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else{
    
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        

//        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"XWJLoginStoryboard" bundle:nil];
//        self.view.window.rootViewController = [loginStoryboard instantiateInitialViewController];
        
        [self login:[XWJAccount instance].account :[XWJAccount instance].password];
    }
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
                
                NSString *uname = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
                NSString *pass = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
                //            [XWJAccount instance].uid = ;
                if (![username isEqualToString:uname]) {
                    [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username"];
                    [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:@"password"];
                    //                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"bind"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else if(![pwd isEqualToString:pass]){
                    [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:@"password"];
                }
                
                NSDictionary *userDic = [[dic objectForKey:@"data"] objectForKey:@"user"];
                NSString *sid = [userDic valueForKey:@"id"];
                NSLog(@"sid %@",sid);
                [XWJAccount instance].uid = sid;
                [XWJAccount instance].account = [userDic valueForKey:@"Account"];
                [XWJAccount instance].password = pass;
                [XWJAccount instance].NickName =[userDic valueForKey:@"NickName"];
                [XWJAccount instance].name = [userDic valueForKey:@"NAME"];
                [XWJAccount instance].Sex = [userDic valueForKey:@"sex"];
                [XWJAccount instance].phone = [userDic valueForKey:@"TEL"];
                /*
                 "A_id" = 4;
                 "A_name" = "\U9ea6\U5c9b\U91d1\U5cb8";
                 isDefault = 1;
                 */
                [XWJAccount instance].array = [[dic objectForKey:@"data"] valueForKey:@"area"];
                if ([XWJAccount instance].array&&[XWJAccount instance].array.count>0) {
                    for (NSDictionary *di in [XWJAccount instance].array ) {
                        if ([[di valueForKey:@"isDefault" ] integerValue]== 1) {
                            [XWJAccount instance].aid = [NSString stringWithFormat:@"%@",[di valueForKey:@"A_id"]];
                        }
                    }
                }
                
                //                BOOL isBind = [[NSUserDefaults standardUserDefaults] boolForKey:@"bind"];
//                BOOL isBind = [XWJAccount instance].aid?TRUE:FALSE;
//                if (!isBind) {
//                    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"xuanzefangshi"];
//                    [self.navigationController showViewController:view sender:nil];
//                }else{
                
                    XWJTabViewController *tab = [[XWJTabViewController alloc] init];
                    //                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    self.view.window.rootViewController = tab;
//                }
            }else{
                NSString *errCode = [dic objectForKey:@"errorCode"];
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertview.delegate = self;
                [alertview show];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"log fail ");
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
//- (IBAction)bind:(UIButton *)sender {
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.txtField4 resignFirstResponder];
    [self.txtField5 resignFirstResponder];
    [self.txtField6 resignFirstResponder];
    [self.txtField7 resignFirstResponder];
    [self.txtField8 resignFirstResponder];
    [self.txtField9 resignFirstResponder];
}



@end
