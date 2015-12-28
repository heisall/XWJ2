//
//  XWJHouseMapController.h
//  XWJ
//
//  Created by Sun on 15/12/18.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBaseViewController.h"
#import <MapKit/MapKit.h>
@interface XWJHouseMapController : XWJBaseViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CGFloat lati;
@property CGFloat lon;
@end
