//
//  XWJMFViewController.m
//  XWJ
//
//  Created by Sun on 15/12/10.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMFViewController.h"
#import "XWJAccount.h"
#import "LGPhoto.h"
#import "XWJUtil.h"
#import "ProgressHUD.h"
#define  CELL_HEIGHT 30.0
#define  COLLECTION_NUMSECTIONS 2
#define  COLLECTION_NUMITEMS 5


@interface XWJMFViewController ()<UICollectionViewDataSource,UICollectionViewDelegate ,LGPhotoPickerViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    CGFloat collectionCellHeight;
    CGFloat collectionCellWidth;
    UIView *backview;
    UIScrollView *helperView;
}
#define IMAGECOUNT 6

#define IMAGE_WIDTH 80
#define spacing 5
@property (weak, nonatomic) IBOutlet UITextField *shiTF;
@property (weak, nonatomic) IBOutlet UITextField *tingTF;
@property (weak, nonatomic) IBOutlet UITextField *weiTF;
@property (weak, nonatomic) IBOutlet UITextField *areaTF;
@property (weak, nonatomic) IBOutlet UITextField *cengTF;
@property (weak, nonatomic) IBOutlet UITextField *totalFloorTF;
@property (weak, nonatomic) IBOutlet UILabel *chaoxiangLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhuangxiuLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *niandaiTF;
@property (weak, nonatomic) IBOutlet UITextField *jiage;
@property (nonatomic) NSArray *collectionData;
@property (nonatomic) NSMutableArray *collectionSelect;

@property NSMutableArray * selectMaidian;
@property (weak, nonatomic) IBOutlet UITextField *niandaiLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *xiaoquLabel;

@property (weak, nonatomic) IBOutlet UITextView *fyMiaoshu;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;
@property  UIControl *controlView;

@property (weak, nonatomic) IBOutlet UIButton *quedingBtn;
@property NSMutableArray *imageDatas;

@property NSMutableArray *lp;
@property NSMutableArray *cx;
@property NSMutableArray *md;
@property NSMutableArray *zx;

@property NSInteger lpIndex;
@property NSInteger cxIndex;
//@property NSInteger mdIndex;
@property NSInteger zxIndex;
@property NSInteger stype;

@end
static NSString *kcellIdentifier = @"collectionCellID";
static NSString *kheaderIdentifier = @"headerIdentifier";
@implementation XWJMFViewController
#define  imgtag 100
@synthesize controlView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.collectionData = [NSArray arrayWithObjects:@"床",@"衣柜",@"空调",@"电视",@"冰箱",@"洗衣机",@"天然气",@"暖气",@"热水器",@"宽带",nil];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZFCollectionCell" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XWJSupplementaryView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    self.fyMiaoshu.delegate = self;

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.navigationItem.title = @"我要卖房";
    [self get2hangFubFilter];
    self.scrollView.contentSize = CGSizeMake(SCREEN_SIZE.width, SCREEN_SIZE.height+200);
    for (int i = 0; i<IMAGECOUNT; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(IMAGE_WIDTH+spacing), 0,IMAGE_WIDTH, IMAGE_WIDTH)];
        imgView.tag = imgtag+i;
        [self.imgScrollView addSubview:imgView];
    }
    self.imageDatas = [NSMutableArray array];

//    [self.quedingBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchDragInside];
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -CollectionView datasource
//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    collectionCellHeight = self.collectionView.frame.size.height/COLLECTION_NUMSECTIONS-1;
    collectionCellWidth = self.collectionView.frame.size.width/COLLECTION_NUMITEMS-1;
    
    NSInteger count = self.collectionData.count;
    if (count>5) {
        return 2;
    }
    return 1;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.collectionData.count;
    if (count>5) {
        
        if (section==0) {
            return 5;
        }else
            return count-5;
    }
    return count;
//    return COLLECTION_NUMITEMS;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        //        reuseIdentifier = kfooterIdentifier;
    }else{
        reuseIdentifier = kheaderIdentifier;
    }
    
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[view viewWithTag:imgtag+1];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        label.textColor  = XWJGREENCOLOR;
        label.text  = @"卖点";
    }
    UIButton *button  = (UIButton*)[view viewWithTag:2];
    button.hidden = YES;
    return view;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    //赋值
    UIButton *btn = (UIButton *)[cell viewWithTag:1];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    NSString * key = [NSString stringWithFormat:@"%@",[self.collectionData[indexPath.section*COLLECTION_NUMITEMS+indexPath.row] objectForKey:@"dicValue"]];
    [btn setTitle: key forState:UIControlStateNormal];
//    if (indexPath.row%2==0) {
//        btn.selected = YES;
//    }
    //    cell.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:70.0/255.0 blue:71.0/255.0 alpha:1.0];
    ;
    return cell;
    
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionCellWidth, CELL_HEIGHT);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 0, 0);//分别为上、左、下、右
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        CGSize size =  {self.view.bounds.size.width,30};
        return size;
    }else{
        CGSize size={0,0};
        return size;
    }
    
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={0,0};
    return size;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)[cell viewWithTag:1];
    
    btn.selected = !btn.selected;
//    [self.collectionSelect setValue:@"" forKey:@""];
    if (btn.selected) {
        
        [_collectionSelect setObject:@"1" atIndexedSubscript:indexPath.section*+indexPath.row];
    }else{
        [_collectionSelect setObject:@"0" atIndexedSubscript:indexPath.section*+indexPath.row];

    }
//    self.collectionSelect[indexPath.section*5+indexPath.row];
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    UIButton *btn = (UIButton *)[cell viewWithTag:1];
//    btn.selected = NO;
//}
- (IBAction)select:(UIButton *)sender {
    
    [self showSortView:sender];
}

-(void)closeButtonClicked{
    //    UIView *backview=[self.view.window viewWithTag:3333];
    [backview removeFromSuperview];
}

-(void)sortTypeButtonClicked:(UIButton *)button{
    
    [self closeButtonClicked];
    
    NSInteger index = button.tag - 60001;
    NSLog(@"selcet id %ld",index);
    switch (self.stype) {
        case 1:
        {
            self.lpIndex = index;

            self.xiaoquLabel.text = [NSString stringWithFormat:@"%@",[[self.lp objectAtIndex:index] objectForKey:@"dicValue"]];
        }
            break;
        case 2:{
            self.cxIndex = index;

            self.chaoxiangLabel.text = [NSString stringWithFormat:@"%@",[[self.cx objectAtIndex:index] objectForKey:@"dicValue"]];
        }
            break;
        case 3:{
//            self.quyuIndex = index;

            
        }
            break;
        case 4:{
            self.zxIndex = index;
            self.zhuangxiuLabel.text = [NSString stringWithFormat:@"%@",[[self.zx objectAtIndex:index] objectForKey:@"dicValue"]];

        }
            break;
        default:
            break;
    }
    
}

-(void)showSortView:(UIButton *)btn{
    //添加半透明背景图
    NSUInteger type = btn.tag;
    self.stype = btn.tag;
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
    switch (type) {
        case 1:{
            count = self.lp.count;
            [array addObjectsFromArray:self.lp];
        }
            break;
        case 2:{
            count = self.cx.count;
            [array addObjectsFromArray:self.cx];
        }
            break;
        case 3:{
            count = self.md.count;
            [array addObjectsFromArray:self.md];
        }
            break;
        case 4:{
            count = self.zx.count;
            [array addObjectsFromArray:self.zx];
        }
            break;
        default:
            break;
    }
    for (int i=0; i<count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 40+40*i, helperView.frame.size.width, 40);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 40)];
        label.text= [[array objectAtIndex:i] valueForKey:@"dicValue"];
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
    helperView.contentSize = CGSizeMake(0, 40*(count+1));

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden =YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden =NO;
    
}

-(void)get2hangFubFilter{
    NSString *url = GET2HANDFBFILTER_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    
    /*
     buildingInfo	小区名称	String
     pageindex	第几页	String,从0开始
     countperpage	每页条数	String
     district	区域	String
     price	价格	String
     style	户型	String
     square	面积	String
     
     */
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            //            NSMutableArray * array = [NSMutableArray array];
            //            XWJCity *city  = [[XWJCity alloc] init];
            
            NSDictionary *quanbu  = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"dicKey",@"不限",@"dicValue", nil];
            
            
            self.lp  = [NSMutableArray arrayWithArray:[dic objectForKey:@"lp"]];
            self.cx  = [NSMutableArray arrayWithArray:[dic objectForKey:@"cx"]];
            self.md  = [NSMutableArray arrayWithArray:[dic objectForKey:@"md"]];
            self.zx  = [NSMutableArray arrayWithArray:[dic objectForKey:@"zx"]];
//            [self.lp insertObject:quanbu atIndex:0];
            [self.cx insertObject:quanbu atIndex:0];
            [self.md insertObject:quanbu atIndex:0];
            [self.zx insertObject:quanbu atIndex:0];
            
            self.collectionData = [NSMutableArray arrayWithArray:[dic objectForKey:@"md"]];
            self.collectionSelect = [NSMutableArray arrayWithCapacity:self.collectionData.count];
            for (int i= 0; i<self.collectionData.count; i++) {
                [self.collectionSelect addObject:@"0"];
            }
            [self.collectionView reloadData];
            NSLog(@"dic %@",dic);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)LoadImageWith:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController * pick = [[UIImagePickerController alloc]init];
    pick.sourceType=type;
    pick.delegate=self;
    pick.allowsEditing=self;
    [self presentViewController:pick animated:NO completion:nil];
    
}
//代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取图片并编码；
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSUInteger count = self.imageDatas.count;
    
    if (count>6) {
        return;
    }
    UIImageView *imageView = [self.imgScrollView viewWithTag:imgtag+count];
    
    imageView.image = image;
    
    NSData *data = UIImageJPEGRepresentation(imageView.image,0.4);
    
    
    NSString* encodeResult = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    if (encodeResult) {
        
        [self.imageDatas addObject:encodeResult];
    }
    self.imgScrollView.contentSize =CGSizeMake((IMAGE_WIDTH+spacing) * self.imageDatas.count, IMAGE_WIDTH);
    
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
        
        NSUInteger imgCount = self.imageDatas.count;
        if (imgCount+count>6) {
            [ProgressHUD showError:@"最多上传六张图片"];
            return;
        }
        for (NSInteger i=0; i<count; i++) {
            LGPhotoAssets *asset = [assets objectAtIndex:i];
            UIImageView *imageView = [self.imgScrollView viewWithTag:imgtag+i+imgCount];
            imageView.image = asset.compressionImage;
            
            NSData *data = UIImageJPEGRepresentation(imageView.image,0.4);
            
            
            NSString* encodeResult = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            if (encodeResult) {
                
                [self.imageDatas addObject:encodeResult];
            }else{
                [self.imageDatas addObject:data];
                
            }
        }
        
        self.imgScrollView.contentSize =CGSizeMake((IMAGE_WIDTH+spacing) * self.imageDatas.count, IMAGE_WIDTH);
        
    }
    
}

- (IBAction)ad:(id)sender {
    
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

- (IBAction)sure:(UIButton *)sender {
    
//    [ProgressHUD shared].image.image = [UIImage imageNamed:@"AppIcon"];

    [ProgressHUD show:@"正在发布" Interaction:YES];
    NSString *url = GET2HANDFB_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:@"" forKey:@"rentHouse"];
    
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//    formater.dateFormat = @"yyyy-MM-dd hh:mm:ss";
//    formater.timeZone = [NSTimeZone systemTimeZone];
//    NSString *time = [formater stringFromDate:date];
    /*
     
     @property (weak, nonatomic) IBOutlet UITextField *shiTF;
     @property (weak, nonatomic) IBOutlet UITextField *tingTF;
     @property (weak, nonatomic) IBOutlet UITextField *weiTF;
     @property (weak, nonatomic) IBOutlet UITextField *areaTF;
     @property (weak, nonatomic) IBOutlet UITextField *cengTF;
     @property (weak, nonatomic) IBOutlet UITextField *totalFloorTF;
     @property (weak, nonatomic) IBOutlet UILabel *chaoxiangLabel;
     @property (weak, nonatomic) IBOutlet UILabel *zhuangxiuLabel;
     @property (weak, nonatomic) IBOutlet UITextField *phoneTF;
     @property (weak, nonatomic) IBOutlet UITextField *niandaiTF;
     @property (nonatomic) NSArray *collectionData;
     @property NSMutableArray * selectMaidian;
     @property (weak, nonatomic) IBOutlet UITextField *niandaiLabel;
     @property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
     @property (weak, nonatomic) IBOutlet UILabel *xiaoquLabel;
     */
    [dict setValue:[[self.lp objectAtIndex:self.lpIndex] objectForKey:@"dicKey"] forKey:@"buildingInfo"];
//    [dict setValue:@"" forKey:@"area"];
    [dict setValue:self.shiTF.text forKey:@"house_Indoor"];
    [dict setValue:self.tingTF.text forKey:@"house_living"];
    [dict setValue:self.weiTF.text forKey:@"house_Toilet"];
    
    [dict setValue:[NSString stringWithFormat:@"%@",self.areaTF.text]forKey:@"buildingArea"];
    [dict setValue:self.jiage.text forKey:@"rent"];
    [dict setValue:self.cengTF.text  forKey:@"floors"];
    [dict setValue:self.totalFloorTF.text forKey:@"floorCount"];
//
    NSMutableString *md = [NSMutableString string];
    for (int i=0; i<self.collectionSelect.count; i++) {

        if ([[self.collectionSelect objectAtIndex:i] isEqualToString:@"1"]) {
            [md appendFormat:@"%@,",[[self.collectionData objectAtIndex:i] valueForKey:@"dicKey"]];
        }
    }
//    NSMutableString *substr = [NSMutableString stringWithString:@","];
    if (md.length>0) {
        [md deleteCharactersInRange:NSMakeRange([md length]-1, 1)];//
    }
////    NSString * maid = [NSString stringWithFormat:@"%@,"];
    [dict setValue:md forKey:@"maidian"];
//    [dict setValue:@"" forKey:@"fangyuanmiaoshu"];
//
    [dict setValue:self.niandaiTF.text forKey:@"niandai"];
    [dict setValue:self.fyMiaoshu.text forKey:@"fangyuanmiaoshu"];
    [dict setValue:[[self.cx objectAtIndex:self.cxIndex] objectForKey:@"dicKey"] forKey:@"orientation"];
    [dict setValue:[[self.zx objectAtIndex:self.zxIndex] objectForKey:@"dicKey"] forKey:@"renovationInfo"];
    [dict setValue:self.phoneTF.text forKey:@"mobilePhone"];
//
    if (self.imageDatas) {
        [dict setObject:self.imageDatas forKey:@"photo"];
    }
    if ([XWJAccount instance].phone) {
        [dict setValue:[XWJAccount instance].phone forKey:@"addPerson"];
    }
    [dict setValue:@"青岛市" forKey:@"city"];
    
    NSString * str = [XWJUtil dataTOjsonString:dict];
    
    
//    NSMutableDictionary *guzhang = [NSMutableDictionary dictionary];
//    [guzhang setObject:str forKey:@"complain"];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:str forKey:@"oldHouse"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (!controlView) {
        controlView        = [[UIControl alloc] initWithFrame:self.view.frame];
        [controlView addTarget:self action:@selector(leaveEditMode) forControlEvents:UIControlEventTouchUpInside];
        controlView.backgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:controlView];
//    self.scrollView.contentOffset = CGPointMake(0, -100);
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
    [self.fyMiaoshu resignFirstResponder];
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
