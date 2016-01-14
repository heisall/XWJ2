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
#import "LCBannerView.h"
#import "XWJWebViewController.h"
#import "UIImage+Category.h"
#import "UMSocial.h"
#import "ProgressHUD/ProgressHUD.h"

#define KEY_HEADIMG @"headimg"
#define KEY_TITLE @"title"
#define KEY_TIME  @"time"
#define KEY_CONTENT @"content"

@interface XWJFindDetailViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,LCBannerViewDelegate,UMSocialUIDelegate>
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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)shareDetail:(id)sender;
@property  UIControl *controlView;
@property  CGRect bottomRect;
@property(nonatomic,copy)NSString* shareImageStr;
@property(nonatomic,copy)NSString* sharecontStr;
@end

@implementation XWJFindDetailViewController
@synthesize controlView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView.delegate = self;
    [self registerForKeyboardNotifications];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    UIControl *controlView = [[UIControl alloc] initWithFrame:self.view.frame];
//    [controlView addTarget:self action:@selector(leaveEditMode) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:controlView atIndex:0];
//    controlView.backgroundColor = [UIColor clearColor];
    
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
#pragma mark - 分享按钮响应
- (void)shareDetail:(id)sender{
    NSLog(@"分享");
    UIImageView* temIV = [[UIImageView alloc] init];
    
    [temIV sd_setImageWithURL:[NSURL URLWithString:self.shareImageStr] placeholderImage:[UIImage imageNamed:@"devAdv_default"]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56938a23e0f55aac1d001cb6"
                                      shareText:self.sharecontStr
                                     shareImage:temIV.image
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:self];
}
#pragma mark - //实现回调方法（可选)
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
//    self.scrollView.contentSize = CGSizeMake(0, SCREEN_SIZE.width+60);

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;

}

-(void)phrase:(UIButton *)sender{
    NSInteger count = [sender.titleLabel.text integerValue];
    count++;
    sender.enabled = NO;
    [sender setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
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

    [self leaveEditMode];

    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dict);
            NSNumber *res =[dict objectForKey:@"result"];
            if ([res intValue] == 1) {
              
                [self getFind:0];
                NSString *errCode = [dict objectForKey:@"errorCode"];
                
                if ([types isEqualToString:@"点赞"]) {
                    [ProgressHUD showSuccess:@"点赞成功"];
                }else
                    [ProgressHUD showSuccess:@"评论成功"];

//                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                alertview.delegate = self;
//                [alertview show];
                self.textView.text = @"在此发表评论";
//                [self.navigationController popViewControllerAnimated:NO];

                
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index{
    XWJWebViewController * web = [[XWJWebViewController alloc] init];
    NSString *urls = [self.dic objectForKey:@"Photo"]==[NSNull null]?@"":[self.dic objectForKey:@"Photo"];
    
    NSArray *url = [urls componentsSeparatedByString:@","];
    web.url = [url objectAtIndex:index];
    self.shareImageStr = [url firstObject];
    [self.navigationController pushViewController:web animated:NO];
}

-(void)getFind:(NSInteger )index{
    
    NSString *url = GETFIND_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[self.dic valueForKey:@"id"]  forKey:@"id"];
    [dict setValue:[XWJAccount instance].uid forKey:@"userid"];
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
                
                self.array = [NSMutableArray arrayWithArray:[[dict objectForKey:@"data"] objectForKey:@"comments"]];
                self.dic = [NSMutableDictionary dictionaryWithDictionary:[(NSDictionary*)[dict objectForKey:@"data"] objectForKey:@"find"] ];
                [self initView];
                
                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                
//                    self.tableView.frame = CGRectMake(0
//                                                      , self.tableView.frame.origin.y, SCREEN_SIZE.width, 100*self.array.count);
////                    [self.view setNeedsLayout];
//                });

                [self.tableView reloadData];
                self.scrollView.contentSize = CGSizeMake(0,self.phraseBtn.frame.origin.y +60+100*self.array.count);

            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.textView resignFirstResponder];
}
-(void)initView{

    NSString * zanCount = [self.dic objectForKey:@"ClickPraiseCount"]==[NSNull null]?@" ":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"ClickPraiseCount"]];
    NSString *  leaveCount= [self.dic objectForKey:@"LeaveWordCount"]==[NSNull null]?@" ":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"LeaveWordCount"]];
    NSString * qqCount = [self.dic objectForKey:@"ShareQQCount"]==[NSNull null]?@" ":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"ShareQQCount"]];
//    NSString * wxCount = [NSString stringWithFormat:@"%@", [self.dic objectForKey:@"shareWXCount"]];

    [_phraseBtn setTitle:zanCount forState:UIControlStateNormal];
    [_CommentBtn setTitle:leaveCount forState:UIControlStateNormal];
//    [_shareBtn setTitle:qqCount forState:UIControlStateNormal];
//    [_phraseBtn setTitle:zanCount forState:UIControlStateNormal];
    NSString * name = [self.dic objectForKey:@"NickName"]==[NSNull null]?@" ":[NSString stringWithFormat:@"%@",[self.dic objectForKey:@"NickName"]];

    [_infoBtn setTitle:name forState:UIControlStateNormal];
    _timelabel.text = [self.dic objectForKey:@"ReleaseTime"];
    _titleLabel.text=[self.dic objectForKey:@"content"];
    self.sharecontStr = [self.dic objectForKey:@"content"];
        _typeLabel.text = [self.dic objectForKey:@"Memo"];
    
    NSString *type = [self.dic objectForKey:@"Memo"];
    if ([type isEqualToString:@"社区分享"]) {
        _typeLabel.backgroundColor = XWJColor(255,44, 56);
    }else if ([type isEqualToString:@"跳蚤市场"]){
        _typeLabel.backgroundColor = XWJColor(234, 116, 13);
    }else{
        _typeLabel.backgroundColor = XWJColor(67, 164, 83);
    }

    NSString * userP = [self.dic objectForKey:@"userP"]==[NSNull null]?nil:[self.dic objectForKey:@"userP"];
    if (userP) {
        [_infoBtn.imageView sd_setImageWithURL:[NSURL URLWithString:userP] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            
            //        _infoBtn.imageView.contentMode = UIViewContentModeCenter;
            //        _infoBtn.imageView.frame = CGRectMake(_infoBtn.imageView.frame.origin.x, _infoBtn.imageView.frame.origin.y, _infoBtn.bounds.size.height, _infoBtn.bounds.size.height);
            
            CGFloat width=  _infoBtn.bounds.size.height-5;
            _infoBtn.imageView.layer.cornerRadius = width/2;
            [_infoBtn setImage:[image transformWidth:width height:width] forState:UIControlStateDisabled];
            
        }];
    }

    
//    [_infoBtn.imageView sd_setImageWithURL:[NSURL URLWithString:userP] placeholderImage:[UIImage imageNamed: @"demo"]];
    

    NSString *urls = [self.dic objectForKey:@"Photo"]==[NSNull null]?@"":[self.dic objectForKey:@"Photo"];

        NSArray *url = [urls componentsSeparatedByString:@","];
        [self.imageView addSubview:({
            
            LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0, 0, self.imageView.bounds.size.width,
                                                                                    self.imageView.bounds.size.height)
                                        
                                                                delegate:self
                                                               imageURLs:url
                                                        placeholderImage:@"devAdv_default"
                                                           timerInterval:5.0f
                                           currentPageIndicatorTintColor:XWJGREENCOLOR
                                                  pageIndicatorTintColor:[UIColor whiteColor]];
            bannerView;
        })];

//    [_imageView sd_setImageWithURL:[NSURL URLWithString:userP] placeholderImage:[UIImage imageNamed: @"demo"]];
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
    
    
    [cell.headImgView  sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Photo"]==[NSNull null]?@"":[dic objectForKey:@"Photo"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        CGFloat width=  cell.headImgView.bounds.size.height;
        cell.headImgView.layer.cornerRadius = width/2;
        cell.headImgView.layer.masksToBounds = YES;
        [cell.headImgView  setImage:[image transformWidth:width height:width]];
 

    }];
    
//    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Photo"]==[NSNull null]?@"":[dic objectForKey:@"Photo"]]placeholderImage:[UIImage imageNamed:@"demo"]];
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
//    self.bottomView.frame = CGRectMake(self.bottomRect.origin.x, self.bottomRect.origin.y-(kbSize.height-self.bottomRect.size.height), self.bottomRect.size.width, self.bottomRect.size.height);
    
    self.bottomView.frame = CGRectMake(self.bottomRect.origin.x, self.bottomRect.origin.y-kbSize.height, self.bottomRect.size.width, self.bottomRect.size.height);

    self.textView.text = @"";
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
    [self pubCommentLword:self.textView.text type:@"留言"];
    [self.textView resignFirstResponder];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
//    if (!controlView) {
//        controlView        = [[UIControl alloc] initWithFrame:self.view.frame];
//        [controlView addTarget:self action:@selector(leaveEditMode) forControlEvents:UIControlEventTouchUpInside];
//        controlView.backgroundColor = [UIColor clearColor];
//    }
//    [self.view addSubview:controlView];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 40, 40);
//    [btn setTitle:@"完成" forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
//    [btn addTarget:self action:@selector(leaveEditMode) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *done= [[UIBarButtonItem  alloc] initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem = done;
}



- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [controlView removeFromSuperview];
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
