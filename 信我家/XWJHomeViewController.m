//
//  XWJHomeViewController.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJHomeViewController.h"
#import "XWJHeader.h"

#define  CELL_HEIGHT 30.0
#define  COLLECTION_NUMSECTIONS 3
#define  COLLECTION_NUMITEMS 4

@implementation XWJHomeViewController
CGFloat collectionCellHeight;
CGFloat collectionCellWidth;
static NSString *kcellIdentifier = @"collectionCellID";

-(void)viewDidLoad{
    
//    [self setNavigationBar2];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"XWJCollectionCell" bundle:nil] forCellWithReuseIdentifier:kcellIdentifier];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar2];
}

-(void)setNavigationBar2{
    self.navigationItem.title = @"XX城";
    UIImage *image = [UIImage imageNamed:@"liebiao"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(showList) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}


#pragma mark -CollectionView datasource
//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    collectionCellHeight = self.collectionView.frame.size.height/COLLECTION_NUMSECTIONS-1;
    collectionCellWidth = self.collectionView.frame.size.width/COLLECTION_NUMITEMS-1;
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
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell =   [[UICollectionViewCell alloc] init];

    }
    
    UIImageView *imageView = [UIImageView alloc];

    [cell.contentView addSubview:<#(nonnull UIView *)#>];
    //赋值
//    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
//    UILabel *label = (UILabel *)[cell viewWithTag:2];
//    //    NSString *imageName = [NSString stringWithFormat:@"mor_icon_default"];
//    imageView.image = [UIImage imageNamed:@"mor_icon_default"];
//    label.textColor = XWJGRAYCOLOR;
//    label.text = self.collectionData[indexPath.section*COLLECTION_NUMITEMS+indexPath.row];
    
    //    cell.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:70.0/255.0 blue:71.0/255.0 alpha:1.0];
    ;
    return cell;
    
}

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
    CGSize size={self.view.bounds.size.width,20};
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
    
//    UIViewController * con = [[XWJMyMessageController alloc] init];
//    [self.navigationController showViewController:con sender:nil];
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor brownColor]];
    
    
}

-(void)showList{
    
}

@end
