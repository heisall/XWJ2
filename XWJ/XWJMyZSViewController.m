//
//  XWJMyZSViewController.m
//  XWJ
//
//  Created by Sun on 15/12/12.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJMyZSViewController.h"
#import "XWJZFViewController.h"
#import "XWJZFDetailViewController.h"
#import "XWJZFTableViewCell.h"
@interface XWJMyZSViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UIButton *chushouBtn;
@property (weak, nonatomic) IBOutlet UIButton *chuzuBtn;
@property (weak, nonatomic) IBOutlet UITableView *tablView;
@property HOUSETYPE type;
@end

@implementation XWJMyZSViewController
static NSString *cellid = @"zftablecell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tablView.delegate = self;
    self.tablView.dataSource = self;
    _type = HOUSE2;
    [self.tablView registerNib:[UINib nibWithNibName:@"XWJZFTableCell" bundle:nil] forCellReuseIdentifier:cellid];
    _chuzuBtn.selected  = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chuzu:(UIButton *)sender {
    if (!sender.selected) {
        _chushouBtn.selected = sender.selected;
        sender.selected = !sender.selected;
    }

}
- (IBAction)chushou:(UIButton *)sender {
    if (!sender.selected) {
        _chuzuBtn.selected = sender.selected;
        sender.selected = !sender.selected;
    }
}
- (IBAction)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"back");
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
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWJZFTableViewCell *cell;
    
    cell = [self.tablView dequeueReusableCellWithIdentifier:cellid];

    // Configure the cell...
    cell.headImageView.image = [UIImage imageNamed:@"xinfangbackImg"];
    cell.label1.text = @"海信湖岛世家";
    cell.label2.text = @"3室2厅2卫 110平米";
    cell.label3.text = @"青岛市四方区";
    cell.label4.text = @"150万元";
    
    //    [cell.dialBtn setImage:[] forState:<#(UIControlState)#>]
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 69, self.view.bounds.size.width,1)];
    //    view.backgroundColor  = [UIColor colorWithRed:206.0/255.0 green:207.0/255.0 blue:208.0/255.0 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    [cell addSubview:view];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if (self.type == HOUSE2||self.type==HOUSEZU) {
    
    UIStoryboard *zfstory = [UIStoryboard storyboardWithName:@"XWJZFStoryboard" bundle:nil];
    XWJZFDetailViewController *detail = [zfstory instantiateViewControllerWithIdentifier:@"2fdatail"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"" forKey:@""];
    detail.dic = dic;
    detail.type = self.type;
    [self.navigationController showViewController: detail sender:self];
    //    }
    
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
