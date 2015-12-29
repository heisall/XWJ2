//
//  XWJNoticeViewController.m
//  XWJ
//
//  Created by Sun on 15/12/5.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJNoticeViewController.h"
#import "XWJNotcieTableViewCell.h"
#import "XWJCity.h"
#import "XWJActivityViewController.h"


@interface XWJNoticeViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XWJNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.type isEqualToString:@"0"]) {
        self.navigationItem.title = @"物业通知";
    }else{
        self.navigationItem.title = @"社区活动";
    }
    
    /*
     ClickCount = 34;
     addTime = "2015-12-10";
     content = "http://mp.weixin.qq.com/s?__biz=MzA3MDYyNzMyNg==&mid=402185314&idx=1&sn=62649235951c5f66fe1bafef7f2066ff&scene=0#wechat_redirect";
     description = "\U6d77\U4fe1\U201c\U4fe1\U6211\U5bb6\U201d\U667a\U6167\U793e\U533aAPP\U662f\U6211\U516c\U53f8\U81ea\U5df1\U7814\U53d1\U7684\U4e00\U4e2aAPP\U7ba1\U7406\U8f6f\U4ef6\U3002";
     id = 5;
     isUrl = 1;
     title = "\U6d77\U4fe1\U201c\U4fe1\U6211\U5bb6\U201d\U667a\U6167\U793e\U533aAPP\U5f00\U59cb\U6d4b\U8bd5\U4e86\U3002";
     types = 0;
     */
     XWJCity *city =    [XWJCity instance];
    [city getActive:self.type :^(NSArray *arr) {
        NSLog(@"room  %@",arr);
        
        if (arr) {
            
            NSMutableArray *arr2 = [NSMutableArray array];
            
            for (NSDictionary *dic in arr) {
                
                NSMutableDictionary  *dic2 = [NSMutableDictionary dictionary];
                [dic2 setValue:[dic valueForKey:@"title"] forKey:KEY_AD_TITLE];
                [dic2 setValue:[dic valueForKey:@"addTime"] forKey:KEY_AD_TIME];
                [dic2 setValue:[dic valueForKey:@"description"]==[NSNull null]?@"":[dic valueForKey:@"description"] forKey:KEY_AD_CONTENT];
                
                NSString *count = [NSString stringWithFormat:@"%@",[dic valueForKey:@"ClickCount"]];
                [dic2 setValue: count forKey:KEY_AD_CLICKCOUNT];
                [dic2 setValue:[dic valueForKey:@"content"] forKey:KEY_AD_URL];
                [dic2 setValue:[dic valueForKey:@"id"] forKey:KEY_AD_ID];
                [arr2 addObject:dic2];
            }
            self.array = arr2;
            [self.tableView reloadData];
        }else{
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:nil message:@"暂没有相关内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertview show];
        }
        
//        [self.activityIndicatorView stopAnimating];
        
    }];
//    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
//    [dic setValue:@"重要公告寒流来袭，快把装备上全" forKey:KEY_TITLE];
//    [dic setValue:@"0天前" forKey:KEY_TIME];
//    [dic setValue:@"这几天，全国大面积降温降雪，一片银装素裹，哆嗦嗦，哆嗦嗦，" forKey:KEY_CONTENT];
//    self.array = [NSArray arrayWithObjects:dic,dic,dic,dic,dic,dic,dic, nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 30.0;
//}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"物业员工";
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWJNotcieTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"noticecell"];
    if (!cell) {
        cell = [[XWJNotcieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noticecell"];
    }
    // Configure the cell...
    NSDictionary *dic = (NSDictionary *)self.array[indexPath.row];
    cell.titleLabel.text = [dic valueForKey:KEY_AD_TITLE];
    cell.timeLabel.text = [dic valueForKey:KEY_AD_TIME];
    cell.contentLabel.text = [dic valueForKey:KEY_AD_CONTENT];
//    cell.clickBtn.titleLabel.text = @""
    [cell.clickBtn setTitle:[dic valueForKey:KEY_AD_CLICKCOUNT] forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    [cell.dialBtn setImage:[] forState:<#(UIControlState)#>]
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 69, self.view.bounds.size.width,1)];
    //    view.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
    //    [cell addSubview:view];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FindStoryboard" bundle:nil];
    
    XWJActivityViewController * acti = [storyboard instantiateViewControllerWithIdentifier:@"activityDetail"];
//    acti.actTitle.text = [[self.array objectAtIndex:indexPath.row] valueForKey:KEY_TITLE];
//    acti.time.text = [[self.array objectAtIndex:indexPath.row] valueForKey:KEY_TIME];
//    acti.url = [[self.array objectAtIndex:indexPath.row] valueForKey:KEY_URL];
//    [acti.btn setTitle:[[self.array objectAtIndex:indexPath.row] valueForKey:KEY_CLICKCOUNT] forState:UIControlStateNormal];
    acti.dic = [self.array objectAtIndex:indexPath.row];
    acti.type = self.type;
    [self.navigationController showViewController:acti sender:nil];

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
