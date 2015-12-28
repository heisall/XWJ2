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
        
        NSString *phone = [cityinstance.yezhu valueForKey:@"mobilePhone"];
        NSLog(@"phone number %@",phone);
        _phonearray = [phone componentsSeparatedByString:@","];
        
        [self changeNumber:0];
    }];

    self.array = [NSArray arrayWithObjects:@"房产正在我名下",@"我是业主家属",@"我是租客", nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:0];
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    _typeindex = 0;
    self.navigationItem.title = @"绑定房源";
}

-(void)changeNumber:(NSInteger)i{
    
    if (_phonearray&&_phonearray.count>0) {
        
        _phone1 = ([_phonearray[i] integerValue]/10000000000);
        _phone2 = ([_phonearray[i] integerValue]/1000000000)%10;
        _phone3 = ([_phonearray[i] integerValue]/100000000)%10;
        _phone4 = ([_phonearray[i] integerValue]/10000000)%10;
        _phone5 = ([_phonearray[i] integerValue]/1000000)%10;
        _phone6 = ([_phonearray[i] integerValue]/100000)%10;
        _phone7 = ([_phonearray[i] integerValue]/10000)%10;
        _phone8 = ([_phonearray[i] integerValue]/1000)%10;
        _phone9 = ([_phonearray[i] integerValue]/100)%10;
        _phone10 = ([_phonearray[i] integerValue]/10)%10;
        _phone11 = ([_phonearray[i] integerValue])%10;
        
        _label1.text = [NSString stringWithFormat:@"%ld",_phone1];
        _label2.text = [NSString stringWithFormat:@"%ld",_phone2];
        _label3.text = [NSString stringWithFormat:@"%ld",_phone3];
        _label10.text = [NSString stringWithFormat:@"%ld",_phone10];
        _label11.text = [NSString stringWithFormat:@"%ld",_phone11];
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
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    cell.textLabel.textColor = XWJGRAYCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _typeindex = indexPath.row+1;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 0){
//        if ([string  isEqual:@"\n"]) {
        
            NSInteger tag =  textField.tag;
            switch (tag) {
                case TAG+1:{
                    self.txtField4.text = string;
                    [self.txtField5 becomeFirstResponder];
                }
                    break;
                case TAG+2:{
                    self.txtField5.text = string;

                    [self.txtField6 becomeFirstResponder];
                }
                    break;
                case TAG+3:{
                    self.txtField6.text = string;

                    [self.txtField7 becomeFirstResponder];
                }
                    break;
                case TAG+4:{
                    self.txtField7.text = string;

                    [self.txtField8 becomeFirstResponder];
                }
                    break;
                case TAG+5:{
                    self.txtField8.text = string;

                    [self.txtField9 becomeFirstResponder];
                }
                    break;
                case TAG+6:{
                    self.txtField9.text = string;

                    [textField resignFirstResponder];
                }
                    break;
                default:
                    break;
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
        [city bindRoom:[NSString stringWithFormat:@"%ld",(long)_typeindex]  :^(NSInteger arr) {
            
            if (arr==1) {
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"绑定成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertview show];

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
        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.view.window.rootViewController = tab;
    }
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

@end
