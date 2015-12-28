//
//  XWJHomeViewController.h
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"
#import "LCBannerView.h"
@interface XWJHomeViewController : XWJBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,LCBannerViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *backScollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *adScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *mesScrollview;

@end
