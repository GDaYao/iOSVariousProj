//
//  UIPickerView+CustomPickerView.m


#import "UIPickerView+CustomPickerView.h"

@implementation UIPickerView (CustomPickerView)

#pragma mark - UIPickerView init
+ (UIPickerView *)InitPickerView:(UIColor *)bgColor initWithFrame:(CGRect)frame withDelegateVC:(id)delegegateVC dataSourceVC:(id)dataSourceVC {
    
    UIPickerView *pickerV = [[UIPickerView alloc]initWithFrame:frame];
    pickerV.backgroundColor = [UIColor whiteColor];
    pickerV.delegate = delegegateVC;
    pickerV.dataSource = dataSourceVC;
    return pickerV;
}


#pragma mark - UIPickerView dataSource/delegate
/**
//返回有几列
 - (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{}

//返回指定列的行数
 - (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{}

 //返回指定列，行的高度，就是自定义行的高度
 - (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{}

 //返回指定列的宽度
 - (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{}
 
 //自定义指定列的每行的视图，即指定列的每行的视图行为一致
 - (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{}
 
 //显示的标题
 - (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{}
 
 //显示的标题字体、颜色等属性
 - (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{}
 
 //被选择的行
 - (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{}
 
*/




@end



