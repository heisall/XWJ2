//
//  XWJPay1TableViewCell.m
//  XWJ
//
//  Created by Sun on 15/12/6.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "XWJPay1TableViewCell.h"
#import "XWJInPay1TableViewCell.h"
@implementation XWJPay1TableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.zhangdanTableView.dataSource = self;
    self.zhangdanTableView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPaylist:(NSArray *)list{
    self.payListArr = list;
    [self.zhangdanTableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count;
    count =  self.payListArr.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWJInPay1TableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"inpay1cell"];
    if (!cell) {
        cell = [[XWJInPay1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inpay1cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [self.payListArr objectAtIndex:indexPath.row];
    cell.payTypeLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"t_item"]];
    cell.payPriceLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"t_money"]];
    
////    cell.selectionStyle = self.listUnpayBtn.selected?UITableViewCellSelectionStyleDefault: UITableViewCellSelectionStyleNone;
////    cell.selectImgView.hidden = !self.listUnpayBtn.selected;
//    /*
//     "a_id" = 1;
//     "b_id" = 4;
//     "r_dy" = 2;
//     "r_id" = 1101;
//     "t_date" = 201507;
//     "t_item" = "\U4f4f\U5b85\U7269\U4e1a\U670d\U52a1\U8d39";
//     "t_lastdate" = "2015-07-01";
//     "t_money" = "256.6";
//     "t_sign" = 1;
//     "t_thisdate" = "2015-07-31";
//     */
//    cell.label1.text = [NSString stringWithFormat:@"%@",[[self.payListArr objectAtIndex:indexPath.row*payNum] valueForKey:@"t_date"]];
//    cell.label2.text = [NSString stringWithFormat:@"%@",[[self.payListArr objectAtIndex:indexPath.row*payNum] valueForKey:@"t_item"]];
//    cell.label3.text = [NSString stringWithFormat:@"%@",[[self.payListArr objectAtIndex:indexPath.row*payNum] valueForKey:@"t_money"]];
//    
//    
////    NSUInteger payType1Count = indexPath.row*payNum+1;
//    //    NSUInteger payType2Count = indexPath.row*payNum+2;
//    
//    if (payType1Count>=self.payListArr.count) {
//        cell.label4.text = @"";
//        cell.label5.text = @"";
//        return cell;
//    }
//    cell.label4.text = [NSString stringWithFormat:@"%@",[[self.payListArr objectAtIndex:payType1Count] valueForKey:@"t_item"]];
//    cell.label5.text = [NSString stringWithFormat:@"%@",[[self.payListArr objectAtIndex:payType1Count] valueForKey:@"t_money"]];
    
    
    return cell;
}


@end
