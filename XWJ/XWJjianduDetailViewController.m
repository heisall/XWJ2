//
//  XWJjianduDetailViewController.m
//  XWJ
//
//  Created by Sun on 15/12/3.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJjianduDetailViewController.h"
#import "XWJHeader.h"
#import "UIPlaceHolderTextView.h"
#import "XWJFindDetailTableViewCell.h"
#import "XWJAccount.h"
#define MYTV_MESSAGE_COMMANTS_FONT [UIFont boldSystemFontOfSize:14.0f] // 
#define LONGIN_TEXTVIEW_SELECTED_BORDER_COLOR [UIColor colorWithRed:50/255.0 green:176/255.0 blue:178/255.0 alpha:1].CGColor // 用户名和密码框选中的时候边框颜色
#define TEXT_VIEW_MIN_HEIGH 44

@interface XWJjianduDetailViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic)NSArray *array;
@property  CGRect bottomRect;
@end

@implementation XWJjianduDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
    self.commentTextView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    
    UIImage *image = [UIImage imageNamed:@"mor_icon_default"];
    [dic setObject:image forKey:KEY_HEADIMG];
    [dic setValue:@"小宝" forKey:KEY_TITLE];
    [dic setValue:@"2015-11-11" forKey:KEY_TIME];
    [dic setValue:@"保养几次了什么时候方便看车" forKey:KEY_CONTENT];
    
    [self initView];
    [self getWuyeDetail];
//    self.array = [NSArray arrayWithObjects:dic,dic,dic,dic,dic,dic,dic, nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden =YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden =NO;
    
}
- (IBAction)commect:(id)sender {
    
//    NSInteger count = [self.comBtn.titleLabel.text integerValue];
//    count++;
//    [self.comBtn setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
}
- (IBAction)zan:(UIButton *)sender {
    NSInteger count = [sender.titleLabel.text integerValue];
    count++;
    sender.enabled = NO;
    [sender setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
    [self pubCommentLword:@"" type:@"点赞"];

}
- (IBAction)share:(UIButton *)sender {
//    NSInteger count = [sender.titleLabel.text integerValue];
//    count++;
//    [sender setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
}

-(void)pubCommentLword:(NSString *)leaveword type:(NSString *)types{
    NSString *url = GETFINDPUBCOM_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    /*
     findId	发现id	String
     types	类型	String,留言/点赞
     personId	登录用户id	String
     leaveWord	留言内容	String
     findType	发现类别	String
     leixing	区别是物业还是发现	String,find/supervise
     */
    XWJAccount *account = [XWJAccount instance];
    [dict setValue:[self.dic valueForKey:@"id"]  forKey:@"findId"];
    [dict setValue:types  forKey:@"types"];
    [dict setValue: account.uid  forKey:@"personId"];
    [dict setValue:leaveword  forKey:@"leaveWord"];
    [dict setValue:[self.dic valueForKey:@"types"]  forKey:@"findType"];
    [dict setValue:@"supervise" forKey:@"leixing"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dict);
            NSNumber *res =[dict objectForKey:@"result"];
            if ([res intValue] == 1) {
                
                NSString *errCode = [dict objectForKey:@"errorCode"];
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertview.delegate = self;
                [alertview show];
                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                    [self.navigationController popViewControllerAnimated:YES];
//                });
                
                
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)getWuyeDetail{
    NSString *url = GETWUYEDETAIL_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[self.dic objectForKey:@"id"] forKey:@"id"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        /*
         "A_id" = 1;
         FindID = 9;
         ID = 16;
         LeaveWord = "\U611f\U8c22\U7ef4\U62a4\U6211\U4eec\U7684\U7f8e\U597d\U5bb6\U56ed";
         NickName = "<null>";
         PersonID = 36;
         Photo = "<null>";
         ReleaseTime = "12-15 0:00";
         Types = "\U7559\U8a00";
         
         */
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            self.array = [dic objectForKey:@"comments"];

                
            [self.tableView reloadData];
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}
-(void)initView{
    
    NSString * zanCount = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"ClickPraiseCount"]];
    NSString *  leaveCount= [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"LeaveWordCount"]];
    NSString * qqCount = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"ShareQQCount"]];
    NSString * wxCount = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"ShareQQCount"]];
    
    [_zanBtn setTitle:zanCount forState:UIControlStateNormal];
    [_comBtn setTitle:leaveCount forState:UIControlStateNormal];
    [_shareBtn setTitle:qqCount forState:UIControlStateNormal];
//    [_zanBtn setTitle:zanCount forState:UIControlStateNormal];
    
    NSString *type = [self.dic objectForKey:@"Types"];
    _timeLabel.text = [self.dic objectForKey:@"ReleaseTime"];
    _titleLabel.text=[self.dic objectForKey:@"Content"];
    _typeLabel.text = type;
    
    if ([type isEqualToString:@"工作进展"]) {
        _typeLabel.backgroundColor = XWJColor(67, 164, 83);
    }else if ([type isEqualToString:@"工作记录"]){
        _typeLabel.backgroundColor = XWJColor(234, 116, 13);
    }else{
        _typeLabel.backgroundColor = XWJColor(255,44, 56);
    }
    
    NSString *urls = [self.dic objectForKey:@"photo"];
    NSURL *url = [NSURL URLWithString:urls];
    
    [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed: @"demo"]];
}

- (IBAction)click:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWJFindDetailTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"findDetailCell"];
    if (!cell) {
        cell = [[XWJFindDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"findDetailCell"];
    }
    // Configure the cell...
    NSDictionary *dic = (NSDictionary *)self.array[indexPath.row];
    
    NSString *url ;
    if ([dic objectForKey:@"Photo"]!=[NSNull null]) {
        url = [dic objectForKey:@"Photo"];
    }else{
        url = @"";
    }
    
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
//    cell.headImgView.image = [dic objectForKey:KEY_HEADIMG];
    cell.commenterLabel.text = ([dic valueForKey:@"NickName"]==[NSNull null])?@"小王":[dic valueForKey:@"NickName"];
    cell.timeLabel.text = [dic valueForKey:@"ReleaseTime"];
    cell.contentLabel.text = [dic valueForKey:@"LeaveWord"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    [cell.dialBtn setImage:[] forState:<#(UIControlState)#>]
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 69, self.view.bounds.size.width,1)];
    //    view.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
    //    [cell addSubview:view];
    return cell;
}

- (void)clickPushButton:(UIButton *)button{
    if (!button.selected) {
        for (UIView *view in [[button superview] subviews]) {
            if ([view isKindOfClass:[UIPlaceHolderTextView class]]) {
                if (![((UITextView *)view).text isEqual:@""]) {

                    [view resignFirstResponder];
                    [self.inputTextField resignFirstResponder];
                }
            }
        }}
    button.selected = YES;
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

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    
    self.bottomRect = self.bottomView.frame ;
    self.bottomView.frame = CGRectMake(self.bottomRect.origin.x, self.bottomRect.origin.y-(kbSize.height-self.bottomRect.size.height), self.bottomRect.size.width, self.bottomRect.size.height);
    CGFloat keyboardhight;
    if(kbSize.height == 216)
    {
        keyboardhight = 0;
    }
    else
    {
        keyboardhight = 36;   //252 - 216 系统键盘的两个不同高度
    }
    [self beginAppearanceTransition:YES
                           animated:YES];
    //输入框位置动画加载
    //    [self beginMoveUpAnimation:keyboardhight];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.bottomView.frame = self.bottomRect;
    [self.commentTextView resignFirstResponder];
    //do something
}

- (IBAction)enroll:(id)sender {
    [self.commentTextView resignFirstResponder];
    [self pubCommentLword:self.commentTextView.text type:@"留言"];//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [btn addTarget:self action:@selector(leaveEditMode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *done= [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = done;
}



- (void)textViewDidEndEditing:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)leaveEditMode {
    [self.commentTextView resignFirstResponder];
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
