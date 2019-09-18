//  HeritView.m
//  iOS轮播图-OC
//  Created by GDaYao on 2017/4/28.
//  Copyright © 2017年 GDaYao. All rights reserved.
//
//以scrollView视图为底视图，在加入几个其它继承UIView的视图。

#import "HeritView.h"

#import "FirstView.h"
#import "secondView.h"
#import "thirdView.h"
#import "FourthView.h"



@interface HeritView()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,copy)NSArray *pages;
@property(nonatomic,assign)BOOL pageControlBeUsed;
@property(nonatomic,strong)UIButton *skipBtn;

@property(nonatomic,strong)FirstView *firstView;
@property(nonatomic,strong)secondView *secondView;
@property(nonatomic,strong)thirdView *thirdView;
@property(nonatomic,strong)FourthView *fourthView;
@end

@implementation HeritView
int page=0;

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=[UIColor lightGrayColor];
        [self createSubviews];
        self.pages = @[self.firstView,self.secondView,self.thirdView,self.fourthView];
    }
    return self;
}
#pragma mark - createViews
- (void)createSubviews{
    self.scrollView=[[UIScrollView alloc]init];
    self.scrollView.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.6f];
    self.scrollView.pagingEnabled=YES;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.delegate=self;
    [self addSubview:self.scrollView];
    
    self.firstView=[[FirstView alloc]init];
    [self.scrollView addSubview:self.firstView];
    
    self.secondView=[[secondView alloc]init];
    [self.scrollView addSubview:self.secondView];
    
    self.thirdView=[[thirdView alloc]init];
    [self.scrollView addSubview:self.thirdView];
    
    self.fourthView=[[FourthView alloc]init];
    [self.scrollView addSubview:self.fourthView];
    
    self.pageControl=[[UIPageControl alloc]init];
    self.pageControl.numberOfPages=[[self.scrollView subviews]count];
    self.pageControl.currentPage=0;
    [self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.pageControl];
    
    self.skipBtn=[[UIButton alloc]init];
    [self.skipBtn setTitle:@"Skip" forState:UIControlStateNormal];
    [self.skipBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.skipBtn];
    
//    [self setUpTimer];
}
#pragma mark - layoutViews
- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame=CGRectMake(0.0f,self.bounds.origin.x+50.0f, self.bounds.size.width, self.bounds.size.height-90.0f);
    self.scrollView.contentSize=CGSizeMake(self.bounds.size.width *[self.pages count], self.scrollView.bounds.size.height);
    self.scrollView.contentOffset=CGPointMake(self.bounds.size.width * self.pageControl.currentPage, 0);
    
    self.pageControl.frame=CGRectMake(0.0f, self.bounds.size.height-45.0f, self.bounds.size.width, 30.0f);
    
    self.skipBtn.frame=CGRectMake(self.bounds.size.width-60.0f, 10.0f, 40.0f, 30.0f);
    
    for(NSInteger i=0;i<[self.pages count];i++){
        [[[self.scrollView subviews]objectAtIndex:i] setFrame:CGRectMake(40.0f+(i*self.bounds.size.width), 40.0f, self.bounds.size.width-80, self.scrollView.bounds.size.height-80.0f)];
    }
    
}
#pragma mark - scrollViewAction
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.pageControlBeUsed){
        NSInteger page=self.scrollView.contentOffset.x/self.bounds.size.width;
        self.pageControl.currentPage=page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.pageControlBeUsed=NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pageControlBeUsed=NO;
}

#pragma mark - timer
- (void)setUpTimer{
    self.timer=[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//定时器生效即制定定时器后开始进行相关行为
- (void)timerChange {
    
    page= (page+ 1) % 3;//一直轮播
    
    [self pageChanged:page];
}

-(void)pageChanged:(double )page{
    CGFloat x = page * self.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)nextPage{
    if (self.delegate) {
        [self.delegate firstVCNextPage];
    }
}

@end
