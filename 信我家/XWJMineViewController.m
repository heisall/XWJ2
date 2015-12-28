//
//  XWJMineViewController.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMineViewController.h"
#import "XWJHeader.h"
#import "XWJMyMessageController.h"
#import "XWJMyHouseController.h"

#define  CELL_HEIGHT 30.0
#define  COLLECTION_NUMSECTIONS 2
#define  COLLECTION_NUMITEMS 4

@implementation XWJMineViewController
static NSString *kcellIdentifier = @"collectionCellID";

-(void)viewDidLoad{

    self.tableData = [NSArray arrayWithObjects:@"关于信我家",@"邀请家人",@"修改密码",@"版本检查",@"修改建议",@"系统设置" ,nil];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    tableViewCellHeight = self.tableview.bounds.size.height/self.tableData.count;

    
    self.collectionData = [NSArray arrayWithObjects:@"我的消息",@"我的发现",@"我的租售",@"我的订单",@"我的保修投诉",@"我的收件地址",@"我的积分",@"我的余额",nil];
    self.collcitonView.dataSource = self;
    self.collcitonView.delegate = self;
    [self.collcitonView registerNib:[UINib nibWithNibName:@"XWJCollectionCell" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier];


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我的";
    self.navigationItem.leftBarButtonItem = nil;

}

- (IBAction)goMyHouse:(id)sender {
    UIViewController *con = [[XWJMyHouseController alloc] init];
    [self.navigationController showViewController:con sender:nil];
}

#pragma mark -CollectionView datasource
//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    collectionCellHeight = self.collcitonView.frame.size.height/COLLECTION_NUMSECTIONS-1;
    collectionCellWidth = self.collcitonView.frame.size.width/COLLECTION_NUMITEMS-1;
    return COLLECTION_NUMSECTIONS;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return COLLECTION_NUMITEMS;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    UICollectionViewCell *cell = [self.collcitonView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    //赋值
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
//    NSString *imageName = [NSString stringWithFormat:@"mor_icon_default"];
    imageView.image = [UIImage imageNamed:@"mor_icon_default"];
    label.textColor = XWJGRAYCOLOR;
    label.text = self.collectionData[indexPath.section*COLLECTION_NUMITEMS+indexPath.row];
    
//    cell.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:70.0/255.0 blue:71.0/255.0 alpha:1.0];
;
    return cell;
    
}
// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//    NSString *reuseIdentifier;
//    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
//        reuseIdentifier = @"footerID";
//    }else{
//        reuseIdentifier = @"headerID";
//    }
//    
//    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
//    
//    UILabel *label = (UILabel *)[view viewWithTag:1];
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
//        label.text = [NSString stringWithFormat:@"这是header:%ld",(long)indexPath.section];
//    }
//    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
//        view.backgroundColor = [UIColor lightGrayColor];
//        label.text = [NSString stringWithFormat:@"这是footer:%ld",(long)indexPath.section];
//    }
//    return view;
//}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionCellWidth, collectionCellHeight);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 0, 0);//分别为上、左、下、右
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
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
    
    UIViewController * con = [[XWJMyMessageController alloc] init];
    [self.navigationController showViewController:con sender:nil];
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor greenColor]];
    
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;

    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    // Configure the cell...
    cell.textLabel.text = self.tableData[indexPath.row];
    cell.textLabel.textColor = XWJGRAYCOLOR;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewCellHeight-1, self.view.bounds.size.width,1)];
    view.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell addSubview:view];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
        [self.navigationController showViewController:[storyboard instantiateViewControllerWithIdentifier:@"suggestStory"] sender:nil];
    }
}

@end
