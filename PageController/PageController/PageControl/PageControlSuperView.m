//  PageControlSuperView.m
//  PageController
//
//  Created by  on 2022/5/13.
//  Copyright © 2022 pagecontroller. All rights reserved.
//


#import "PageControlSuperView.h"


#define kPageControlUIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]




@interface PageControlSuperView () <UIScrollViewDelegate>


@end

@implementation PageControlSuperView


#pragma mark - init frame
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *> *)titles titleNormalColor:(UIColor *)titleNormalColor titleSelectedColor:(UIColor *)titleSelectedColor titleNormalFontSize:(float)titleNormalFontSize titleSelectedFontSize:(float)titleSelectedFontSize views:(NSArray<UIView *> *)views titleHeight:(float)titleHeight titleTopDis:(float)titleTopDis subViewTopDis:(float)subViewTopDis bottomLineBtnColor:(UIColor *)bottomLineBtnColor bottomLineBtnSize:(CGSize)bottomLineBtnSize topTitleLayoutType:(TopTitleLayoutType)topTitleLayoutType {
    self = [super initWithFrame:frame];
    if (self) {
        
        _topTitleLayoutType = topTitleLayoutType;
        
        _titles = titles;
        _views = views;
        
        _titleNormalColor = titleNormalColor;
        _titleSelectColor = titleSelectedColor;
        
        _titleNormalFontSize = titleNormalFontSize;
        _titleSelectedFontSize = titleSelectedFontSize;
        
        _titleHeight = titleHeight;
        _titleTopDis = titleTopDis;
        
        _subViewTopDis = subViewTopDis;
        
        _bottomLineBtnColor = bottomLineBtnColor;
        _bottomLineBtnSize = bottomLineBtnSize;
        
        
        [self createUIInPageControlView];
        
    
    }
    return self;
}

#pragma mark - create ui page control view
- (void)createUIInPageControlView {
    
    _pageScrollView = [[UIScrollView alloc]init];
    if (@available(iOS 11.0,*)) {
        _pageScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _pageScrollView.bounces = NO;
    _pageScrollView.pagingEnabled = YES;
    _pageScrollView.showsVerticalScrollIndicator = NO;
    _pageScrollView.showsHorizontalScrollIndicator = NO;
    _pageScrollView.delegate = self;
    _pageScrollView.frame = self.bounds;
    [self addSubview:_pageScrollView];
    
    // TODO: top view -- titles
    _topScrollView = [[UIScrollView alloc]init];
    _topScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_topScrollView];
    _topScrollView.frame = CGRectMake(0, _titleTopDis, self.bounds.size.width, _titleHeight);
    
    _bottomLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomLineBtn setBackgroundColor:_bottomLineBtnColor];
    [_topScrollView addSubview:_bottomLineBtn];

    [self createTopTitleBtn];
    
    [self createSubviews];
    
    _pageScrollView.contentSize = CGSizeMake(_pageScrollView.bounds.size.width*_views.count, 0);
    
    
    // set default
    self.selectedIndex = 0;
    
}


// TODO: 创建顶部标题
- (void)createTopTitleBtn {
    
    _topBtnMuArr = [NSMutableArray array];
    float btnLeftDis = 19.0;
    float btnIntervalBtn = 26.0;
    
    for (int i=0 ; i<_titles.count; i++) {
        NSString *btnTitle = [NSString stringWithFormat:@"%@",_titles[i] ];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateHighlighted];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateFocused];
        btn.titleLabel.font = [UIFont systemFontOfSize:_titleNormalFontSize];
        [_topScrollView addSubview:btn];
        
        // 以最大字体 -- 获取当前size
        UIButton *maxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [maxBtn setTitle:btnTitle forState:UIControlStateNormal];
        [maxBtn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        maxBtn.titleLabel.font = [UIFont systemFontOfSize:_titleSelectedFontSize];
        
        [maxBtn.titleLabel sizeToFit];
        
        if (_topTitleLayoutType == topTitleLayoutType_left) {
            // 标题从左边开始布局
            btn.frame = CGRectMake(btnLeftDis, (_titleHeight-maxBtn.titleLabel.frame.size.height)/2.0, maxBtn.titleLabel.frame.size.width, maxBtn.titleLabel.frame.size.height);
            btnLeftDis = btnLeftDis + maxBtn.titleLabel.frame.size.width+btnIntervalBtn;
        }else{
            float eachBtnInterval = (self.bounds.size.width-maxBtn.titleLabel.frame.size.width*3.0)/4.0;
            btn.frame = CGRectMake( eachBtnInterval+(maxBtn.titleLabel.frame.size.width+eachBtnInterval)*i, (_titleHeight-maxBtn.titleLabel.frame.size.height)/2.0, maxBtn.titleLabel.frame.size.width, maxBtn.titleLabel.frame.size.height);
        }
        
        //
        [_topBtnMuArr addObject:btn];
        [btn addTarget:self action:@selector(tapBtnAction:) forControlEvents:UIControlEventTouchDown];
        
    } // for-loop
    
    _topScrollView.contentSize = CGSizeMake(btnLeftDis, 0);
        
    // create bottom line btn
    UIButton *firstBtn = [_topBtnMuArr objectAtIndex:0];

    _bottomLineBtn.frame = CGRectMake( CGRectGetMinX(firstBtn.frame)+(firstBtn.frame.size.width-_bottomLineBtnSize.width)/2.0,CGRectGetMaxY(firstBtn.frame)+5.0, _bottomLineBtnSize.width, _bottomLineBtnSize.height);
    
    
}

// TODO: 创建子视图
- (void)createSubviews {
    
    for (int i=0; i<_views.count; i++) {
        UIView *subView = [_views objectAtIndex:i];
        subView.frame = CGRectMake(_pageScrollView.bounds.size.width*i, _subViewTopDis,_pageScrollView.bounds.size.width, _pageScrollView.bounds.size.height-_subViewTopDis);
        [_pageScrollView addSubview:subView];
        
    }
}


// TODO: 更新btn,bottom line btn
- (void)updateBtnOrBottomLineBtnWithSelectedIndex:(NSInteger)selectedIndex {
    
    UIButton *currentBtn;
    for (int i=0; i<_topBtnMuArr.count; i++) {
        UIButton *btn = [_topBtnMuArr objectAtIndex:i];
        if (i == selectedIndex) {
            btn.userInteractionEnabled = NO;
            btn.multipleTouchEnabled = NO;
            
            btn.selected = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:_titleSelectedFontSize];
            currentBtn = btn;
        }else{
            btn.userInteractionEnabled = YES;
            btn.multipleTouchEnabled = YES;
            btn.selected = NO;
            btn.titleLabel.font = [UIFont systemFontOfSize:_titleNormalFontSize];
            
        }
    }
    
    float topScrollViewOffsetX = currentBtn.frame.origin.x>_topScrollView.bounds.size.width?(currentBtn.frame.origin.x-_topScrollView.bounds.size.width+currentBtn.frame.size.width*2.0):0;
    [UIView animateWithDuration:0.2 animations:^{
        _topScrollView.contentOffset = CGPointMake(topScrollViewOffsetX, 0);
    }];
    
    // bottom line btn
    
    _bottomLineBtn.frame = CGRectMake( CGRectGetMinX(currentBtn.frame)+(currentBtn.frame.size.width-_bottomLineBtnSize.width)/2.0,_bottomLineBtn.frame.origin.y, _bottomLineBtn.frame.size.width, _bottomLineBtn.frame.size.height);
    
    
}

#pragma mark - btn action
- (void)tapBtnAction:(UIButton *)sender {
    NSInteger btnIndex = [_topBtnMuArr indexOfObject:sender];
    
    _pageScrollView.contentOffset = CGPointMake(_pageScrollView.bounds.size.width*btnIndex, 0);
    self.selectedIndex = btnIndex;
    
}

#pragma mark - scroll view delegate
// 拖动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (decelerate == NO) {
        self.selectedIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    }
}
// 滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.selectedIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
}


#pragma mark - setter method
// selected  setter -- 全部通过index进行相应更新
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [self updateBtnOrBottomLineBtnWithSelectedIndex:selectedIndex];
    
    if ( [self.delegate respondsToSelector:@selector(selectedAtIndexDelegate:)] ) {
        [self.delegate selectedAtIndexDelegate:selectedIndex];
    }
    
}

#pragma mark - auto trigger next title--自动切换触发
- (void)setAutoTriggerNextTitleWithNextIndex {
    // judge title end 尾部
    if (self.selectedIndex+1<_topBtnMuArr.count) {
        self.selectedIndex = self.selectedIndex+1;
        _pageScrollView.contentOffset = CGPointMake(_pageScrollView.bounds.size.width*self.selectedIndex, 0);
    }
}



@end
