//
//  XWJSuggestionController.m
//  XWJ
//
//  Created by Sun on 15/11/29.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJSuggestionController.h"
#import "XWJAccount.h"
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width
@implementation XWJSuggestionController{

    UITextView *textv;
    UIButton *_button;
    UILabel *_label;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"给我们建议";
    [self createUI];
    [self registerForKeyboardNotifications];
}

-(void)createUI{
    
    
    textv = [[UITextView alloc]init];
    textv.frame = CGRectMake(5, 90, WIDTH - 10,100);
    //    UITextField * textField = (UITextField *)[self.view viewWithTag:1];
    //textF.placeholder = @"请修改建议";
    //    //    设置文本的字体类型和大小
    //textv.font = [UIFont italicSystemFontOfSize:15];
    //    //    设置字体颜色(默认为黑色)
    //    textField.textColor = [UIColor redColor];
    
    //textv.adjustsFontSizeToFitWidth = YES;
    //textv.borderStyle = UITextBorderStyleRoundedRect;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:textv];
    
    _label = [[UILabel alloc]init];
    _label.enabled = YES;
    _label.text = @"很高兴为您服务，感谢您给出的宝贵建议";
    _label.frame = CGRectMake(5, 5, 300, 30);
    _label.textColor = [UIColor lightGrayColor];
    [textv addSubview:_label];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame  = CGRectMake(5, 220, WIDTH - 10, 30);
    [_button setTitle:@"完成" forState:UIControlStateNormal];
    _button.layer.cornerRadius = 5;
    _button.backgroundColor = [UIColor colorWithRed:0.18 green:0.67 blue:0.65 alpha:1];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(onButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
}
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    [_label setHidden:YES];
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
}
-(void)onButtonClick{
    
   // self.returnStrBlock(textF.text);
    [self postSuggest];
    UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"感谢您对我们提出宝贵建议" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [a show];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //点任何空白区域才能收下键盘
    [textv resignFirstResponder];
    //    [self.view endEditing:YES];
    
}

-(void)postSuggest{
    NSString *url = @"http://www.hisenseplus.com:8100/appPhone/rest/user/adviseSubmit";
    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //请求参数
    NSMutableDictionary *parameters =[[NSMutableDictionary alloc] init];
    //16位md5加密
    //    NSString *passwordString = [self getMd5_16Bit_String:_pwdtext.text];
    parameters[@"userid"] = [XWJAccount instance].uid;
    parameters[@"content"] = textv.text;
    
    [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析服务器返回的数据responseObject
//        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        CLog(@"------%@",str);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        CLog(@"租售数据%@",dict);
         CLog(@"成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"请求失败==%@",error);
    }];
//    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //解析服务器返回的数据responseObject
//        //    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        //  CLog(@"------%@",str);
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        CLog(@"租售数据%@",dict);
//         CLog(@"成功");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        CLog(@"请求失败==%@",error);
//    }];


    
}

@end
