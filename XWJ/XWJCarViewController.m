//
//  XWJCarViewController.m
//  XWJ
//
//  Created by Sun on 15/12/27.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJCarViewController.h"
#import "XWJAccount.h"
#import "XWJUtil.h"
#import "XWJGouWucheTableViewCell.h"
#import "XWJJiesuanViewController.h"
#import "ProgressHUD.h"
@interface XWJCarViewController ()<UITableViewDataSource,UITableViewDelegate>
@property NSMutableArray *carListArr;
@property NSMutableArray *selection;

@end

@implementation XWJCarViewController
@synthesize tableView,numLabel,priceLabel,carListArr,selection;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = YES;

    self.navigationItem.title = @"购物车";
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerNib:[UINib nibWithNibName:@"XWJGouwucheCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    carListArr = [NSMutableArray array];
    selection = [NSMutableArray array];

    NSMutableDictionary *dic  = [NSMutableDictionary dictionary];
    NSMutableDictionary *d1  = [NSMutableDictionary dictionary];
    NSMutableDictionary *d2  = [NSMutableDictionary dictionary];


    [d1 setValue:@"崂山大桶水" forKey:@"goods_name"];
    [d1 setValue:@"30.00" forKey:@"price"];
    [d1 setValue:@"http://www.hisenseplus.com/ecmall/data/files/store_2/goods_193/small_201512191446342877.jpg" forKey:@"goods_image"];
    [d1 setValue:@"1" forKey:@"quantity"];

    [d2 setValue:@"崂山大桶水" forKey:@"goods_name"];
    [d2 setValue:@"30.00" forKey:@"price"];
    [d2 setValue:@"http://www.hisenseplus.com/ecmall/data/files/store_2/goods_193/small_201512191446342877.jpg" forKey:@"goods_image"];
    [d2 setValue:@"1" forKey:@"quantity"];

    NSMutableArray *arr = [NSMutableArray arrayWithObjects:d1,d2, nil];
    [dic setValue:@"农夫山泉矿泉水" forKey:@"type"];
    [dic setObject:arr forKey:@"data"];
    
    
    NSMutableDictionary *dic2  = [NSMutableDictionary dictionary];
    NSMutableDictionary *d11  = [NSMutableDictionary dictionary];
    NSMutableDictionary *d22  = [NSMutableDictionary dictionary];
    
    
    [d11 setValue:@"崂山大桶水" forKey:@"goods_name"];
    [d11 setValue:@"30.00" forKey:@"price"];
    [d11 setValue:@"http://www.hisenseplus.com/ecmall/data/files/store_2/goods_193/small_201512191446342877.jpg" forKey:@"goods_image"];
    [d11 setValue:@"1" forKey:@"quantity"];

    [d22 setValue:@"崂山大桶水" forKey:@"goods_name"];
    [d22 setValue:@"30.00" forKey:@"price"];
    [d22 setValue:@"http://www.hisenseplus.com/ecmall/data/files/store_2/goods_193/small_201512191446342877.jpg" forKey:@"goods_image"];
    [d22 setValue:@"1" forKey:@"quantity"];

    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:d11,d22, nil];
    [dic2 setValue:@"农夫山泉矿泉水" forKey:@"type"];
    [dic2 setObject:arr2 forKey:@"data"];
//    [carListArr addObject:dic];
//    [carListArr addObject:dic2];

    [self getCarList];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return carListArr.count;
}
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setTextColor:XWJGREENCOLOR];
    footer.textLabel.font = [UIFont fontWithName:@"Arial" size:14.0];
    footer.backgroundColor =  [UIColor lightGrayColor];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[carListArr objectAtIndex:section] objectForKey:@"type"];
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 30)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, SCREEN_SIZE.width, 20)];
//    label.textColor = XWJGREENCOLOR;
//    label.text  = [[carListArr objectAtIndex:section] objectForKey:@"type"];
//    [view addSubview:label];
//    return view;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *arr = [[self.carListArr objectAtIndex:section] objectForKey:@"data"];
    NSInteger num  = arr.count;
    return num;
}

-(void)tableView:(UITableView *)table commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *arr = [[self.carListArr objectAtIndex:indexPath.section] objectForKey:@"data"];

        [self delCar:[[arr objectAtIndex:indexPath.row] valueForKey: @"rec_id"]];
//        [self addCarDic:[arr objectAtIndex:indexPath.row] :@"0"];
        [arr removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
   [table deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath]                         withRowAnimation:UITableViewRowAnimationFade];

    }
}

-(void)countTotal{
    float total= 0;
    for (NSIndexPath *path in selection) {
        NSDictionary *dic  = [[[carListArr objectAtIndex:path.section] objectForKey:@"data"] objectAtIndex:path.row];
        
        float price  = [[dic valueForKey:@"price"] floatValue];
        float num =  [[dic valueForKey:@"quantity"] floatValue];
        total =  total + price*num;
        
    }
    numLabel.text  = [NSString stringWithFormat:@"%lu",selection.count];
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f",total];
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [selection addObject:indexPath];
//    UITableViewCell *oneCell = [table cellForRowAtIndexPath: indexPath];
//    if (oneCell.accessoryType == UITableViewCellAccessoryNone) {
//        oneCell.accessoryType = UITableViewCellAccessoryCheckmark;
//    } else
//        oneCell.accessoryType = UITableViewCellAccessoryNone;
    [self countTotal];
    NSLog(@"didSelectRowAtIndexPath %@",selection);
}

- (void)tableView:(UITableView *)table didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [selection removeObject:indexPath];
    
//    UITableViewCell *oneCell = [table cellForRowAtIndexPath: indexPath];
//    if (oneCell.accessoryType == UITableViewCellAccessoryNone) {
//        oneCell.accessoryType = UITableViewCellAccessoryCheckmark;
//    } else
//        oneCell.accessoryType = UITableViewCellAccessoryNone;
    NSLog(@"didDeselectRowAtIndexPath %@",selection);
    [self countTotal];
}


- (UITableViewCell *)tableView:(UITableView *)taView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"index path %ld",(long)indexPath.row);
    XWJGouWucheTableViewCell *cell;
    
    cell = [taView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XWJGouWucheTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    NSArray *arr = [[self.carListArr objectAtIndex:indexPath.section] objectForKey:@"data"];
    
    if(arr&&arr.count>0){
        cell.title.text =     [[arr objectAtIndex:indexPath.row] objectForKey:@"goods_name"];
        cell.price.text = [NSString stringWithFormat:@"%.2f",[[[arr objectAtIndex:indexPath.row] objectForKey:@"price"]floatValue]];

        if ([[arr objectAtIndex:indexPath.row] objectForKey:@"goods_image"]!=[NSNull null]) {

            [cell.imaView sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] objectForKey:@"goods_image"]] ];
        }
        cell.numLabel.text = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] objectForKey:@"quantity"]];
        cell.numLabel.tag = 100;
        cell.jiaBtn.tag = 10000*indexPath.section+indexPath.row;
        [cell.jiaBtn addTarget:self action:@selector(addCar:) forControlEvents:UIControlEventTouchUpInside];
        cell.jianBtn.tag = 10000*indexPath.section+indexPath.row;
        [cell.jianBtn addTarget:self action:@selector(minusCar:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    cell.imageView.image = [UIImage imageNamed:@"agree2"];
    cell.imageView.highlightedImage = [UIImage imageNamed:@"agree1"];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

-(void)addCarDic:(NSDictionary *)dic :(NSString *)count{
    NSString *url = ADDCAR_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    [dict setValue:[NSString stringWithFormat:@"%@",[dic objectForKey:@"store_id"]] forKey:@"storeId"];
    [dict setValue:[NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_id"]] forKey:@"goodsId"];
    [dict setValue:count forKey:@"counts"];
    [dict setValue:[NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]] forKey:@"unitPrice"];
    NSLog(@"addcar unitPrice %@",dict);
    [dict setValue:@"1" forKey:@"flg"];//0加入购物车 1修改
    
    /*
     {"account":"177777777777","storeId":"4","goodsId":"4","counts":"1","unitPrice":"24","flg":"1"}
     */
    NSString * cart = [XWJUtil dataTOjsonString:dict];
    NSDictionary * carDic = [NSDictionary dictionaryWithObject:cart forKey:@"cart"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:carDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *nu = [dic objectForKey:@"result"];
            
            if ([nu integerValue]== 1) {
                [self countTotal];
//                [ProgressHUD showSuccess:errCode];
            }else{
//                [ProgressHUD showError:errCode];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)addCar:(UIButton *)btn{
//    NSInteger tag = btn.tag;
    NSInteger section = btn.tag/10000;
    NSInteger row = btn.tag%10000;
//    NSLog(@"add car tag %lu",tag);
    UILabel *label = (UILabel *)[btn.superview viewWithTag:100];
    NSInteger count = [label.text integerValue];
    count++;
    label.text = [NSString stringWithFormat:@"%lu",count];
    NSMutableDictionary *dic  = [[[carListArr objectAtIndex:section] objectForKey:@"data"] objectAtIndex:row];
    [dic setValue:label.text forKey:@"quantity"];
    [self addCarDic:dic :label.text];
}

-(void)minusCar:(UIButton *)btn{

    NSInteger section = btn.tag/10000;
    NSInteger row = btn.tag%10000;

    UILabel *label = (UILabel *)[btn.superview viewWithTag:100];
    NSInteger count = [label.text integerValue];
    count--;
    if (count<1) {
        count = 1;
    }
    
    label.text = [NSString stringWithFormat:@"%lu",count];
    NSMutableDictionary *dic  = [[[carListArr objectAtIndex:section] objectForKey:@"data"] objectAtIndex:row];
    [dic setValue:label.text forKey:@"quantity"];
    [self addCarDic:dic :label.text];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    UIImage *image = [UIImage imageNamed:@"backIcon"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 30);
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.tabBarController.tabBar.hidden = YES;

}

-(void)delCar:(NSString * )rids{
    NSString *url = DELCAR_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    [dict setValue:rids forKey:@"recIds"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager PUT:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *num = [dic objectForKey:@"result"];
            
            if ([num intValue]== 1) {
                [ProgressHUD showError:@"删除成功！"];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}

-(void)getCarList{

        NSString *url = GETCARLIST_URL;
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
                    
//                    NSMutableArray *typeAr = [NSMutableArray array];
//                    [typeAr addObject:store_name];
                    NSMutableDictionary *snameDic = [NSMutableDictionary dictionary];
                    for (NSMutableDictionary *d in arr) {
                        [snameDic setObject:[d objectForKey:@"store_name"] forKey:[d objectForKey:@"store_name"]];
                    }

//                    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:d11,d22, nil];
//                    [dic2 setValue:@"农夫山泉矿泉水" forKey:@"type"];
//                    [dic2 setObject:arr2 forKey:@"data"];
                    
                    NSArray *key = [snameDic allKeys];
                    for (NSString *name in key) {
                        NSPredicate *predicate =
                        [NSPredicate predicateWithFormat:@"store_name = %@", name];
                        NSMutableArray *a1 =   [NSMutableArray arrayWithArray:[arr  filteredArrayUsingPredicate:predicate]];
                        NSLog(@"a1 %@",a1);
                        
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        [dic setObject:a1 forKey:@"data"];
                        [dic setValue:name forKey:@"type"];
                        [carListArr addObject:dic];
                    }
                    
                    [tableView reloadData];
                    
                    if (self.carListArr.count>0) {
                        NSMutableArray *arr0 = [[self.carListArr objectAtIndex:0] objectForKey:@"data"];
                        for (int i=0; i<arr0.count; i++) {
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
                            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
                        }
                    }
//                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

//                    for (NSDictionary *d in arr) {
//                        NSDictionary
//                    }
                    
//                    [carListArr addObject:@""];
                }
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%s fail %@",__FUNCTION__,error);
            
        }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;

}

-(void)edit{
    [tableView setEditing:!tableView.editing animated:YES];
    if (tableView.editing) {
        if (self.carListArr.count>0) {
            NSMutableArray *arr0 = [self.carListArr objectAtIndex:0] ;
            for (int i=0; i<arr0.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                //            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
                [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
            }
        }
    }
    
    [selection removeAllObjects];
//    [self tableView:tableView didDeselectRowAtIndexPath:[tableView indexPathForSelectedRow]];
//    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [self countTotal];
}

- (IBAction)jiesuan:(UIButton *)sender {
    
    if (selection.count>0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            for (NSIndexPath *index in selection) {
                [dic setObject:[NSString stringWithFormat:@"%lu",index.section] forKey:[NSString stringWithFormat:@"%lu",index.section]];
            }
        
            if (dic.allKeys.count>1) {
                [ProgressHUD showError:@"小二一次暂且处理一个商户，您得分批结算"];
            }else{
                
                NSMutableArray *arr = [NSMutableArray array];
                NSString *sid;
                for (NSIndexPath *indes in selection) {
                    
                    NSDictionary *dic  = [[[carListArr objectAtIndex:indes.section] objectForKey:@"data"] objectAtIndex:indes.row];
                    sid = [dic valueForKey:@"store_id"];
                    NSDictionary *d = [NSDictionary dictionaryWithDictionary:dic];
                    [arr addObject:d];
                }
                [self addOrder:sid];
                XWJJiesuanViewController *con = [self.storyboard instantiateViewControllerWithIdentifier:@"jiesuanview"];
                con.price = priceLabel.text;
                con.arr = arr;
                [self.navigationController showViewController:con sender:nil];
            }
        
    }
    
}

-(void)addOrder:(NSString *)storeid{
    NSString *url = ADDORDER_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    [dict setValue:@"1" forKey:@"store_id"];
    [dict setValue:[XWJAccount instance].account  forKey:@"account"];
    [dict setValue:storeid forKey:@"storeId"];

    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSLog(@"dic %@",dic);
            NSString *errCode = [dic objectForKey:@"errorCode"];
            NSNumber *nu = [dic objectForKey:@"result"];
            
            if ([nu integerValue]== 1) {
//                                [ProgressHUD showSuccess:errCode];
            }else{
                //                [ProgressHUD showError:errCode];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
