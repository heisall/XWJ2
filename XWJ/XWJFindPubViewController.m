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

#define IMAGE_WIDTH 80
#define spacing 5
#define TAG 100
@interface XWJFindPubViewController ()<LGPhotoPickerViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property(nonatomic)UIImagePickerController *picker;
@property (nonatomic, assign) LGShowImageType showType;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (nonatomic)UIBarButtonItem *rightBarItem;
@property (nonatomic)NSMutableArray *imageArray;

@property NSInteger select;
@end

@implementation XWJFindPubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for (int i = 0; i<IMAGECOUNT; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(IMAGE_WIDTH+spacing), 0,IMAGE_WIDTH, IMAGE_WIDTH)];
        imgView.tag = TAG+i;
        [self.imageScroll addSubview:imgView];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.dataSource = [NSArray arrayWithObjects:@"二手市场",@"帮帮忙",@"个人商店", nil];
    [self.dataSource removeObjectAtIndex:0];
    self.contentTextView.delegate = self;
    self.select = 0;
    self.imageArray = [NSMutableArray array];
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
-(void)submit{
    
    [ProgressHUD shared].image.image = [UIImage imageNamed:@"AppIcon"];
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
    [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];

//    self.picker = [[UIImagePickerController alloc] init];
//    NSArray* availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//    if ([availableMediaTypes containsObject:(NSString*)kUTTypeImage]) {
//        self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        
//        self.picker.mediaTypes = @[(NSString*) kUTTypeImage];
//        self.picker.allowsEditing = NO;
//        self.picker.delegate = self;
//        
//        
//        [self.navigationController presentViewController:self.picker animated:NO completion:nil];
//    }
    
    
    
}
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    // 创建控制器
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // 最多能选9张图片
    pickerVc.maxCount = 6;
    pickerVc.delegate = self;
    self.showType = style;
    [pickerVc showPickerVc:self];
}

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    
    if (assets&&assets.count>0) {
        
        NSUInteger count = assets.count;
        for (int i=0; i<count; i++) {
            LGPhotoAssets *asset = [assets objectAtIndex:i];
            UIImageView *imageView = [self.imageScroll viewWithTag:TAG+i];
            imageView.image = asset.compressionImage;
            
            NSData *data = UIImageJPEGRepresentation(imageView.image,1.0);
          
            NSString* encodeResult = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            [self.imageArray addObject:encodeResult];
        }
        self.imageScroll.contentSize =CGSizeMake((IMAGE_WIDTH+spacing) * count, IMAGE_WIDTH);

    }
    
}

#pragma  mark table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

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
