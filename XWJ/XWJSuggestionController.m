//
//  XWJSuggestionController.m
//  XWJ
//
//  Created by Sun on 15/11/29.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJSuggestionController.h"
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width
@implementation XWJSuggestionController{

    UITextView *textv;
    UIButton *_button;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"给我们建议";
    [self createUI];
}

-(void)createUI{
    
    textv = [[UITextView alloc]init];
    textv.frame = CGRectMake(5, 90, WIDTH - 10, 100);
    //    UITextField * textField = (UITextField *)[self.view viewWithTag:1];
    //textF.placeholder = @"请修改建议";
    //    //    设置文本的字体类型和大小
    //textv.font = [UIFont italicSystemFontOfSize:15];
    //    //    设置字体颜色(默认为黑色)
    //    textField.textColor = [UIColor redColor];
    
    //textv.adjustsFontSizeToFitWidth = YES;
    //textv.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textv];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame  = CGRectMake(5, 210, WIDTH - 10, 30);
    [_button setTitle:@"完成" forState:UIControlStateNormal];
    _button.layer.cornerRadius = 5;
    _button.backgroundColor = [UIColor colorWithRed:0.18 green:0.67 blue:0.65 alpha:1];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(onButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
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
    parameters[@"userid"] = @"70";
    parameters[@"content"] = @"dsad是多少";
    
    [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析服务器返回的数据responseObject
//        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"------%@",str);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"租售数据%@",dict);
         NSLog(@"成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败==%@",error);
    }];
//    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //解析服务器返回的数据responseObject
//        //    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        //  NSLog(@"------%@",str);
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"租售数据%@",dict);
//         NSLog(@"成功");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"请求失败==%@",error);
//    }];


    
}

@end
