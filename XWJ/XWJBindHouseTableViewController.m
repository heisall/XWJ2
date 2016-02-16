//
//  XWJBindHouseTableViewController.m
//  信我家
//
//  Created by Sun on 15/11/28.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJBindHouseTableViewController.h"
#import "XWJCity.h"
#import "ProgressHUD.h"
@interface XWJBindHouseTableViewController ()
@property (nonatomic)CLLocationManager  *locationManager;
@property (nonatomic)NSString *city;
@property UIActivityIndicatorView *activityIndicatorView;
@end

@implementation XWJBindHouseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    
    XWJCity *city = [XWJCity instance];
    if (mode == HouseCity) {
        
        
        
        [city getCity:^(NSArray *arr) {
            
            CLog(@"arr %@",arr);
            NSMutableArray *arr2 = [NSMutableArray array];
            
            for (NSDictionary *dic in arr) {
                [arr2 addObject:[dic valueForKey:@"CityName"]];
            }
            self.dataSource = arr2;
            [self.tableView reloadData];
            [self.activityIndicatorView stopAnimating];
        }];
        
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.city = @"GPS定位中...";
//       [self.activityIndicatorView stopAnimating];

    }else{
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
//    XWJCity *city = [XWJCity instance];
    switch (mode) {
        case HouseCommunity:
        {
            [city getDistrct:^(NSArray *arr) {
            //CLog(@"district 888888 %@",arr);
                NSMutableArray *arr2 = [NSMutableArray array];
                
                for (NSDictionary *dic in arr) {
                    [arr2 addObject:[dic valueForKey:@"a_name"]];
                }
                self.dataSource = arr2;
                [self.tableView reloadData];

                [self.activityIndicatorView stopAnimating];
            }];
        }
            break;
        case HouseFlour:{
            [city getBuiding:^(NSArray *arr) {
                CLog(@"buiding  %@",arr);
                NSMutableArray *arr2 = [NSMutableArray array];
                
                for (NSDictionary *dic in arr) {
                    [arr2 addObject:[dic valueForKey:@"b_name"]];
                }
                self.dataSource = arr2;
                [self.tableView reloadData];

                [self.activityIndicatorView stopAnimating];
            }];
        }
            break;
        case HouseRoomNumber:
        {
            [city getRoom:^(NSArray *arr) {
                CLog(@"room  %@",arr);
                NSMutableArray *arr2 = [NSMutableArray array];
                
                for (NSDictionary *dic in arr) {
                    [arr2 addObject:[NSString stringWithFormat:@"%@单元%@号",[dic valueForKey:@"R_dy"],[dic valueForKey:@"R_id"]]];
                }
                self.dataSource = arr2;
                [self.tableView reloadData];

                [self.activityIndicatorView stopAnimating];

            }];
        }
            break;
        default:
            break;
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:236/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.navigationController.tabBarController.tabBar.hidden = YES;

    self.activityIndicatorView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.activityIndicatorView.center=self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//    [self.activityIndicatorView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    [self location];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)getCity{
    
    NSString *url = GETCITY_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:username forKey:@"account"];
    //    [dict setValue:pwd forKey:@"password"];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CLog(@"log success ");
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
        }
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLog(@"log fail ");
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //        XWJTabViewController *tab = [[XWJTabViewController alloc] init];
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //        window.rootViewController = tab;            //        });
    }];
}

-(void)getDistrict{
    
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
//                         [[placemarks objectAtIndex:0] addressDictionary]; CLog(@"street address: %@",
//                                                                                 //记录地址
//                                                                                 [dict objectForKey:@"Street"]); }
//                     else
//                     {
//                         CLog(@"ERROR: %@", error); }
//                 }];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_6, __MAC_NA, __IPHONE_2_0, __IPHONE_6_0) __TVOS_PROHIBITED __WATCHOS_PROHIBITED{
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
//    CLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);

    //    CLLocation *newLocation = locations[1];
    //    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
    //    CLog(@"经度：%f,纬度：%f",newCoordinate.longitude,newCoordinate.latitude);
    
    // 计算两个坐标距离
    //    float distance = [newLocation distanceFromLocation:oldLocation];
    //    CLog(@"%f",distance);
    
    
    //------------------位置反编码---5.0之后使用-----------------
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       if(placemarks){
                           [self.locationManager stopUpdatingLocation];
                           for (CLPlacemark *place in placemarks) {
                               //                           UILabel *label = (UILabel *)[self.view viewWithTag:101];
                               //                           label.text = place.name;
//                               CLog(@"name,%@",place.locality);                       // 位置名
                               self.city = place.locality;
                               [self.tableView reloadData];
                               //                           CLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
                               //                           CLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
                               //                           CLog(@"locality,%@",place.locality);               // 市
                               //                           CLog(@"subLocality,%@",place.subLocality);         // 区
                               //                           CLog(@"country,%@",place.country);                 // 国家
                           }
                       }
                       
                   }];
}
/*
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
  
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    CLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    //    CLLocation *newLocation = locations[1];
    //    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
    //    CLog(@"经度：%f,纬度：%f",newCoordinate.longitude,newCoordinate.latitude);
    
    // 计算两个坐标距离
    //    float distance = [newLocation distanceFromLocation:oldLocation];
    //    CLog(@"%f",distance);
    
//    [manager stopUpdatingLocation];
    
    //------------------位置反编码---5.0之后使用-----------------
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       for (CLPlacemark *place in placemarks) {
//                           UILabel *label = (UILabel *)[self.view viewWithTag:101];
//                           label.text = place.name;
                           CLog(@"name,%@",place.locality);                       // 位置名
                           //                           CLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
                           //                           CLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
                           //                           CLog(@"locality,%@",place.locality);               // 市
                           //                           CLog(@"subLocality,%@",place.subLocality);         // 区
                           //                           CLog(@"country,%@",place.country);                 // 国家
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
    if (mode == HouseCity) {
//        [self.dataSource containsObject:self.city];
        CLog(@"contains");
    }
    if (mode == HouseCity&&indexPath.section == 0) {
//        [self.dataSource containsObject:self.city];
        CLog(@"contains");
        NSInteger index =-1;
//        for (int i= 0; i<self.dataSource.count; i++) {
//            if ([self.city isEqualToString:[[self.dataSource objectAtIndex:i] valueForKey:@"CityName"]]) {
//                index  = i;
//                break;
//            }
//        }
        
        if ([self.city isEqualToString:@"GPS定位中..."]) {
            
//            [ProgressHUD showError:@""];
            return;
        }
        if (self.dataSource&&self.dataSource.count>0) {
            
            index = [self.dataSource indexOfObject:self.city];
        }
        
        if (index ==-1||NSNotFound == index) {
            [ProgressHUD showError:@"没有此城市的房源"];
        }else{
            [[XWJCity instance] selectCity:index];
            [self.delegate didSelectAtIndex:index Type:mode];
        }
    
    }else{
    
    switch (mode) {
        case HouseCity:
            [[XWJCity instance] selectCity:indexPath.row];

            break;
         case HouseCommunity:
            [[XWJCity instance] selectDistrict:indexPath.row];
            break;
        case HouseFlour:
            [[XWJCity instance] selectBuilding:indexPath.row];
            break;
        case HouseRoomNumber:
            [[XWJCity instance] selectRoom:indexPath.row];
            break;
        default:
            break;
    }

    
    [self.delegate didSelectAtIndex:indexPath.row Type:mode];
    }
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
