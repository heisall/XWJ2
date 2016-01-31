//
//  XWJMineViewController.h
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"

@interface XWJMineViewController : XWJBaseViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    CGFloat tableViewCellHeight;
    CGFloat collectionCellHeight;
    CGFloat collectionCellWidth;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UIButton *houseBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collcitonView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UILabel *NickNameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) NSArray *tableData;
@property (nonatomic) NSArray *collectionData;
@end
