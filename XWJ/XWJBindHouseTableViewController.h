//
//  XWJBindHouseTableViewController.h
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWJBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSUInteger, HouseMode) {
    HouseCity,
    HouseCommunity,
    HouseFlour,
    HouseRoomNumber,
};
@protocol XWJBindHouseDelegate <NSObject>

-(void)didSelectAtIndex:(NSInteger) index Type:(HouseMode)type;

@end

@interface XWJBindHouseTableViewController : XWJBaseViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>{
    @public HouseMode mode;

}
@property (nonatomic, weak) id <XWJBindHouseDelegate> delegate;
@property (strong,nonatomic)NSArray *dataSource;
@property (strong,nonatomic)UITableView * tableView;
@property BOOL isYouke;
@end
