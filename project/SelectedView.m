//
//  SelectedView.m
//  AmflyApp
//
//  Created by pku on 2018/6/4.
//  Copyright © 2018年 pkucollege. All rights reserved.
//

#import "SelectedView.h"
@interface SelectedView()<UIPickerViewDataSource, UIPickerViewDelegate>

{
    int _curYear,_curMouth,_curDay;
    NSInteger _defaultSelectedIndex;
}


@property(nonatomic,strong) NSMutableArray *yearArr;
@property(nonatomic,strong) NSMutableArray *mouthArr;
@property(nonatomic,strong) NSMutableArray *dayArr;
@property(nonatomic,strong) NSMutableArray *hourArr;

@property(nonatomic,strong) NSMutableDictionary *curSelectedDict;


@end

@implementation SelectedView


- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableArray *)yearArr {
    if (_yearArr == nil) {
        
        _yearArr = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 1900; i <= 2050; i++) {
            NSString *year = [NSString stringWithFormat:@"%d",i];
            [_yearArr addObject:year];
        }
     }
    return _yearArr;
}

- (NSMutableArray *)mouthArr {
    if (_mouthArr == nil) {
        
        _mouthArr = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 1; i <= 12; i++) {
            NSString *year = [NSString stringWithFormat:@"%d",i];
            [_mouthArr addObject:year];
        }
    }
    return _mouthArr;
}

- (NSMutableArray *)dayArr {
//    if (_dayArr == nil) {
    
    
    _dayArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    int number = 28;
    
    if (_curMouth == 1 || _curMouth == 3 || _curMouth == 5|| _curMouth == 7|| _curMouth == 8|| _curMouth == 10|| _curMouth == 12) {
        number = 31;
    }else if (_curMouth == 4 || _curMouth == 6 || _curMouth == 9|| _curMouth == 11){
        number = 30;
    }else{
        if (_curYear%4 == 0 && _curYear != 0) {
            number = 29;
        }
    }
    
    
    for (int i = 1; i <= number; i++) {
        NSString *year = [NSString stringWithFormat:@"%d",i];
        [_dayArr addObject:year];
    }
    
//    }
    return _dayArr;
}

- (NSMutableArray *)hourArr {
    
        if (_hourArr == nil) {
            _hourArr = [[NSMutableArray alloc] initWithCapacity:0];
            
            int number = 24;
            for (int i = 1; i <= number; i++) {
                NSString *year = [NSString stringWithFormat:@"%02d:00",i];
                [_hourArr addObject:year];
            }
    
        }
    return _hourArr;
}




- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self creatSubviews];
    }
    return self;
}

- (void)creatSubviews {
    
    self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee" alpha:1];
    
    [self addSubview:self.titileL];
    [self addSubview:self.sureBtn];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.pickerView];
    
    [self masonarySubviews];
    
    
}

- (void)masonarySubviews {
    DCWeakSelf(self);
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakself).offset(10);
        make.height.equalTo(@30);
        make.left.equalTo(weakself).offset(10);
        make.width.equalTo(@40);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakself).offset(10);
        make.height.equalTo(@30);
        make.right.equalTo(weakself).offset(-10);
        make.width.equalTo(@40);
    }];
    
    [self.titileL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakself).offset(10);
        make.height.equalTo(@30);
        make.left.equalTo(weakself.cancelBtn.mas_right).offset(-10);
        make.right.equalTo(weakself.sureBtn.mas_left).offset(-10);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakself.cancelBtn.mas_bottom).offset(10);
        make.bottom.equalTo(weakself).offset(-0);
        make.left.equalTo(weakself).offset(0);
        make.right.equalTo(weakself).offset(-0);
    }];
    
    
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.contentView).offset(0);
        make.bottom.equalTo(weakself.contentView).offset(-0);
        make.left.equalTo(weakself.contentView).offset(0);
        make.right.equalTo(weakself.contentView).offset(-0);
    }];
}


#pragma ----actions ------
- (void)cancelClick {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    } completion:^(BOOL finished) {
        [self.alertView dissMissAlert];
    }];
}

- (void)sureClick {
    
    NSInteger count = self.curSelectedDict.allKeys.count;
    if (self.sureBlock && self.curSelectedDict ) {
        
        if (count > 0) {
            self.sureBlock(_curSelectedDict);
        }else{
            
            switch (_selectType) {
                case SelectedViewTypeNone:
                case SelectedViewTypeBirth:
                case SelectedViewTypeDate:
                case SelectedViewTypeHoliday:
                case SelectedViewTypeYearOnly:
                case SelectedViewTypeMonthOnly:
                    break;
                    
                    
                case SelectedViewTypeWeight:
                case SelectedViewTypeHeight:
                {
                    self.sureBlock(self.dataArr[_defaultSelectedIndex]);
                }
                    break;
                    
                default:
                    self.sureBlock(self.dataArr[0]);
                    break;
            }
        }
        
    }
    
  
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    } completion:^(BOOL finished) {
        [self.alertView dissMissAlert];
    }];
}



// 设置 view 类型
- (void)setSelectType:(SelectedViewType)selectType {
    
    _curSelectedDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    _selectType = selectType;
    
    switch (selectType) {
        case SelectedViewTypeNone:
        {
            _titileL.text = @"测试专用：";
            NSArray *arr = @[@"测试1",@"测试2"];
            for (int i =0; i < arr.count; i ++) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
                [dict setObject:arr[i] forKey:@"TITLE"];
                [dict setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"CONTENT"];
                [self.dataArr addObject:dict];
            }
            
        }
            break;
            
        case SelectedViewTypeSex:
        {
            _titileL.text = @"请选择性别：";
            
            NSArray *titleArr = @[@"男",@"女"];
            NSArray *contentArr = @[@"1",@"2"];
            for (int i =0; i < titleArr.count; i ++) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
                [dict setObject:titleArr[i] forKey:@"TITLE"];
                [dict setObject:contentArr[i] forKey:@"CONTENT"];
                [self.dataArr addObject:dict];
            }
            //            [self.dataArr addObjectsFromArray:arr];
        }
            break;
            
        case SelectedViewTypeBirth:
        {
            _titileL.text = @"请选择出生年月：";
            
            [self.dataArr addObject:self.yearArr];
            [self.dataArr addObject:self.mouthArr];
            [self.dataArr addObject:self.dayArr];
            
            NSInteger index = [self.yearArr indexOfObject:@"2011"];
            [_pickerView selectRow:index inComponent:0 animated:YES];
            [_pickerView selectRow:7 inComponent:1 animated:YES];
            
        }
            break;
            
            case SelectedViewTypeDate:
        {
            _titileL.text = @"请选择日期：";
            
            [self.dataArr addObject:self.yearArr];
            [self.dataArr addObject:self.mouthArr];
            [self.dataArr addObject:self.dayArr];
            
            NSDate  *currentDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
            
            NSInteger sYear = [components year];
            NSInteger sMonth = [components month];
            NSInteger sDay = [components day];
            
            NSString *yearStr = [NSString stringWithFormat:@"%d",sYear];
            NSInteger index = [self.yearArr indexOfObject:yearStr];
//            [_pickerView selectRow:index inComponent:0 animated:YES];
//            [_pickerView selectRow:2 inComponent:1 animated:YES];
            
            [_pickerView selectRow:index inComponent:0 animated:YES];
            [_pickerView selectRow:sMonth-1 inComponent:1 animated:YES];
            [_pickerView selectRow:sDay-1 inComponent:2 animated:YES];
            
        }
            break;
            
        case SelectedViewTypeYearOnly:
        {
            _titileL.text = @"请选择年份：";
            
            [self.dataArr addObjectsFromArray:self.yearArr];
            
            NSDate  *currentDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
            
            NSInteger sYear = [components year];
//            NSInteger sMonth = [components month];
//            NSInteger sDay = [components day];
            
            NSString *yearStr = [NSString stringWithFormat:@"%ld",(long)sYear];
            NSInteger index = [self.yearArr indexOfObject:yearStr];
            
//            NSInteger index = [self.dataArr indexOfObject:@"2019"];
            [_pickerView selectRow:index inComponent:0 animated:YES];
            
        }
            break;
            
        case SelectedViewTypeMonthOnly:
        {
            _titileL.text = @"请选择月份：";
            
            [self.dataArr addObjectsFromArray:self.mouthArr];
            
            
            
            NSDate  *currentDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
            
//            NSInteger sYear = [components year];
                        NSInteger sMonth = [components month];
                        NSInteger sDay = [components day];
            
            NSInteger index = [self.dataArr indexOfObject:@"3"];
            [_pickerView selectRow:sMonth-1 inComponent:0 animated:YES];
            
        }
            break;
            
            
        case SelectedViewTypeAdress:
        {
            _titileL.text = @"请选择地区：";
            
            NSArray *arr = @[@"北京",@"天津", @"上海",@"重庆"];
            for (int i =0; i < arr.count; i ++) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
                [dict setObject:arr[i] forKey:@"TITLE"];
                [dict setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"CONTENT"];
                [self.dataArr addObject:dict];
            }
        }
            break;
        case SelectedViewTypeHeight:
        {
            _titileL.text = @"请选择身高：";
    
            for (int i = 50; i <= 170; i ++) {
                NSString *TITLE = [NSString stringWithFormat:@"%dcm",i];
                NSString *CONTENT = [NSString stringWithFormat:@"%d",i];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
                [dict setObject:TITLE forKey:@"TITLE"];
                [dict setObject:CONTENT forKey:@"CONTENT"];
                [self.dataArr addObject:dict];
            }
            
            _defaultSelectedIndex= 50;
            [_pickerView selectRow:_defaultSelectedIndex inComponent:0 animated:YES];
        }
            break;
        case SelectedViewTypeWeight:
        {
            _titileL.text = @"请选择体重：";
            
            for (int i =5; i <= 50; i ++) {
                NSString *TITLE = [NSString stringWithFormat:@"%dkg",i];
                NSString *CONTENT = [NSString stringWithFormat:@"%d",i];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
                [dict setObject:TITLE forKey:@"TITLE"];
                [dict setObject:CONTENT forKey:@"CONTENT"];
                [self.dataArr addObject:dict];
            }
            
            _defaultSelectedIndex= 5;
            [_pickerView selectRow:_defaultSelectedIndex inComponent:0 animated:YES];
        }
            break;
        case SelectedViewTypeRelation:
        {
            _titileL.text = @"请选择与幼儿关系：";
            NSArray *titleArr = @[@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"姥姥",@"姥爷"];
            NSArray *contentArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
            for (int i =0; i < titleArr.count; i ++) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
                [dict setObject:titleArr[i] forKey:@"TITLE"];
                [dict setObject:contentArr[i] forKey:@"CONTENT"];
                [self.dataArr addObject:dict];
            }
            
        }
            break;
            
        case SelectedViewTypeHoliday:
        {
            _titileL.text = @"请选择请假时间：";
            
            [self.dataArr addObject:self.yearArr];
            [self.dataArr addObject:self.mouthArr];
            [self.dataArr addObject:self.dayArr];
            [self.dataArr addObject:self.hourArr];
            
            NSInteger index = [self.yearArr indexOfObject:@"2018"];
            [_pickerView selectRow:index inComponent:0 animated:YES];
            [_pickerView selectRow:7 inComponent:1 animated:YES];
            
        }
            break;
        case SelectedViewTypeHolidayType:
        {
            _titileL.text = @"请选择请假类型：";
            
            NSArray *titleArr = @[@"病假",@"事假"];
            NSArray *contentArr = @[@"3",@"4"];
            for (int i =0; i < titleArr.count; i ++) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
                [dict setObject:titleArr[i] forKey:@"TITLE"];
                [dict setObject:contentArr[i] forKey:@"CONTENT"];
                [self.dataArr addObject:dict];
            }
            
        }
            break;
        case SelectedViewTypeCheckClass:// 考核班级
        {
            _titileL.text = @"请选择考核班级：";
            
        }
            break;
            
            
            
        default:
            break;
    }
    
    [self shows];
}

- (void)shows {
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    self.frame = CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 300);
    [UIView commitAnimations];
    
    [self.alertView addView:self];
    [self.alertView showAlert];
    
    
}



#pragma ---- UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (_selectType) {
        case SelectedViewTypeBirth:
        case SelectedViewTypeDate:
            
        {
            return 3;
        }
            break;
        case SelectedViewTypeHoliday:
        {
            return 4;
        }
            break;
            
        default:
            return 1;
            break;
    }

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (_selectType) {
            
        case SelectedViewTypeHoliday:
        case SelectedViewTypeBirth:
        case SelectedViewTypeDate:
            
        {
            switch (component) {
                case 0:
                {
                    return self.yearArr.count;
                }
                    break;
                case 1:
                {
                    return self.mouthArr.count;
                }
                    break;
                case 2:
                {
                    return self.dayArr.count;
                }
                    break;
                case 3:
                {
                    return self.hourArr.count;
                }
                    break;
                    
                default:
                    return 0;
                    break;
            }
        }
            break;
   
        default:
        {
            return self.dataArr.count;
        }
            break;
            
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
//    CGFloat width = CGRectGetWidth(pickerView.bounds);
//    NSInteger componetNumber = [pickerView numberOfComponents];
    return 90;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return @"哈哈哈";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{

    for(UIView *speartorView in pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];//隐藏分割线
        }
    }

    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        customLabel.font = [UIFont systemFontOfSize:16];
        customLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }

    NSString *content = @"";


    switch (_selectType) {
        case SelectedViewTypeHoliday:
        case SelectedViewTypeBirth:
        case SelectedViewTypeDate:
            
        {
            switch (component) {
                case 0:
                {
                    content = self.yearArr[row];
                }
                    break;
                case 1:
                {
                    content = self.mouthArr[row];
                }
                    break;
                case 2:
                {
                    content = self.dayArr[row];
                }
                    break;
                case 3:
                {
                    content = self.hourArr[row];
                }
                    break;

                default:
                    content = @"";
                    break;
            }

        }
            break;
            case SelectedViewTypeCheckClass:
        {
            NSDictionary *dict = self.dataArr[row];
            content = [NSString stringWithFormat:@"%@",dict[@"checked_name"]];
        }
            break;
        case SelectedViewTypeYearOnly:
        {
            NSString *year = self.dataArr[row];
            content = year;
        }
            break;

        case SelectedViewTypeMonthOnly:
        {
            NSString *month = self.dataArr[row];
            content = month;
        }
            break;
        default:
        {
            NSDictionary *dict = self.dataArr[row];
            content = dict[@"TITLE"];
        }
            break;
    }
    customLabel.text = [NSString stringWithFormat:@"%@",content];
    customLabel.text = content;
    return customLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    switch (_selectType) {
            
        case SelectedViewTypeDate:
        {
            
            NSString *year = [self.yearArr objectAtIndex:[pickerView selectedRowInComponent:0]];
            NSString *mouth = [self.mouthArr objectAtIndex:[pickerView selectedRowInComponent:1]];
            NSString *day = [self.dayArr objectAtIndex:[pickerView selectedRowInComponent:2]];
            
            NSString *date = [NSString stringWithFormat:@"%@-%@-%@",year,mouth,day];
            [_curSelectedDict setObject:date forKey:@"CONTENT"];
            [_curSelectedDict setObject:year forKey:@"YEAR"];
            [_curSelectedDict setObject:mouth forKey:@"MONTH"];
            [_curSelectedDict setObject:day forKey:@"DAY"];
            
            _curYear = [year intValue];
            _curMouth = [mouth intValue];
            _curDay = [day intValue];
            
            [pickerView reloadAllComponents];
        }
            break;
        case SelectedViewTypeBirth:
        {

            NSString *year = [self.yearArr objectAtIndex:[pickerView selectedRowInComponent:0]];
            NSString *mouth = [self.mouthArr objectAtIndex:[pickerView selectedRowInComponent:1]];
            NSString *day = [self.dayArr objectAtIndex:[pickerView selectedRowInComponent:2]];
            
            NSString *date = [NSString stringWithFormat:@"%@-%@-%@",year,mouth,day];
            [_curSelectedDict setObject:date forKey:@"CONTENT"];
            
            _curYear = [year intValue];
            _curMouth = [mouth intValue];
            _curDay = [day intValue];
            
            [pickerView reloadAllComponents];
        }
            break;
            
        case SelectedViewTypeHoliday:
        {
            
            NSString *year = [self.yearArr objectAtIndex:[pickerView selectedRowInComponent:0]];
            NSString *mouth = [self.mouthArr objectAtIndex:[pickerView selectedRowInComponent:1]];
            NSString *day = [self.dayArr objectAtIndex:[pickerView selectedRowInComponent:2]];
            NSString *hour = [self.hourArr objectAtIndex:[pickerView selectedRowInComponent:3]];
            
            NSString *date = [NSString stringWithFormat:@"%@-%@-%@ %@",year,mouth,day,hour];
            [_curSelectedDict setObject:date forKey:@"CONTENT"];
            
            _curYear = [year intValue];
            _curMouth = [mouth intValue];
            _curDay = [day intValue];
            
            [pickerView reloadAllComponents];
        }
            break;

        case SelectedViewTypeYearOnly:
        {
        
            NSString *year = self.dataArr[row];
            [_curSelectedDict setObject:year forKey:@"CONTENT"];
            
        }
            break;
        case SelectedViewTypeMonthOnly:
        {
            
            NSString *year = self.dataArr[row];
            [_curSelectedDict setObject:year forKey:@"CONTENT"];
            
        }
            break;
            
        default:
        {
            _curSelectedDict = self.dataArr[row];
        }
            break;
    }
}





#pragma ----UI 层
- (AlertView *)alertView {
    if (_alertView == nil) {
        _alertView = [[AlertView alloc] initWithFrame:[UIScreen mainScreen].bounds andIsFullScreen:YES];
        [_alertView setCanceledOnTouchOutside:YES];
    }
    return _alertView;
}

- (UIPickerView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    }
    return _pickerView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [UIView new];
        _contentView.userInteractionEnabled = YES;
        
        //        _contentView.layer.cornerRadius = 3;
        //        _contentView.layer.masksToBounds = YES;
        //        _contentView.layer.borderWidth = 3;
        //        _contentView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithHexString:@"#00ff00" alpha:1.0]);
        _contentView.backgroundColor = [UIColor greenColor];
        
    }
    return _contentView;
}

- (UIButton *)cancelBtn{
    
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc]init];
        _cancelBtn.adjustsImageWhenHighlighted = NO;
        _cancelBtn.layer.borderWidth =1;
        _cancelBtn.layer.cornerRadius = 5;
        _cancelBtn.layer.masksToBounds = YES;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.61,0,0,1});
        _cancelBtn.layer.borderColor = color;
        
        
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#990000"] forState:UIControlStateNormal];
        
        //        [_cancelBtn setBackgroundColor:[UIColor redColor]];
        
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _cancelBtn;
    
}

- (UIButton *)sureBtn{
    
    if (_sureBtn == nil) {
        _sureBtn = [[UIButton alloc]init];
        _sureBtn.adjustsImageWhenHighlighted = NO;
        _sureBtn.layer.borderWidth =1;
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.masksToBounds = YES;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0.61,0,0,1});
        _sureBtn.layer.borderColor = color;
        
        
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#990000"] forState:UIControlStateNormal];
        
        //        [_sureBtn setBackgroundColor:[UIColor redColor]];
        
        [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _sureBtn;
    
}

- (UILabel *)titileL {
    if (_titileL == nil) {
        
        _titileL = [UILabel new];
        _titileL.text=@"标题";
        _titileL.textAlignment =NSTextAlignmentCenter;
        _titileL.textColor=[UIColor colorWithHexString:@"#312d49"];
        _titileL.font= [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titileL.backgroundColor=[UIColor clearColor];
    }
    return _titileL;
}



@end
