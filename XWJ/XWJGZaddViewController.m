//
//  XWJGZaddViewController.m
//  XWJ
//
//  Created by Sun on 15/12/12.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJGZaddViewController.h"
#import "LGPhoto.h"
#import "XWJAccount.h"
#import "ProgressHUD.h"
@interface XWJGZaddViewController ()<LGPhotoPickerViewControllerDelegate>{
    UIView *backview;
    UIView *helperView;
}

@property (weak, nonatomic) IBOutlet UITextView *guzhangTV;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property NSMutableArray *lp;
@property NSMutableArray *cx;
@property NSMutableArray *md;
@property NSMutableArray *zx;

@property NSInteger lpIndex;
@property NSMutableArray *imageDatas;

@end

@implementation XWJGZaddViewController
#define imgtag 100
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"报修";
    for (int i = 0; i<IMAGECOUNT; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(IMAGE_WIDTH+spacing), 0,IMAGE_WIDTH, IMAGE_WIDTH)];
        imgView.tag = imgtag+i;
        [self.scrollView addSubview:imgView];
    }
    self.lp = [NSMutableArray arrayWithObjects:@"随时上门",@"上午",@"下午",@"晚上", nil];
}
- (IBAction)addImage:(UIButton *)sender {
    [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];


}

- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    // 创建控制器
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // 最多能选9张图片
    pickerVc.maxCount = 6;
    pickerVc.delegate = self;
    //    self.showType = style;
    [pickerVc showPickerVc:self];
}

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    
    if (assets&&assets.count>0) {
        self.imageDatas = [NSMutableArray array];
        NSUInteger count = assets.count;
        for (int i=0; i<count; i++) {
            LGPhotoAssets *asset = [assets objectAtIndex:i];
            UIImageView *imageView = [self.scrollView viewWithTag:imgtag+i];
            imageView.image = asset.compressionImage;
            
            NSData *data = UIImageJPEGRepresentation(imageView.image,1.0);
            //            NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            
            
//            NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            
//            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
//            NSString *rawString=[[NSString alloc]initWithData:data encoding:enc];
//            NSString *rawString=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];

            NSString* encodeResult = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            if (encodeResult) {
                
                [self.imageDatas addObject:encodeResult];
            }else{
                [self.imageDatas addObject:data];
                
            }
        }
        
        self.scrollView.contentSize =CGSizeMake((IMAGE_WIDTH+spacing) * count, IMAGE_WIDTH);
        
    }
    
}

-(void)showSortView:(UIButton *)btn{
    //添加半透明背景图
    NSUInteger type = btn.tag;
    backview=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.window.frame.size.height)];
    backview.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
    backview.tag=4444;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButtonClicked)];
    backview.userInteractionEnabled = YES;
    [backview addGestureRecognizer:tap];
    [self.view.window addSubview:backview];
    
    //    //添加helper视图
    float kHelperOrign_X=30;
    float kHelperOrign_Y=(self.view.frame.size.height-300)/2+64;
    helperView=[[UIView alloc]initWithFrame:CGRectMake(kHelperOrign_X, kHelperOrign_Y,self.view.frame.size.width-2*kHelperOrign_X, 300)];
    helperView.backgroundColor=[UIColor whiteColor];
    helperView.layer.cornerRadius=5;
    helperView.tag=1002;
    helperView.clipsToBounds=YES;
    [backview addSubview:helperView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 40)];
    titleLabel.textColor=[UIColor colorWithRed:95.0/255.0 green:170.0/255.0 blue:249.0/255.0 alpha:1];
    titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [helperView addSubview:titleLabel];
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, helperView.frame.size.width, 2)];
    line.backgroundColor=[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1];
    [helperView addSubview:line];
    
    NSMutableArray *array = [NSMutableArray array];
    NSInteger  count = 0  ;

    count = self.lp.count;
            [array addObjectsFromArray:self.lp];

    for (int i=0; i<count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 40+40*i, helperView.frame.size.width, 40);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 40)];
        label.text= [array objectAtIndex:i];
        [button addSubview:label];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(button.frame.size.width-20-10, 10, 20, 20)];
        imageView.tag=7001;
        [button addSubview:imageView];
        
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 40-1, helperView.frame.size.width, 1)];
        line.backgroundColor=[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1];
        [button addTarget:self action:@selector(sortTypeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=60001+i;
        [button addSubview:line];
        
        [helperView addSubview:button];
    }
    
}
-(void)closeButtonClicked{
    //    UIView *backview=[self.view.window viewWithTag:3333];
    [backview removeFromSuperview];
}
-(void)sortTypeButtonClicked:(UIButton *)button{
    
    [self closeButtonClicked];
    
    NSInteger index = button.tag - 60001;
    NSLog(@"selcet id %ld",index);
    self.lpIndex = index;
    [self.timeBtn setTitle:[self.lp objectAtIndex:index] forState:UIControlStateNormal];
    
}
- (IBAction)selectTime:(UIButton *)sender {
    [self showSortView:sender];
}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

/*
 id	报修、投诉id	String
 evaluate	评价内容	String
 star	星级	String
 */
- (IBAction)submit:(id)sender {
    
    [ProgressHUD show:@"正在发布" Interaction:YES];

    [self.guzhangTV resignFirstResponder];
    NSString *url = GETFGUZHANADD_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    /*
    	
     private String userid;
     private String type;
     private String content;
     private String []pics;
     private String onDoorTime;
     */

    XWJAccount *account = [XWJAccount instance];
    [dict setValue:self.guzhangTV.text forKey:@"content"];
    if (self.imageDatas) {
        [dict setObject:self.imageDatas forKey:@"pics"];
    }
    [dict setObject:account.uid forKey:@"userid"];
    if (self.type ==1) {
        [dict setValue:@"维修" forKey:@"type"];
    }else
        [dict setValue:@"投诉" forKey:@"type"];
    
    [dict setValue:[self.lp objectAtIndex:self.lpIndex] forKey:@"onDoorTime"];
    NSString * str = [self DataTOjsonString:dict];
    

    NSMutableDictionary *guzhang = [NSMutableDictionary dictionary];
    [guzhang setObject:str forKey:@"complain"];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:guzhang success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            NSNumber *res =[dic objectForKey:@"result"];
            [ProgressHUD dismiss];
            if ([res intValue] == 1) {
                
                NSString *errCode = [dic objectForKey:@"errorCode"];
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertview.delegate = self;
                [alertview show];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }
            
            NSLog(@"dic %@",dic);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
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
