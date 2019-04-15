//
//  cycleView.m
//  iOS轮播图-OC
//
//  Created by GDaYao on 2017/4/29.
//  Copyright © 2017年 GDaYao. All rights reserved.
//

#import "cycleView.h"

@interface cycleView ()
@property(nonatomic,strong)UIScrollView *scrollView2;
@property(nonatomic,strong)UIPageControl *pageControl2;
@property(nonatomic,assign)NSArray *pages2;
@property(nonatomic,assign)BOOL pageControlBeUsed2;
@property(nonatomic,strong)NSTimer *timer2;



@property(nonatomic,strong)UIImageView *imageView1;
@property(nonatomic,strong)UIImageView *imageView2;
@property(nonatomic,strong)UIImageView *imageView3;
@end

@implementation cycleView
int page2=0;

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        self.pages2=@[self.imageView1,self.imageView2,self.imageView3];
    }
    return self;
}

- (void)createSubViews{
    self.scrollView2=[[UIScrollView alloc]init];
    self.scrollView2.pagingEnabled=YES;
    self.scrollView2.showsHorizontalScrollIndicator=NO;
    [self addSubview:self.scrollView2];
    
    self.pageControl2=[[UIPageControl alloc]init];
    self.pageControl2.numberOfPages=[self.pages2 count];
    self.pageControl2.currentPage=0;
    [self.pageControl2 addTarget:self action:@selector(pageChanged2:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.pageControl2];
    
    self.imageView1=[[UIImageView alloc]init];
    self.imageView1.backgroundColor=[UIColor redColor];
    [self.scrollView2 addSubview:self.imageView1];
   
    self.imageView2=[[UIImageView alloc]init];
    self.imageView2.backgroundColor=[UIColor blueColor];
    [self.scrollView2 addSubview:self.imageView2];
    
    self.imageView3=[[UIImageView alloc]init];
    self.imageView3.backgroundColor=[UIColor blackColor];
    [self.scrollView2 addSubview:self.imageView3];
    
    [self setUpTimer2];
}

- (void)layoutSubviews{
    self.scrollView2.frame=CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    self.scrollView2.contentSize=CGSizeMake(self.scrollView2.bounds.size.width *([self.pages2 count]), self.bounds.size.height);
    self.scrollView2.contentOffset=CGPointMake(self.pageControl2.currentPage*self.scrollView2.bounds.size.width, 0.0f);
    
    self.pageControl2.frame=CGRectMake(self.bounds.origin.x, self.bounds.size.width-40,self.bounds.size.width,30);
    
    for (NSInteger i=0; i<[self.pages2 count]; i++) {
        [[[self.scrollView2 subviews]objectAtIndex:i]setFrame:CGRectMake(i*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    }
}

#pragma mark - scrollViewAction
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.pageControlBeUsed2){
        NSInteger page=self.scrollView2.contentOffset.x/self.bounds.size.width;
        self.pageControl2.currentPage=page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.pageControlBeUsed2=NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pageControlBeUsed2=NO;
}

#pragma mark - timer
- (void)setUpTimer2{
    self.timer2=[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerChange2) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer2 forMode:NSRunLoopCommonModes];
}
//定时器生效即制定定时器后开始进行相关行为
- (void)timerChange2 {
    
    page2= (page2+ 1) % 3;//一直轮播
    
    [self pageChanged2:page2];
}

-(void)pageChanged2:(double )page{
    CGFloat x = page * self.bounds.size.width;
    [self.scrollView2 setContentOffset:CGPointMake(x, 0) animated:YES];
}


@end
