//
//  XWJAddressController.m
//  XWJ
//
//  Created by Sun on 16/1/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "XWJAddressController.h"
#import "XWJAccount.h"
#import "XWJAddresCell.h"
@interface XWJAddressController()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property NSArray *array;
//@property UITableView *tableView;
@end
@implementation XWJAddressController
@synthesize  tableview;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"收货地址";

}
- (IBAction)add:(id)sender {
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    if (tableView.tag == TAG) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, SCREEN_SIZE.width, 20)];
//        label.textColor = XWJGREENCOLOR;
//        label.text  = @"支付方式";
//        [view addSubview:label];
//        return view;
//    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (tableView.tag == TAG) {
//        return 40.0;
//    }
    return 90.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (tableView.tag == TAG) {
//        return self.payarray.count;
//    }
//    return self.arr.count;
    return self.array.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    /*
     "goods_id" = 14;
     "goods_image" = "http://www.hisenseplus.com/ecmall/data/files/store_7/goods_87/small_201512221541271733.jpg";
     "goods_name" = "\U949f\U7231\U9c9c\U82b1\U901f\U9012 33\U6735\U73ab\U7470\U82b1\U675f \U9c9c\U82b1\U5feb\U9012\U5317\U4eac\U5168\U56fd\U82b1\U5e97\U9001\U82b1 33\U6735\U9999\U69df\U73ab\U7470\U82b1\U675f1";
     price = 2592;
     quantity = 1;
     "rec_id" = 21;
     "spec_id" = 14;
     "store_id" = 7;
     "store_name" = "\U521a\U54e5\U9c9c\U82b1";
     */
    XWJAddresCell  *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"addcell"];
    if (!cell) {
        cell = [[XWJAddresCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addcell"];
    }
    // Configure the cell...
//    NSString *url = [[self.arr objectAtIndex:indexPath.row] objectForKey:@"goods_image"];
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url]];
//    cell.title.text = [[self.arr objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
//    cell.price.text = [NSString stringWithFormat:@"%.1f",[[[self.arr objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]];
//    cell.numLabel.text = [NSString stringWithFormat:@"x%@",[[self.arr objectAtIndex:indexPath.row] objectForKey:@"quantity"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)getAddress{
    
    NSString *url = GETADDRESSLIST_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *num = [dic objectForKey:@"result"];
            /*
             data =     (
             {
             "goods_id" = 3;
             "goods_image" = "http://www.hisenseplus.com/ecmall/data/files/store_4/goods_32/small_201512191643527793.jpg";
             "goods_name" = "\U519c\U592b\U5c71\U6cc9\U5929\U7136\U5927\U6876\U6c341L";
             price = 14;
             quantity = 1;
             "rec_id" = 20;
             "spec_id" = 3;
             "store_id" = 4;
             "store_name" = "\U519c\U592b\U5c71\U6cc9\U77ff\U6cc9\U6c34";
             }
             );
             */
            if ([num intValue]== 1) {
                NSMutableArray * arr = [NSMutableArray array];
                
                for (NSDictionary *d in [dic objectForKey:@"data"]) {
                    [arr addObject:[NSMutableDictionary dictionaryWithDictionary:d]];
                }
                
//                //                    NSMutableArray *typeAr = [NSMutableArray array];
//                //                    [typeAr addObject:store_name];
//                NSMutableDictionary *snameDic = [NSMutableDictionary dictionary];
//                for (NSMutableDictionary *d in arr) {
//                    [snameDic setObject:[d objectForKey:@"store_name"] forKey:[d objectForKey:@"store_name"]];
//                }
//                
//                //                    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:d11,d22, nil];
//                //                    [dic2 setValue:@"农夫山泉矿泉水" forKey:@"type"];
//                //                    [dic2 setObject:arr2 forKey:@"data"];
//                
//                NSArray *key = [snameDic allKeys];
//                for (NSString *name in key) {
//                    NSPredicate *predicate =
//                    [NSPredicate predicateWithFormat:@"store_name = %@", name];
//                    NSMutableArray *a1 =   [NSMutableArray arrayWithArray:[arr  filteredArrayUsingPredicate:predicate]];
//                    NSLog(@"a1 %@",a1);
//                    
//                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                    [dic setObject:a1 forKey:@"data"];
//                    [dic setValue:name forKey:@"type"];
//                    [carListArr addObject:dic];
//                }
                
                [tableview reloadData];

            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
    
}
@end
