//
//  OVLocationPickerView.m
//  省市区联动
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import "OVLocationPickerView.h"

#import "OVConfig.h"

@interface OVLocationPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray <OVLocationBaseClass *>*arrayList;

@property (assign, nonatomic) NSInteger pro_index;//当前默认选中省份

@property (assign, nonatomic) NSInteger city_index;

@property (assign, nonatomic) NSInteger area_index;

@property (copy, nonatomic) NSString *provinceStr;

@property (copy, nonatomic) NSString *cityStr;

@property (copy, nonatomic) NSString *areaStr;

@end

@implementation OVLocationPickerView

- (RACSubject *)subject
{
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

- (NSMutableArray<OVLocationBaseClass *> *)arrayList
{
    if (!_arrayList) {
        _arrayList = [[NSMutableArray alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LocationJson" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSArray *temArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic in temArray) {
            OVLocationBaseClass *loc = [OVLocationBaseClass modelObjectWithDictionary:dic];
            [_arrayList addObject:loc];
        }
    }
    return _arrayList;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
    }
    return self;
}

- (void)setLocationModel:(OVLocationModel *)locationModel
{
    _locationModel = locationModel;
    
    if (!locationModel) {
        
        [self selectRow:0 inComponent:0 animated:YES];
        _pro_index = 0;
        [self reloadComponent:1];
        
        [self selectRow:0 inComponent:1 animated:YES];
        _city_index = 0;
        [self reloadComponent:2];
        
        [self selectRow:0 inComponent:2 animated:YES];
        _area_index = 0;
        
        return;
    }
    
    _provinceStr = locationModel.provinceName;
    _cityStr = locationModel.cityName;
    _areaStr = locationModel.areaName;
    
    for (int i = 0; i < self.arrayList.count; i ++) {
        NSString *proStr = self.arrayList[i].name;
        if ([proStr isEqualToString:_provinceStr]) {
            [self selectRow:i inComponent:0 animated:YES];
            _pro_index = i;
            [self reloadComponent:1];
            for (int j = 0; j < self.arrayList[i].city.count; j ++) {
                OVLocationBaseClass *province = self.arrayList[i];
                OVLocationCity *city = province.city[j];
                NSString *cityStr = city.name;
                if ([cityStr isEqualToString:_cityStr]) {
                    [self selectRow:j inComponent:1 animated:YES];
                    _city_index = j;
                    [self reloadComponent:2];
                    for (int k = 0; k < city.area.count; k ++) {
                        NSString *areaStr = city.area[k];
                        if ([areaStr isEqualToString:_areaStr]) {
                            [self selectRow:k inComponent:2 animated:YES];
                            break;
                        }
                    }
                }
            }
        }
    }
}


#pragma mark - UIPickerViewDelegate && UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayList.count;
    } else if (component == 1) {
        return self.arrayList[_pro_index].city.count;
    }
    OVLocationCity *area = self.arrayList[_pro_index].city[_city_index];
    return area.area.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //获取省份
    if (component == 0) {
        OVLocationBaseClass *province = self.arrayList[row];
        return province.name;
    } else if (component == 1) {
        //获取城市
        OVLocationBaseClass *province = self.arrayList[_pro_index];
        OVLocationCity *city = province.city[row];
        return city.name;
    }
    //获取区域
    OVLocationBaseClass *province = self.arrayList[_pro_index];
    OVLocationCity *city = province.city[_city_index];
    NSString *area = city.area[row];
    return area;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //获取省份
    if (component == 0) {
        OVLocationBaseClass *province = self.arrayList[row];
        return [[NSAttributedString alloc] initWithString:province.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0 * DEF_DEVICE]}];
    } else if (component == 1) {
        OVLocationBaseClass *province = self.arrayList[_pro_index];
        OVLocationCity *city = province.city[row];
        return [[NSAttributedString alloc] initWithString:city.name attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:15.0 * DEF_DEVICE]}];
    }
    //获取城市
    OVLocationBaseClass *province = self.arrayList[_pro_index];
    OVLocationCity *city = province.city[_city_index];
    NSString *area = city.area[row];
    return [[NSAttributedString alloc] initWithString:area attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:15.0 * DEF_DEVICE]}];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1.0) {
            singleLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
        }
    }
    /*重新定义row 的UILabel*/
    UILabel *pickerLabel = pickerLabel = [[UILabel alloc] init];
    pickerLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13.0 * DEF_DEVICE];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.backgroundColor = [UIColor clearColor];
    pickerLabel.adjustsFontSizeToFitWidth = YES;
    
    pickerLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
    
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _pro_index = row;
        _city_index = 0;
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    if (component == 1) {
        _city_index = row;
        _area_index = row;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    if (component == 2) {
        _area_index = row;
    }
    
    OVLocationCity *city;
    NSString *stringProvince;
    NSString *stringCity;
    NSString *stringArea;
    
    if (component == 0) {
        OVLocationBaseClass *province = self.arrayList[row];
        stringProvince = province.name;
        city = province.city[0];
        stringCity = city.name;
        stringArea = city.area[0];
    } else if (component == 1) {
        OVLocationBaseClass *selectedProvince = self.arrayList[_pro_index];
        stringProvince = selectedProvince.name;
        OVLocationCity *selectedCity = selectedProvince.city[row];
        stringCity = selectedCity.name;
        stringArea = selectedCity.area[0];
    } else if (component == 2) {
        OVLocationBaseClass *selectedProvince = self.arrayList[_pro_index];
        stringProvince = selectedProvince.name;
        OVLocationCity *selectedCity = selectedProvince.city[_city_index];
        stringCity = selectedCity.name;
        stringArea = selectedCity.area[row];
    }
    _provinceStr = stringProvince;
    _cityStr = stringCity;
    _areaStr = stringArea;
    
    OVLocationModel *locationModel = [[OVLocationModel alloc] init];
    locationModel.provinceName = _provinceStr;
    locationModel.cityName = _cityStr;
    locationModel.areaName = _areaStr;
    [self.subject sendNext:locationModel];
}


@end
