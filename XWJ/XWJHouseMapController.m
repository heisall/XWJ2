//
//  XWJHouseMapController.m
//  XWJ
//
//  Created by Sun on 15/12/18.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJHouseMapController.h"

@implementation XWJHouseMapController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //设置MapView的委托为自己
//    [self.mapView setDelegate:self];
    //标注自身位置
    [self.mapView setShowsUserLocation:YES];
    
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.lati longitude:self.lon];
//    CLLocation *loc = [[CLLocation alloc]initWithLatitude:@"36" longitude:@"120"];

    CLLocationCoordinate2D coord = [loc coordinate];
    //创建标题
    NSString *titile = [NSString stringWithFormat:@"%f,%f",coord.latitude,coord.longitude];
//    MyPoint *myPoint = [[MyPoint alloc] initWithCoordinate:coord andTitle:titile];
    //添加标注
//    
//    [self.mapView addAnnotation:<#(nonnull id<MKAnnotation>)#>]
//    [self.mapView addAnnotation:myPoint];
    
    //放大到标注的位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [self.mapView setRegion:region animated:YES];}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, self.lati, self.lon);
    [self.mapView setRegion:region animated:YES];
}

@end
