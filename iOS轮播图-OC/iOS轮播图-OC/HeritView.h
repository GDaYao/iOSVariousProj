//
//  HeritView.h
//  iOS轮播图-OC
//
//  Created by GDaYao on 2017/4/28.
//  Copyright © 2017年 GDaYao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FirstVCNextPageDelegate <NSObject>
@required

- (void)firstVCNextPage;

@end

@interface HeritView : UIView
@property(nonatomic,unsafe_unretained)id <FirstVCNextPageDelegate> delegate;

@end
