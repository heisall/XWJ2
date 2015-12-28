//
//  XWJBindHouseTableViewController.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBindHouseTableViewController.h"

@interface XWJBindHouseTableViewController ()
@property (nonatomic)CLLocationManager  *locationManager;
@property (nonatomic)NSString *city;
@end

@implementation XWJBindHouseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    if (mode == HouseCity) {
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.city = @"GPS定位中...";
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:236/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self location];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)location{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}
-(void)reversCode{
//    CLLocation *c = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
//    //创建位置
//    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
//    [revGeo reverseGeocodeLocation:c
//     ￼//反向地理编码
//                 completionHandler:^(NSArray *placemarks, NSError *error) {
//                     if (!error && [placemarks count] > 0)
//                     {
//                         NSDictionary *dict =
//                         [[placemarks objectAtIndex:0] addressDictionary]; NSLog(@"street address: %@",
//                                                                                 //记录地址
//                                                                                 [dict objectForKey:@"Street"]); }
//                     else
//                     {
//                         NSLog(@"ERROR: %@", error); }
//                 }];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_6, __MAC_NA, __IPHONE_2_0, __IPHONE_6_0) __TVOS_PROHIBITED __WATCHOS_PROHIBITED{
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);

    //    CLLocation *newLocation = locations[1];
    //    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
    //    NSLog(@"经度：%f,纬度：%f",newCoordinate.longitude,newCoordinate.latitude);
    
    // 计算两个坐标距离
    //    float distance = [newLocation distanceFromLocation:oldLocation];
    //    NSLog(@"%f",distance);
    
    
    //------------------位置反编码---5.0之后使用-----------------
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       if(placemarks){
                           [self.locationManager stopUpdatingLocation];
                           for (CLPlacemark *place in placemarks) {
                               //                           UILabel *label = (UILabel *)[self.view viewWithTag:101];
                               //                           label.text = place.name;
                               NSLog(@"name,%@",place.locality);                       // 位置名
                               self.city = place.locality;
                               [self.tableView reloadData];
                               //                           NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
                               //                           NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
                               //                           NSLog(@"locality,%@",place.locality);               // 市
                               //                           NSLog(@"subLocality,%@",place.subLocality);         // 区
                               //                           NSLog(@"country,%@",place.country);                 // 国家
                           }
                       }
                       
                   }];
}
/*
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
  
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    //    CLLocation *newLocation = locations[1];
    //    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
    //    NSLog(@"经度：%f,纬度：%f",newCoordinate.longitude,newCoordinate.latitude);
    
    // 计算两个坐标距离
    //    float distance = [newLocation distanceFromLocation:oldLocation];
    //    NSLog(@"%f",distance);
    
//    [manager stopUpdatingLocation];
    
    //------------------位置反编码---5.0之后使用-----------------
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       for (CLPlacemark *place in placemarks) {
//                           UILabel *label = (UILabel *)[self.view viewWithTag:101];
//                           label.text = place.name;
                           NSLog(@"name,%@",place.locality);                       // 位置名
                           //                           NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
                           //                           NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
                           //                           NSLog(@"locality,%@",place.locality);               // 市
                           //                           NSLog(@"subLocality,%@",place.subLocality);         // 区
                           //                           NSLog(@"country,%@",place.country);                 // 国家
                       }
                       
                   }];
}
*/

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (mode == HouseCity) {
        return 2;
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (mode == HouseCity&&section == 0) {
        return 1;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (mode == HouseCity && indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gpsCell"];
        cell.textLabel.text = self.city;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-1, self.view.bounds.size.width,1)];
        view.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
        [cell addSubview:view];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-1, self.view.bounds.size.width,1)];
        footerView.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
        footerView.frame = CGRectMake(0, 0, self.view.bounds.size.width,1);
        [cell addSubview:footerView];
        
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }

        // Configure the cell...
        cell.textLabel.text = self.dataSource[indexPath.row];
        cell.textLabel.textColor =[UIColor colorWithRed:68.0/255.0 green:70.0/255.0 blue:71.0/255.0 alpha:1.0];

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-1, self.view.bounds.size.width,1)];
        view.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
        [cell addSubview:view];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (mode == HouseCity && indexPath.section == 0) {
        [self.dataSource containsObject:self.city];
        NSLog(@"contains");
    }
    [self.delegate didSelectAtIndex:indexPath.row Type:mode];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
