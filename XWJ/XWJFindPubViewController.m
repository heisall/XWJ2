//
//  XWJFindPubViewController.m
//  XWJ
//
//  Created by Sun on 15/12/4.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJFindPubViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "LGPhoto.h"
#import "ProgressHUD.h"
#import "XWJAccount.h"
#import "AFNetworking.h"
#import "XWJUtil.h"
#define IMAGECOUNT 6
#define imgtag 100

#define IMAGE_WIDTH 80
#define spacing 5
#define TAG 100
@interface XWJFindPubViewController ()<LGPhotoPickerViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>{
    UIView *backview;
    UIScrollView *helperView;
    UIImageView *imgView;

}
@property(nonatomic)UIImagePickerController *picker;
@property (nonatomic, assign) LGShowImageType showType;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (nonatomic)UIBarButtonItem *rightBarItem;
@property (nonatomic)NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property(nonatomic,assign)NSInteger willDeleImage;
@property NSInteger select;
@end

@implementation XWJFindPubViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for (int i = 0; i<IMAGECOUNT; i++) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(IMAGE_WIDTH+spacing), 0,IMAGE_WIDTH, IMAGE_WIDTH)];
        imgView.tag = TAG+i;
        [self.imageScroll addSubview:imgView];
    }
    
    self.typeBackView.layer.borderWidth =0.5;
    self.typeBackView.layer.borderColor = [[UIColor colorWithWhite:0.8  alpha:1] CGColor];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.dataSource = [NSArray arrayWithObjects:@"二手市场",@"帮帮忙",@"个人商店", nil];
//    [self.dataSource removeObjectAtIndex:0];
    self.contentTextView.delegate = self;
    self.select = -1;
    self.imageArray = [NSMutableArray array];
}

-(void)showSortView:(UIButton *)btn{
    //添加半透明背景图

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
    helperView=[[UIScrollView alloc]initWithFrame:CGRectMake(kHelperOrign_X, kHelperOrign_Y,self.view.frame.size.width-2*kHelperOrign_X, 300)];
    helperView.backgroundColor=[UIColor whiteColor];
    helperView.layer.cornerRadius=5;
    helperView.tag=1002;
    helperView.clipsToBounds=YES;
    //    helperView.contentSize = CGSizeMake(helperView.frame.size.width, 500);
    [backview addSubview:helperView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 40)];
    titleLabel.textColor=[UIColor colorWithRed:95.0/255.0 green:170.0/255.0 blue:249.0/255.0 alpha:1];
    titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [helperView addSubview:titleLabel];
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, helperView.frame.size.width, 2)];
    line.backgroundColor=[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1];
    [helperView addSubview:line];
    
    NSMutableArray *array ;
    
    array = self.dataSource;
    NSInteger  count = array.count  ;
    //    [array addObjectsFromArray:self.findlistArr];
    for (int i=0; i<count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 40+40*i, helperView.frame.size.width, 40);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 40)];
        label.text= [[array objectAtIndex:i] valueForKey:@"memo"];
        [button addSubview:label];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(button.frame.size.width-20-10, 10, 20, 20)];
        //       imageView.image=[UIImage imageNamed:@"tcpUnselect"];
        //        if (sortSelected==i) {
        //            imageView.image=[UIImage imageNamed:@"tcpSelect"];
        //        }
        imageView.tag=7001;
        [button addSubview:imageView];
        
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 40-1, helperView.frame.size.width, 1)];
        line.backgroundColor=[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1];
        [button addTarget:self action:@selector(sortTypeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=60001+i;
        [button addSubview:line];
        
        [helperView addSubview:button];
    }
    
    UIButton *closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame=CGRectMake(self.view.window.frame.size.width-kHelperOrign_X-32/2, kHelperOrign_Y-32/2, 32, 32);
    [backview addSubview:closeButton];
    float space=(helperView.bounds.size.width-40-120);
    for (NSUInteger i=0; i<count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(20+(space+60)*i, helperView.bounds.size.height-10-30, 60, 30);
        button.tag=50001+i;
        [button addTarget:self action:@selector(confirmbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [helperView addSubview:button];
    }
    helperView.contentSize = CGSizeMake(0, 40*(count+1));
    
}

-(void)sortTypeButtonClicked:(UIButton *)button{
    
    [self closeButtonClicked];
    
    NSInteger index = button.tag - 60001;
    self.select = index;

    [self.typeBtn setTitle:[[self.dataSource objectAtIndex:index] valueForKey:@"memo"] forState:UIControlStateNormal];
    NSLog(@"selcet id %ld",index);
    
}

-(void)confirmbuttonClick:(UIButton *)button{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        if (button.tag==50001) {
            
        }else{
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });
}

-(void)closeButtonClicked{
    //    UIView *backview=[self.view.window viewWithTag:3333];
    [backview removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:@"发布" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundImage:image forState:UIControlStateNormal];
    self.rightBarItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    
    self.tabBarController.tabBar.hidden =YES;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden =NO;
    
}


-(void)LoadImageWith:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController * pick = [[UIImagePickerController alloc]init];
    pick.sourceType=type;
    pick.delegate=self;
    pick.allowsEditing=NO;
    [self presentViewController:pick animated:NO completion:nil];
    
}
//代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取图片并编码；
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSUInteger count = self.imageArray.count;
    
    if (count>6) {
        return;
    }
    UIImageView *imageView = [self.imageScroll viewWithTag:imgtag+count];
    
    imageView.image = image;
    
    NSData *data = UIImageJPEGRepresentation(imageView.image,0.4);
    
    
    NSString* encodeResult = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    if (encodeResult) {
        
        [self.imageArray addObject:encodeResult];
    }
    self.imageScroll.contentSize =CGSizeMake((IMAGE_WIDTH+spacing) * self.imageArray.count, IMAGE_WIDTH);
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"已取消选择");
    [self dismissViewControllerAnimated:NO completion:nil];
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
        NSUInteger count = assets.count;
        
        NSUInteger imgCount = self.imageArray.count;
        if (imgCount+count>6) {
            [ProgressHUD showError:@"最多上传六张图片"];
            return;
        }
        for (NSInteger i=0; i<count; i++) {
            LGPhotoAssets *asset = [assets objectAtIndex:i];
            UIImageView *imageView = [self.imageScroll viewWithTag:imgtag+i+imgCount];
            imageView.image = asset.compressionImage;
            NSData *data = UIImageJPEGRepresentation(imageView.image,0.4);
            
            NSString* encodeResult = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            if (encodeResult) {
                
                [self.imageArray addObject:encodeResult];
            }else{
                [self.imageArray addObject:data];
                
            }
            
            UIButton* deleImageBtn = [[UIButton alloc] initWithFrame:imageView.frame];
            [deleImageBtn addTarget:self action:@selector(deleImageBtn:) forControlEvents:UIControlEventTouchUpInside];
            deleImageBtn.tag = 900 + i;
            [deleImageBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [deleImageBtn setBackgroundColor:[UIColor blackColor]];
            deleImageBtn.alpha = 0.6;
            deleImageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.imageScroll addSubview:deleImageBtn];
        }
        
        self.imageScroll.contentSize =CGSizeMake((IMAGE_WIDTH+spacing) * self.imageArray.count, IMAGE_WIDTH);
        
    }
    
}
#pragma mark -删除图片响应
- (void)deleImageBtn:(UIButton*)btn{
    NSLog(@"=====删除第%ld个图片",btn.tag - 900);
    self.willDeleImage = btn.tag - 900;
    UIAlertView* al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该图片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [al show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (1 == buttonIndex) {
        
        if (self.imageArray.count) {
            [self.imageArray removeObjectAtIndex:self.willDeleImage];
            NSLog(@"剩下的数组----%ld",self.imageArray.count);
            [self.imageScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.imageScroll.contentSize =CGSizeMake((IMAGE_WIDTH+spacing) * self.imageArray.count, IMAGE_WIDTH);
            
            for (int i = 0; i<IMAGECOUNT; i++) {
                imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(IMAGE_WIDTH+spacing), 0,IMAGE_WIDTH, IMAGE_WIDTH)];
                imgView.tag = TAG+i;
                [self.imageScroll addSubview:imgView];
            }
            
            for (int i = 0; i<self.imageArray.count; i++) {
                imgView = [self.imageScroll viewWithTag:imgtag+i];
                NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:self.imageArray[i]];
                UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
                imgView.image = _decodedImage;
//                [self.imageScroll addSubview:imgView];

                
                UIButton* deleImageBtn = [[UIButton alloc] initWithFrame:imgView.frame];
                [deleImageBtn addTarget:self action:@selector(deleImageBtn:) forControlEvents:UIControlEventTouchUpInside];
                deleImageBtn.tag = 900 + i;
                [deleImageBtn setTitle:@"删除" forState:UIControlStateNormal];
                [deleImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [deleImageBtn setBackgroundColor:[UIColor blackColor]];
                deleImageBtn.alpha = 0.3;
                deleImageBtn.titleLabel.font = [UIFont systemFontOfSize:14];

//                [imgView addSubview:deleImageBtn];
//                [self.imageScroll addSubview:imgView];

                [self.imageScroll addSubview:deleImageBtn];
            }
        }
    }
}
-(void)submit{
    
    if (!self.contentTextView.text.length>0) {
        [ProgressHUD showError:@"请输入发布内容"];
        return;
    }
    
    if (self.imageArray.count==0) {
        [ProgressHUD showError:@"请选择发布图片"];
        return;
    }
    
    if (self.select == -1) {
        [ProgressHUD showError:@"请选择发布类型"];
        return;
    }
    
    [ProgressHUD show:@"正在发布" Interaction:YES];
    NSString *url = GETFINDPUB_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"" forKey:@"rentHouse"];
    /*
     a_id	小区a_id
     appId	登录用户id
     types	类型
     content	内容
     pic1	Base64格式的字符串
     pic2	Base64格式的字符串
     pic3	Base64格式的字符串
     pic4	Base64格式的字符串
     pic5	Base64格式的字符串
     pic6	Base64格式的字符串
     */
    [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];
    [dict setValue:[XWJAccount instance].uid forKey:@"appId"];
    [dict setValue:self.contentTextView.text forKey:@"content"];
    [dict setValue:[[self.dataSource objectAtIndex:self.select] objectForKey:@"dictValue"] forKey:@"types"];
//    [dict s];
    NSInteger count = self.imageArray.count;
    for (int i=0; i<count; i++) {
        [dict setObject:[self.imageArray objectAtIndex:i] forKey:[NSString stringWithFormat:@"pic%d",i+1]] ;
    }

    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *nu = [dic objectForKey:@"result"];
            [ProgressHUD dismiss];
            if ([nu integerValue]== 1) {
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"发布成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertview.delegate = self;
                [alertview show];
            }else{
                UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:errCode delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertview.delegate = self;
                [alertview show];
            }
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"dic %@",dic);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
    
    NSLog(@"submit");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectImage:(UIButton *)sender {
//    [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];

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
        [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma  mark table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.dataSource[indexPath.row] objectForKey:@"memo"];
    cell.textLabel.textColor =[UIColor colorWithRed:68.0/255.0 green:70.0/255.0 blue:71.0/255.0 alpha:1.0];
//    celt.imageView.image = [];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-1, self.view.bounds.size.width,1)];
    view.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
    [cell addSubview:view];
    return cell;
}

- (IBAction)select:(id)sender {
    [self showSortView:(UIButton *)sender];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.select = indexPath.row;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
}

- (void)leaveEditMode {
    [self.contentTextView resignFirstResponder];
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.size.width, 40)];
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    label.text = @"请选择信息分类";
    return @"请选择信息分类";
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
