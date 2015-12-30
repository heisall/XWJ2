//
//  XWJCZViewController.m
//  XWJ
//
//  Created by Sun on 15/12/12.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJCZViewController.h"
#import "LGPhoto.h"
#import "XWJAccount.h"
#import "XWJUtil.h"
#import "ProgressHUD.h"
#define  CELL_HEIGHT 30.0
#define  COLLECTION_NUMSECTIONS 2
#define  COLLECTION_NUMITEMS 5

@interface XWJCZViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,LGPhotoPickerViewControllerDelegate>{
    CGFloat collectionCellHeight;
    CGFloat collectionCellWidth;
    
    UIView *backview;
    UIScrollView *helperView;
}
@property (weak, nonatomic) IBOutlet UITextField *shiTF;
@property (weak, nonatomic) IBOutlet UITextField *tingTF;

@property (weak, nonatomic) IBOutlet UITextField *weiTF;
@property (weak, nonatomic) IBOutlet UITextField *mianjiTF;
@property (weak, nonatomic) IBOutlet UITextField *zujinTF;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *xiaoquLabel;
@property (nonatomic) NSArray *collectionData;
@property (nonatomic) NSArray *tableData;
@property (nonatomic) NSArray *tableHolderData;
@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;
@property NSMutableArray *imageDatas;
@property (nonatomic) NSMutableArray *collectionSelect;

@property NSMutableArray *lp;

@property NSInteger lpIndex;

@end
@implementation XWJCZViewController

#define imgtag 100
#define IMAGECOUNT 6

#define IMAGE_WIDTH 80
#define spacing 5

static NSString *kcellIdentifier = @"collectionCellID";
static NSString *kheaderIdentifier = @"headerIdentifier";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    self.collectionData = [NSArray arrayWithObjects:@"床",@"衣柜",@"空调",@"电视",@"冰箱",@"洗衣机",@"天然气",@"暖气",@"热水器",@"宽带",nil];
    
    self.tableData = [NSArray arrayWithObjects:@"描述",@"联系人",@"手机号", nil];
    _tableHolderData = [NSArray arrayWithObjects:@"小区环境，交通状况等",@"请输入您的姓名",@"请输入您的手机号", nil];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZFCollectionCell" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XWJSupplementaryView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    for (int i = 0; i<IMAGECOUNT; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*(IMAGE_WIDTH+spacing), 0,IMAGE_WIDTH, IMAGE_WIDTH)];
        imgView.tag = imgtag+i;
        [self.imgScrollView addSubview:imgView];
    }
    self.zujinTF.delegate = self;
    [self getZFFubFilter];
    self.navigationItem.title = @"我要出租";
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden =YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden =NO;
    
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
-(void)closeButtonClicked{
    //    UIView *backview=[self.view.window viewWithTag:3333];
    [backview removeFromSuperview];
}

-(void)sortTypeButtonClicked:(UIButton *)button{
    
    [self closeButtonClicked];
    NSInteger index = button.tag - 60001;
    NSLog(@"selcet id %ld",index);
    self.lpIndex = index;
    self.xiaoquLabel.text = [NSString stringWithFormat:@"%@",[[self.lp objectAtIndex:index] objectForKey:@"dicValue"]];

}

-(void)xuanze:(UIButton *)btn{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cztablecell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cztablecell"];
    }
    // Configure the cell...
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.textColor = XWJGREENCOLOR;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITextField * content = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
    content.placeholder = [_tableHolderData objectAtIndex:indexPath.row];
    content.tag = indexPath.row+100;
    content.delegate = self;
    [cell.contentView addSubview:content];
    //    [cell addSubview:view];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        //        reuseIdentifier = kfooterIdentifier;
    }else{
        reuseIdentifier = kheaderIdentifier;
    }
    
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[view viewWithTag:1];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        label.textColor  = XWJGREENCOLOR;
        label.text  = @"配套设施";
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
    
    NSString * key = [NSString stringWithFormat:@"%@",[self.collectionData[indexPath.section*COLLECTION_NUMITEMS+indexPath.row] objectForKey:@"dicValue"]];

    [btn setTitle: key forState:UIControlStateNormal];

    //    cell.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:70.0/255.0 blue:71.0/255.0 alpha:1.0];
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
    if (btn.selected) {
        
        [_collectionSelect setObject:@"1" atIndexedSubscript:indexPath.section*+indexPath.row];
    }else{
        [_collectionSelect setObject:@"0" atIndexedSubscript:indexPath.section*+indexPath.row];
        
    }
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    UIButton *btn = (UIButton *)[cell viewWithTag:1];
//    btn.selected = NO;
//}
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
            UIImageView *imageView = [self.imgScrollView viewWithTag:imgtag+i];
            imageView.image = asset.compressionImage;
            
            NSData *data = UIImageJPEGRepresentation(imageView.image,1.0);
            //            NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSString *rawString=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            NSString* encodeResult = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            if (encodeResult) {
                [self.imageDatas addObject:encodeResult];
            }else
            [self.imageDatas addObject:data];
        }
        
        self.imgScrollView.contentSize =CGSizeMake((IMAGE_WIDTH+spacing) * count, IMAGE_WIDTH);
        
    }
    
}

-(void)getZFFubFilter{
    NSString *url = GETCHUZUFBFILTER_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
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
//            self.cx  = [NSMutableArray arrayWithArray:[dic objectForKey:@"cx"]];
//            self.md  = [NSMutableArray arrayWithArray:[dic objectForKey:@"md"]];
//            self.zx  = [NSMutableArray arrayWithArray:[dic objectForKey:@"zx"]];
//            [self.lp insertObject:quanbu atIndex:0];
//            [self.cx insertObject:quanbu atIndex:0];
//            [self.md insertObject:quanbu atIndex:0];
//            [self.zx insertObject:quanbu atIndex:0];
            
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

- (IBAction)addImgae:(UIButton *)sender {
    [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];

}
- (IBAction)xuanxiaoqu:(UIButton *)sender {
    [self showSortView:sender];
}
- (IBAction)sure:(UIButton *)sender {
    [ProgressHUD shared].image.image = [UIImage imageNamed:@"AppIcon"];
    [ProgressHUD show:@"正在发布" Interaction:YES];
    NSString *url = GETCHUZUFB_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"" forKey:@"rentHouse"];
    /*
     private String buildingInfo;
     private String area;
     private String house_Indoor;
     private String house_living;
     private String house_Toilet;
     private Double buildingArea;
     private Double useArea;
     private Double rent;
     private String floors;
     private String floorCount;
     private String supporting;
     
     private String fangyuanmiaoshu;
     private String orientation;
     private String renovationInfo;
     private String description;
     private String payMethod;
     
     private String mobilePhone;
     private String[] photo;
     private String addPerson;
     private Integer clickCount;
     private Date addTime;
     */
    [dict setValue:[NSString stringWithFormat:@"%@",[[self.lp objectAtIndex:self.lpIndex] objectForKey:@"dicKey"]] forKey:@"buildingInfo"];
//    [dict setValue:@"" forKey:@"area"];
    [dict setValue:self.shiTF.text forKey:@"house_Indoor"];
    [dict setValue:self.tingTF.text forKey:@"house_living"];
    [dict setValue:self.weiTF.text forKey:@"house_Toilet"];
    [dict setValue:[NSString stringWithFormat:@"%@",self.mianjiTF.text] forKey:@"buildingArea"];
    [dict setValue:self.zujinTF.text forKey:@"rent"];
////    [dict setValue:@"" forKey:@"supporting"];
//    
    NSMutableString *md = [NSMutableString string];
    for (int i=0; i<self.collectionSelect.count; i++) {
        if ([[self.collectionSelect objectAtIndex:i] isEqualToString:@"1"]) {
            [md appendFormat:@"%@,",[[self.collectionData objectAtIndex:i] valueForKey:@"dicKey"]];
        }
    }
    if (md.length>0) {
        [md deleteCharactersInRange:NSMakeRange([md length]-1, 1)];//
    }
    
    [dict setValue:md forKey:@"supporting"];
    [dict setValue:((UITextField *)[self.tableView viewWithTag:100]).text forKey:@"fangyuanmiaoshu"];
//
//    [dict setValue:[[self.cx objectAtIndex:self.cxIndex] objectForKey:@"dicKey"] forKey:@"orientation"];
//    [dict setValue:[[self.zx objectAtIndex:self.zxIndex] objectForKey:@"dicKey"] forKey:@"renovationInfo"];
    [dict setValue:((UITextField *)[self.tableView viewWithTag:102]).text forKey:@"mobilePhone"];
    if (self.imageDatas) {
        [dict setObject:self.imageDatas forKey:@"photo"];
    }
    NSString *person = ((UITextField *)[self.tableView viewWithTag:101]).text;
    if (person) {
        
        [dict setValue:person  forKey:@"addPerson"];
    }
    
    NSString * str = [XWJUtil dataTOjsonString:dict];

    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:str forKey:@"rentHouse"];
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
