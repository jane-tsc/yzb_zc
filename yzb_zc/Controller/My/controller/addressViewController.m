//
//  addressViewController.m
//  YZBao
//
//  Created by 兴手付科技 on 16/6/9.
//  Copyright © 2016年 兴手付科技. All rights reserved.
//

#import "addressViewController.h"
#import "Public.h"
#import "UIView+Extensions.h"
#import "UIBarButtonItem+Extensions.h"
#import "addressViewCell.h"
#import "shenModel.h"

@interface addressViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
    UITableView *_tableView;
    NSInteger selectIndex;
    //        NSMutableArray *shenArray;
    NSMutableArray *shiArray;
    NSMutableArray *quArray;
    UIToolbar *toolbar;
    
    UIView *viewpick;
    UIPickerView *pickerView;
    UILabel *queding;
    UILabel *quxiao;
    
    NSString *stringShen;
    NSString *stringShi;
    NSString *stringQu;
    
    NSMutableDictionary *citydata;
    
    NSInteger rowIndex;
    UIView *view;
    
    int index;
    
//    BOOL flag;
}
@property(nonatomic, strong) UITextField *addressField;
@property(nonatomic,strong) UIButton *QuedButton;//确定修改

@property (nonatomic ,strong) NSMutableArray *shenArray;
@property (nonatomic, retain)NSMutableArray * FirstAray;

@end

@implementation addressViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //修改为导航栏一下开始显示
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///改变状态为白色
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"收件地址";
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64)];
    view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:view];
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getDefaultAddress" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@",[User shareUser].appKey,[User shareUser].authToken] andURL:@"User" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            
            citydata = [object objectForKey:@"data"];
            
            [User shareUser].addressShen        = citydata [@"provinceName"];
            [User shareUser].addressShi         = citydata [@"cityName"];
            [User shareUser].addressQu          = citydata [@"countyName"];
            [User shareUser].addressDetailed    = citydata [@"detailAddress"];
            [User saveUserInfo];
            [self firshreloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"提交失败，请重新提交"];
            return ;
        }
        
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
    
    
    self.shenArray = [[NSMutableArray alloc]init];
    shiArray = [[NSMutableArray alloc]init];
    quArray = [[NSMutableArray alloc]init];
    
    [self setWithTableView];
}
///创建pickerview
- (void)setupPickerView{
    
    viewpick = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height, screen_width, 290)];
    viewpick.backgroundColor =[UIColor whiteColor];
    [view addSubview:viewpick];
    
    UIView *henview1 = [[UIView alloc]init];
    henview1.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
    [viewpick addSubview:henview1];
    [henview1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewpick.left);
        make.top.equalTo(viewpick.top).offset(1);
        make.width.equalTo(screen_width);
        make.height.equalTo(0.5);
    }];
    
    quxiao =[[UILabel alloc]initWithFrame:CGRectMake(20, 0, screen_width / 2, 40)];
    quxiao.text = @"取消";
    quxiao.userInteractionEnabled = YES;
    quxiao.textAlignment = NSTextAlignmentLeft;
    quxiao.font = [UIFont systemFontOfSize:16];
    [viewpick addSubview:quxiao];
    queding =[[UILabel alloc]initWithFrame:CGRectMake(screen_width - screen_width / 2 - 20, 0, screen_width / 2, 40)];
    queding.text = @"确定";
    queding.userInteractionEnabled = YES;
    queding.textAlignment = NSTextAlignmentRight;
    queding.font = [UIFont systemFontOfSize:16];
    [viewpick addSubview:queding];
    pickerView  = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, screen_width, 250)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [viewpick addSubview:pickerView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(quxiaoClick)];
    [quxiao addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(quedingClick)];
    [queding addGestureRecognizer:tap2];
    
    UIView *henview = [[UIView alloc]init];
    henview.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
    [viewpick addSubview:henview];
    [henview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewpick.left);
        make.top.equalTo(pickerView.top).offset(1);
        make.width.equalTo(screen_width);
        make.height.equalTo(0.5);
    }];
    
}
- (void)showPickerView{
    _tableView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        viewpick.frame = CGRectMake(0, screen_height - 290, screen_width, 290);
    }];
}
- (void)classPickerView{
    _tableView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        viewpick.frame = CGRectMake(0, screen_height+50, screen_width, 50);
    }];
}
- (void)quxiaoClick{
    [self classPickerView];
}
- (void)quedingClick{
    [self classPickerView];
}
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //    NSLog(@"--------------:count :%lu---",(unsigned long)self.shenArray.count);
    return self.shenArray.count;
}
#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return screen_width;
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *st  = [[_shenArray objectAtIndex:row ] objectForKey:@"addressName"];
    return st;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    HIDEKEYBOARD;
    
    if (rowIndex == 0) {
        NSString *str = [[self.shenArray objectAtIndex:row] objectForKey:@"addressName"];
        NSString *addressID = [[self.shenArray objectAtIndex:row] objectForKey:@"addressId"];
        [User shareUser].addressShen = str;
        [User shareUser].addressShenID = addressID;
        [User saveUserInfo];
        [self firshreloadData];
        NSLog(@"选中省-----:%@----:%@",[User shareUser].addressShen,[User shareUser].addressShenID);
        
    }
    else if(rowIndex == 1)
    {
        NSString *str = [[self.shenArray objectAtIndex:row] objectForKey:@"addressName"];
        NSString *addressID = [[self.shenArray objectAtIndex:row] objectForKey:@"addressId"];
        [User shareUser].addressShi = str;
        [User shareUser].addressShiID = addressID;
        [User saveUserInfo];
    
        index = 1;
    
        [self firshreloadData];
        NSLog(@"选中市-----:%@----:%@",[User shareUser].addressShi,[User shareUser].addressShiID);
        
    }
    else if (rowIndex == 2)
    {
        NSString *str = [[self.shenArray objectAtIndex:row] objectForKey:@"addressName"];
        NSString *addressID = [[self.shenArray objectAtIndex:row] objectForKey:@"addressId"];
        [User shareUser].addressQu = str;
        [User shareUser].addressQuID = addressID;
        [User saveUserInfo];
        
        index = 2;
        
        [self firshreloadData];
        NSLog(@"选中区／县-----:%@----:%@",[User shareUser].addressQu,[User shareUser].addressQuID);
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barStyle   =UIBarStyleBlackOpaque;
    UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:NacFontsize],NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)firshreloadData{
    [_tableView reloadData];
    [pickerView reloadAllComponents];
}
- (void)setWithTableView{
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.5, screen_width, screen_height - 64 - 120) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];///分割线颜色
    _tableView.separatorInset = UIEdgeInsetsMake(0,27, 0, 27);///设置分割线的左右距离
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;///分割线样式
    _tableView.delegate = self;
    _tableView.tag = 101;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    ///确定按钮
    self.QuedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.QuedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.QuedButton setTitle:@"保存" forState:UIControlStateNormal];
    self.QuedButton.layer.cornerRadius = 15.5;
    [self.QuedButton setBackgroundColor:RGB(251, 140, 142)];
    self.QuedButton.layer.shadowColor =RGB(252, 174, 176).CGColor;
    self.QuedButton.layer.shadowOpacity = 0.5;
    self.QuedButton.layer.shadowOffset = CGSizeMake(1, 6);
    self.QuedButton.titleLabel.font = [UIFont systemFontOfSize:screen_width / 22];
    [view addSubview:self.QuedButton];
    [self.QuedButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screen_width / 3.5);
        make.top.equalTo(_tableView.bottom).offset(20);
        make.width.equalTo(screen_width / 2.4);
        make.height.equalTo(screen_width / 11);
    }];
    [self.QuedButton addTarget:self action:@selector(querenxiugaiClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *idfriller = @"cell";
    
    addressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idfriller];
    if (!cell) {
        cell = [[addressViewCell alloc]init];
    }
    [cell configWithindexPath:indexPath];
    
    if ([User shareUser].addressShen == nil) {
        cell.shen.text = @"未选择";
    }else{
        cell.shen.text = [User shareUser].addressShen;
    }
    
    
    if ([User shareUser].addressShi == nil) {
        cell.shi.text = @"未选择";
    }else{
        cell.shi.text = [User shareUser].addressShi;
    }
    
    
    if ([User shareUser].addressQu == nil) {
        cell.xian.text = @"未选择";
    }else{
        cell.xian.text = [User shareUser].addressQu;
    }
    
//    if ([User shareUser].addressShen != [User shareUser].addressShen) {
//        cell.shi.text = @"请选择";
//        cell.xian.text = @"请选择";
//    }else if ([User shareUser].addressShi != [User shareUser].addressShi){
//         cell.xian.text = @"请选择";
//    }
 
    if (indexPath.row == 3) {
        
        self.addressField = [[UITextField alloc]initWithFrame:CGRectMake(27, 65, screen_width - 54, 30)];
        NSString *older;
        older =@"点击输入详细地址";
        if ([User shareUser].addressDetailed == nil) {
            self.addressField.text = @"点击输入详细地址";
        }else{
            self.addressField.text =[User shareUser].addressDetailed;
        }
        self.addressField.delegate = self;
        NSMutableAttributedString *placeholer = [[NSMutableAttributedString alloc]initWithString:older];
        [placeholer addAttribute:NSForegroundColorAttributeName
                           value:TEXTcolor
                           range:NSMakeRange(0, older.length)];
        [placeholer addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:screen_width / 24]
                           range:NSMakeRange(0, older.length)];
        self.addressField.attributedPlaceholder = placeholer;
        self.addressField.clearsOnBeginEditing = NO;
        self.addressField.font = [UIFont systemFontOfSize:screen_width / 24];
        self.addressField.textColor = [UIColor grayColor];
//        self.addressField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.addressField.keyboardType = UIKeyboardTypeDefault;
        self.addressField.returnKeyType=UIReturnKeyDefault;
        [cell addSubview:self.addressField];
        
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 110;
    }else{
        return 55;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if (indexPath.row == 0)
    {
        [self configWithHttp:@"1"];
        [self setupPickerView];
        [self showPickerView];
        
        rowIndex = 0;
    }
    else if(indexPath.row == 1)
    {
        [self configWithHttp:[User shareUser].addressShenID];
        [self setupPickerView];
        [self showPickerView];
        
        rowIndex = 1;
    }
    else if (indexPath.row == 2)
    {
        [self configWithHttp:[User shareUser].addressShiID];
        [self setupPickerView];
        [self showPickerView];
        
        rowIndex = 2;
    }
}
///获取用户默认地址
- (void)configWithHttp:(NSString *)strNum{
    
    [[TSCCntc sharedCntc] queryWithPoint:@"getAddressListById" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&addressId=%@",[User shareUser].appKey,[User shareUser].authToken,strNum] andURL:@"Address" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            
            NSDictionary *dic = [object objectForKey:@"data"];
            
            self.shenArray = dic[@"list"];
            
            [self firshreloadData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:object[@"msg"]];
            return ;
        }
        
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}
#pragma mark - 确实修改点击事件
- (void)querenxiugaiClick:(UIButton *)sender{
    
    HIDEKEYBOARD;
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomethingss:) object:sender];
    
    [self performSelector:@selector(todoSomethingss:) withObject:sender afterDelay:0.5f];

}

///防止多次点击
- (void)todoSomethingss:(id)sender{

    if (self.addressField.text.length == 0) {
        [OMGToast showWithText:@"请输入详细地址"];
        return;
    }
    if ([User shareUser].addressShenID == nil) {
        [OMGToast showWithText:@"请选择所在省"];
        return;
    }
    
    if ([User shareUser].addressShiID == nil) {
        [OMGToast showWithText:@"请选择所在市"];
        return;
    }
    
    if ([User shareUser].addressQuID == nil) {
        [OMGToast showWithText:@"请选择所在区／县"];
        return;
    }
    
    [[TSCCntc sharedCntc] queryWithPoint:@"setAddress" andParamsDictionary:[NSString stringWithFormat:@"appKey=%@&authToken=%@&provinceId=%@&cityId=%@&countyId=%@&detailAddress=%@",[User shareUser].appKey,[User shareUser].authToken,[User shareUser].addressShenID,[User shareUser].addressShiID,[User shareUser].addressQuID,self.addressField.text] andURL:@"User" andSuccessCompletioned:^(id object) {
        
        if ([object [@"code"] integerValue] == 200) {
            
            
            [User shareUser].addressDetailed = self.addressField.text;
            [User saveUserInfo];
            
            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"提交成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *Okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([self.addressType isEqualToString:@"10"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            // 添加操作（顺序就是呈现的上下顺序）
            [alertDialog addAction:Okaction];
            // 呈现警告视图
            [self presentViewController:alertDialog animated:YES completion:nil];
            
            [self firshreloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:object [@"msg"]];
            return ;
        }
        
    } andFailed:^(NSString *object) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];

}


//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.addressField resignFirstResponder];
    return YES;
}



@end
