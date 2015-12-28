//
//  xignquaihaoViewController.m
//  XWJ
//
//  Created by 聚城科技 on 15/12/21.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "xignquaihaoViewController.h"
#import "EmoAndHobbyStatus.h"
#import "FindModel.h"
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width


@interface xignquaihaoViewController ()

@end

@implementation xignquaihaoViewController
{
     UITextField *textF;
     UIButton *_button;
     NSMutableArray *_buttonSource;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonSource = [NSMutableArray array];

//    [self createUI];
//    [EmoAndHobbyStatus getHobbyDataSuccess:^(id aa) {
//        
//    } failure:^(NSError *lal) {
//        
//    }];
    [self downLoadData];
}

-(void)createUIWithArr:(NSArray *)arr{
    int n = 0;
//    NSArray *array = @[@"唱歌",@"跳舞",@"电影",@"旅游"];
    for (int i = 0; i < arr.count; i ++) {
//        CGRectMake(30, 140 + 50*i, WIDTH - 60, 30)
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(WIDTH/4 *n + 10, 50 * (i/4)+100, (WIDTH - 40)/4-10, 30);
        n++;
        if (n == 4) {
            n = 0;
        }
        btn.frame = frame;
//        btn.layer.borderWidth = 1.0;
        btn.backgroundColor = [UIColor orangeColor];
        
        btn.layer.cornerRadius = 5;
//        btn.backgroundColor = [UIColor colorWithRed:0.60 green:0.68 blue:0.78 alpha:1];
        [btn setBackgroundImage:[UIImage imageNamed:@"agreeButtonUnenbled"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"agreeButtonSelected@2x"] forState:UIControlStateSelected];
        btn.tag = i +100;
        btn.selected = NO;
        [btn setTitle:(NSString *)arr[i][@"memo"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    UIButton *Finish = [UIButton buttonWithType:UIButtonTypeCustom];
    [Finish setTitle:@"完成" forState:UIControlStateNormal];
    Finish.titleLabel.font = [UIFont systemFontOfSize:22];
    Finish.frame = CGRectMake(WIDTH/2-100, 230, 200, 40);
    [Finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Finish setBackgroundColor:[UIColor orangeColor]];
    Finish.layer.cornerRadius = 10.0;
    Finish.layer.masksToBounds = YES;
    Finish.tag = 200;
    [Finish addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Finish];
    
}
-(void)btnAction:(UIButton *)button{
  //  NSLog(@"btn.titlelabel:%@",button.titleLabel.text);
    if (button.tag != 200) {
        button.selected = !button.selected;
        if (button.selected == YES) {
            if (![_buttonSource containsObject:button.titleLabel.text]) {
                [_buttonSource addObject:button.titleLabel.text];
            }
        }else{
            if ([_buttonSource containsObject:button.titleLabel.text]) {
                [_buttonSource removeObject:button.titleLabel.text];
            }
        }
        NSLog(@"_buttonSource%@",_buttonSource);
    }else{
        NSString *returnStr = @"";
        for (id str in _buttonSource) {
            returnStr = [returnStr stringByAppendingString:[NSString stringWithFormat:@"%@ ",str]];
        }
        NSLog(@"return:%@",returnStr);
        self.returnStrBlock(returnStr);
        [self.navigationController popViewControllerAnimated:YES];

    }

}
-(void)onButtonClick{
    
    
    self.returnStrBlock(textF.text);
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //点任何空白区域才能收下键盘
    [textF resignFirstResponder];
    //    [self.view endEditing:YES];
    
}

-(void)downLoadData{
    
    NSString *xingquUrl = @"http://www.hisenseplus.com:8100/appPhone/rest/user/findEmotions";
    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //请求参数
    NSMutableDictionary *parameters =[[NSMutableDictionary alloc] init];
    
    [manager POST:xingquUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析服务器返回的数据responseObject
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
          //  NSLog(@"dict==%@",responseObject);
                NSLog(@"dict==%@",dict);
         NSArray *ary = dict[@"data"];
//        for (NSDictionary*dic in ary) {
//            FindModel *model =[[FindModel alloc]init];
////            model.title = dic[@"memo"];
//            model.title = [dic objectForKey:@"memo"];
//            NSLog(@"%@",model.title);
//            [_buttonSource addObject:model];
//            NSLog(@"button==%ld",_buttonSource.count);
            [self createUIWithArr:ary];
//        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
    //    MainViewController * main = [[MainViewController alloc]init];
    //    [self.navigationController pushViewCon
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
