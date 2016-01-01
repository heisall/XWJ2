//
//  XWJGuzhangViewController.m
//  XWJ
//
//  Created by Sun on 15/12/12.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJGuzhangViewController.h"
#import "XWJGZmiaoshuViewController.h"
#import "RatingBar/RatingBar.h"
#import "XWJGZTableViewCell.h"
#import "XWJAccount.h"
#import "XWJGZaddViewController.h"
#import "XWJGZJudgeViewController.h"
#define TAG 100
@interface XWJGuzhangViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *guzhangArr;
@end

@implementation XWJGuzhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"gztablecell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (self.type == 1) {
        self.navigationItem.title = @"故障报修";
    }else{
        self.navigationItem.title = @"物业投诉";
    }
    self.guzhangArr = [NSMutableArray array];
//    [self getGuzhang];
    [self setNavRightItem];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getGuzhang];

    self.tabBarController.tabBar.hidden =YES;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden =NO;
    
}
-(void)setNavRightItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    
    if (self.type == 1) {
        [btn setTitle:@"报修" forState:UIControlStateNormal];
    }else
        [btn setTitle:@"投诉" forState:UIControlStateNormal];

        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [btn addTarget:self action:@selector(baoxiu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *done= [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = done;
}

-(void)baoxiu{
    
        XWJGuzhangViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"guzhangbaoxiu"];
    view.type = self.type;
    [self.navigationController showViewController:view sender:nil];
}

#pragma mark - Table view data source
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
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.guzhangArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"index path %ld",(long)indexPath.row);
    XWJGZTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XWJGZTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

//    UILabel *label1 = [cell viewWithTag:1];
//    UILabel *label2 = [cell viewWithTag:2];
//    UILabel *label3 = [cell viewWithTag:3];
//    UILabel *label4 = [cell viewWithTag:4];
//    UIView *rate = [cell viewWithTag:5];
//    UIButton *btn  = [cell viewWithTag:6];
    /*
     code = "4-20151220001";
     createtime = "12-20 10:17";
     hfzt = "<null>";
     id = 33;
     leixing = "\U7ef4\U4fee";
     miaoshu = "\U4ed8\U51fa";
     xing = "-1";
     zt = "\U672a\U53d7\U7406";
     */
    cell.timelabel.text = @"提交时间";
    cell.time.text = [NSString stringWithFormat:@"%@",[[self.guzhangArr objectAtIndex:indexPath.row] objectForKey:@"createtime"]];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",[[self.guzhangArr objectAtIndex:indexPath.row] objectForKey:@"miaoshu"]];
    cell.finishLabel.text = [NSString stringWithFormat:@"%@",[[self.guzhangArr objectAtIndex:indexPath.row] objectForKey:@"zt"]];
    cell.pingjiaBtn.tag = TAG + indexPath.row;
    
    
    NSString *xing = [NSString stringWithFormat:@"%@",[[self.guzhangArr objectAtIndex:indexPath.row] objectForKey:@"xing"]];
    
    if ([xing intValue]!=-1) {
        
//        if (!cell.pingjiaBtn.hidden) {
            RatingBar * _bar = [[RatingBar alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width-150, 0, 180, 30)];
            _bar.enable = NO;
            _bar.starNumber = [xing intValue];
            [cell.rateView addSubview:_bar];
            cell.pingjiaBtn.hidden = YES;
//        }
    }else{
        cell.pingjiaBtn.hidden = NO;
        cell.pingjiaBtn.tag = indexPath.row+100;
        [cell.pingjiaBtn addTarget:self action:@selector(pingjia:) forControlEvents:UIControlEventTouchUpInside];
    }
        // Configure the cell...
    
//    label1.text = @"海信湖岛世家";
//    label2.text = @"3室2厅2卫 110平米";
//    label3.text = @"青岛市四方区";
//    label4.text = @"150万元";
    
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    return cell;
}

-(void)pingjia:(UIButton *)btn{
    NSLog(@"btn %ld",(long)btn.tag);
    
    XWJGZJudgeViewController *jubge = [self.storyboard instantiateViewControllerWithIdentifier:@"gzpingjia"];
    jubge.gzid = [[self.guzhangArr objectAtIndex:btn.tag-100] objectForKey:@"id"];
    jubge.miaoshu = [[self.guzhangArr objectAtIndex:btn.tag-100] objectForKey:@"miaoshu"];
    [self.navigationController pushViewController:jubge animated:YES ];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        XWJGZmiaoshuViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"guzhangmiaoxu"];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setValue:@"" forKey:@""];
    detail.detaildic  =  [NSMutableDictionary dictionaryWithDictionary:[self.guzhangArr objectAtIndex:indexPath.row]];
        [self.navigationController showViewController: detail sender:self];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 userid	登录用户id	String
 type	类型（维修、投诉）	String
 */
-(void)getGuzhang{
    NSString *url = GETFGUZHANG_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    XWJAccount *account = [XWJAccount instance];
    [dict setValue:account.uid forKey:@"userid"];
//        [dict setValue:@"1" forKey:@"userid"];

    if (self.type==1) {
 
        [dict setValue:@"维修" forKey:@"type"];
    }else
        [dict setValue:@"投诉" forKey:@"type"];

    [dict setValue:[XWJAccount instance].aid forKey:@"a_id"];

//    [dict setValue:@"1" forKey:@"a_id"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%s success ",__FUNCTION__);
        
        if(responseObject){
            NSDictionary *dic = (NSDictionary *)responseObject;
            
            //            NSMutableArray * array = [NSMutableArray array];
            //            XWJCity *city  = [[XWJCity alloc] init];
            
            NSArray *arr  = [dic objectForKey:@"data"];
            [self.guzhangArr removeAllObjects];
            [self.guzhangArr addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s fail %@",__FUNCTION__,error);
        
    }];
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
