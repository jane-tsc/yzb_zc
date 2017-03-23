//
//  MessageViewController.m
//  YunZB
//
//  Created by 兴手付科技 on 16/6/5.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#define MARGIN   50

#import "MessageViewController.h"
#import "messageViewCell.h"
#import "messageModel.h"


@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>{
     UITableView *_tableView;
}
@property (nonatomic ,strong) NSMutableArray *dataArray;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(249, 253, 255);
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
//    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"消息";
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    [self setWithTableView];
    
    [self configWithHttp];
}

///获取数据
- (void)configWithHttp{
    
     [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeGradient];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"listMsg" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",[User shareUser].appKey,[User shareUser].authToken] andURL:@"Msg" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            
            NSDictionary *dic = [object objectForKey:@"data"];
            self.dataArray = [messageModel objectArrayWithKeyValuesArray:dic [@"list"]];
            [_tableView reloadData];
            
        }else{
            [SVProgressHUD dismiss];
            [OMGToast showWithText:object[@"msg"]];
        }
        
    } andFailed:^(NSString *object) {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
   
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
}
-(void)viewDidDisappear:(BOOL)animated{
}

- (void)setWithTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = RGB(249, 253, 255);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height + 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idfriller = @"cell";
     messageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfriller];
    if (cell == nil) {
        cell = [[messageViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfriller];
    }
    cell.layer.shadowColor =RGB(249, 253, 255).CGColor;
    cell.layer.shadowOpacity = 0.5;
    cell.layer.shadowOffset = CGSizeMake(1, 6);
    
    messageModel *mess = self.dataArray [indexPath.row];
    ///infor_1_normal@2x.png    infor_2_normal@2x.png    infor_3_normal@2x.png
    if ([mess.msgType intValue]== 10) {
        cell.image.image = [UIImage imageNamed:@"infor_2_normal.png"];
    }else if ([mess.msgType intValue]== 20){
        cell.image.image = [UIImage imageNamed:@"infor_1_normal.png"];
    }else if ([mess.msgType intValue]== 30){
         cell.image.image = [UIImage imageNamed:@"infor_3_normal.png"];
    }
    cell.name.text = mess.msgTitle;
    cell.time.text = mess.msgTime;
    cell.layer.cornerRadius = 3.0;
    cell.layer.masksToBounds = YES;
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 65, screen_width - 30, 30)];
    
    NSString *string=[mess.msgContent stringByReplacingOccurrencesOfString:@"<br>"withString:@"\n"];
    
    lable.text = string;
    lable.textColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.5];
    lable.backgroundColor = [UIColor whiteColor];
    ///自行换行设置
    lable.lineBreakMode = NSLineBreakByWordWrapping;
    lable.numberOfLines = 0;
    lable.font = [UIFont systemFontOfSize:screen_width / 24];
    lable.textAlignment= NSTextAlignmentLeft;
    ///自适应高度
    CGRect Frame = lable.frame;
    lable.frame = CGRectMake(15, 65, screen_width - 30,
                             Frame.size.height =[lable.text boundingRectWithSize:
                                                 CGSizeMake(Frame.size.width, CGFLOAT_MAX)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                      attributes:[NSDictionary dictionaryWithObjectsAndKeys:lable.font,NSFontAttributeName, nil] context:nil].size.height);
    lable.frame = CGRectMake(15, 65, screen_width - 30, Frame.size.height);
    [cell.contentView addSubview:lable];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //获取新的cell的高度
    
    CGRect frame = cell.frame;
    
    frame.size.height = lable.frame.size.height+MARGIN ;
    
    cell.frame = frame;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
@end
