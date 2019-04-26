//
//  SelectedView.h
//  AmflyApp
//
//  Created by pku on 2018/6/4.
//  Copyright © 2018年 pkucollege. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertView.h"

typedef NS_ENUM(NSInteger, SelectedViewType) {
    SelectedViewTypeNone = 0,             // regular table view
    SelectedViewTypeSex = 1,              // preferences style table view
    SelectedViewTypeBirth,                // year  month day  生日
    SelectedViewTypeDate,                   // year  month day   日期
    SelectedViewTypeYearOnly,
    SelectedViewTypeMonthOnly,
    
    SelectedViewTypeAdress,
    SelectedViewTypeRelation,
    SelectedViewTypeWeight,
    SelectedViewTypeHeight,
    SelectedViewTypeHoliday,              //,请假时间 2018-10-10 9
    SelectedViewTypeHolidayType,          // 请假类型
    SelectedViewTypeCheckClass,           // 考核班级
    SelectedViewTypeCheckKitchen,         // 考核厨房
    SelectedViewTypeCheckPeople           // 考核 人员
};


@interface SelectedView : UIView


@property(nonatomic,strong) AlertView *alertView;

@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *sureBtn;
@property(nonatomic,strong) UILabel *titileL;

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIPickerView *pickerView;

@property(nonatomic,strong) NSMutableArray *dataArr;

@property(nonatomic,assign) SelectedViewType selectType;

@property(nonatomic,copy) GloabelDictBlock sureBlock;

- (void)shows;


@end
