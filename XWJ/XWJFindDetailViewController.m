//
//  XWJFindDetailViewController.m
//  XWJ
//
//  Created by Sun on 15/12/5.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJFindDetailViewController.h"
#import "XWJFindDetailTableViewCell.h"
#import "XWJAccount.h"
#define KEY_HEADIMG @"headimg"
#define KEY_TITLE @"title"
#define KEY_TIME  @"time"
#define KEY_CONTENT @"content"

@interface XWJFindDetailViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *CommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *phraseBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property  CGRect bottomRect;

@end

@implementation XWJFindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView.delegate = self;
    [self registerForKeyboardNotifications];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    [self initView];
    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    
    UIImage *image = [UIImage imageNamed:@"mor_icon_default"];
    [dic setObject:image forKey:KEY_HEADIMG];
    [dic setValue:@"小宝" forKey:KEY_TITLE];
    [dic setValue:@"2015-11-11" forKey:KEY_TIME];
    [dic setValue:@"保养几次了什么时候方便看车" forKey:KEY_CONTENT];
    [self getFind:0];
    
    [self.phraseBtn addTarget:self action:@selector(phrase:) forControlEvents:UIControlEventTouchUpInside];
//    self.array = [NSArray arrayWithObjects:dic,dic,dic,dic,dic,dic,dic, nil];

}

-(void)phrase:(UIButton *)sender{
    NSInteger count = [sender.titleLabel.text integerValue];
    count++;
    sender.enabled = NO;
    [sender setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
    [self pubCommentLword:@"" type:@"点赞"];
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
    [dict setValue:@"find" forKey:@"leixing"];

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
                
                [self.navigationController popViewControllerAnimated:YES];

                
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)getFind:(NSInteger )index{
    
    NSString *url = GETFIND_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[self.dic valueForKey:@"id"]  forKey:@"id"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        /*
         find =         {
         "a_id" = "<null>";
         appID = 12;
         clickPraiseCount = 0;
         content = "\U661f\U5df4\U514b\U4e4b\U9ebb\U8fa3\U706b\U9505";
         id = 10;
         leaveWordCount = 0;
         nickName = "<null>";
         photo = "http://www.hisenseplus.com/HisenseUpload/find_photo/imag201512082013535403.jpg,http://www.hisenseplus.com/HisenseUpload/find_photo/imag201512082013535601.jpg,http://www.hisenseplus.com/HisenseUpload/find_photo/imag201512082013535471.jpg,http://www.hisenseplus.com/HisenseUpload/find_photo/imag201512082013535433.jpg,http://www.hisenseplus.com/HisenseUpload/find_photo/imag201512082013535420.jpg,http://www.hisenseplus.com/HisenseUpload/find_photo/imag201512082013535552.jpg";
         releaseTime = "12-08 20:13";
         shareQQCount = 0;
         shareWXCount = 0;
         types = "\U597d\U4eba\U597d\U4e8b";
         };
         */
        if(responseObject){
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dict);
            NSNumber *res =[dict objectForKey:@"result"];
            if ([res intValue] == 1) {
                
                
                /*
                 
                 "A_id" = 1;
                 FindID = 22;
                 ID = 15;
                 LeaveWord = "\U671f\U5f85\U5723\U8bde\U8001\U7237\U7237\U7684\U5230\U6765";
                 NickName = "<null>";
                 PersonID = 36;
                 Photo = "<null>";
                 ReleaseTime = "12-15 0:00";
                 Types = "\U7559\U8a00";
                 */
                
                self.array = [[dict objectForKey:@"data"] objectForKey:@"comments"]; 
                self.dic = [NSMutableDictionary dictionaryWithDictionary:[(NSDictionary*)[dict objectForKey:@"data"] objectForKey:@"find"] ];
                [self initView];
                [self.tableView reloadData];

            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)initView{

    NSString * zanCount = [self.dic objectForKey:@"clickPraiseCount"]==[NSNull null]?@" ":[self.dic objectForKey:@"clickPraiseCount"];
    NSString *  leaveCount= [self.dic objectForKey:@"leaveWordCount"]==[NSNull null]?@" ":[self.dic objectForKey:@"leaveWordCount"];
    NSString * qqCount = [self.dic objectForKey:@"shareQQCount"]==[NSNull null]?@" ":[self.dic objectForKey:@"shareQQCount"];
//    NSString * wxCount = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"shareWXCount"]];

    [_phraseBtn setTitle:zanCount forState:UIControlStateNormal];
    [_CommentBtn setTitle:leaveCount forState:UIControlStateNormal];
    [_shareBtn setTitle:qqCount forState:UIControlStateNormal];
    [_phraseBtn setTitle:zanCount forState:UIControlStateNormal];

    _timelabel.text = [self.dic objectForKey:@"releaseTime"];
    _titleLabel.text=[self.dic objectForKey:@"content"];
        _typeLabel.text = [self.dic objectForKey:@"Memo"];
    
    NSString *type = [self.dic objectForKey:@"Memo"];
    if ([type isEqualToString:@"社区分享"]) {
        _typeLabel.backgroundColor = XWJColor(255,44, 56);
    }else if ([type isEqualToString:@"跳蚤市场"]){
        _typeLabel.backgroundColor = XWJColor(234, 116, 13);
    }else{
        _typeLabel.backgroundColor = XWJColor(67, 164, 83);
    }
    NSString *urls = [self.dic objectForKey:@"photo"];
    NSURL *url = [NSURL URLWithString:[[urls componentsSeparatedByString:@","] objectAtIndex:0]];

    [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed: @"demo"]];
}

/*
 "a_id" = "<null>";
 appID = 12;
 clickPraiseCount = 0;
 content = "\U661f\U5df4\U514b\U4e4b\U9ebb\U8fa3\U706b\U9505";
 id = 10;
 leaveWordCount = 0;
 nickName = "<null>";
 photo = "http://www.hisenseplus.com/HisenseUpload/find_photo/imag201512082013535403.jpg,http://www.hisenseplus.com/HisenseUpload/find_photo/imag201512082013535601.jpg,http://www.hisenseplus.com/HisenseUpload/find_photo/imag201512082013535471.jpg,http://www.hisenseplus.com/HisenseUpload/find_photo/imag201512082013535433.jpg,http://www.hisenseplus.com/HisenseUpload/find_photo/imag201512082013535420.jpg,http://www.hisenseplus.com/HisenseUpload/find_photo/imag201512082013535552.jpg";
 releaseTime = "12-08 20:13";
 shareQQCount = 0;
 shareWXCount = 0;
 types = "\U597d\U4eba\U597d\U4e8b";
 */
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
    
    
    
    /*
     
     "A_id" = 1;
     FindID = 22;
     ID = 15;
     LeaveWord = "\U671f\U5f85\U5723\U8bde\U8001\U7237\U7237\U7684\U5230\U6765";
     NickName = "<null>";
     PersonID = 36;
     Photo = "<null>";
     ReleaseTime = "12-15 0:00";
     Types = "\U7559\U8a00";
     */
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Photo"]==[NSNull null]?@"":[dic objectForKey:@"Photo"]]];
    cell.commenterLabel.text = [dic objectForKey:@"NickName"]==[NSNull null]?@" ":[dic objectForKey:@"NickName"];
    cell.timeLabel.text = [dic objectForKey:@"ReleaseTime"]==[NSNull null]?@" ":[dic objectForKey:@"ReleaseTime"];
    cell.contentLabel.text = [dic objectForKey:@"LeaveWord"]==[NSNull null]?@" ":[dic objectForKey:@"LeaveWord"];
    
//    cell.headImgView.image = [dic objectForKey:KEY_HEADIMG];
//    cell.commenterLabel.text = [dic valueForKey:KEY_TITLE];
//    cell.timeLabel.text = [dic valueForKey:KEY_TIME];
//    cell.contentLabel.text = [dic valueForKey:KEY_CONTENT];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    [cell.dialBtn setImage:[] forState:<#(UIControlState)#>]
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 69, self.view.bounds.size.width,1)];
    //    view.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
    //    [cell addSubview:view];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FindStoryboard" bundle:nil];
//    [self.navigationController showViewController:[storyboard instantiateViewControllerWithIdentifier:@"activityDetail"] sender:nil];
    
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
    //do something
}

- (IBAction)enroll:(id)sender {
    
    [self.textView resignFirstResponder];
    [self pubCommentLword:self.textView.text type:@"留言"];
//    [self.navigationController popViewControllerAnimated:YES];
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
    [self.textView resignFirstResponder];
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
