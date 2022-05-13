//  TestSubPageView.m
//  PageController
//
//  Created by  on 2022/5/13.
//  Copyright © 2022 pagecontroller. All rights reserved.
//


#import "TestSubPageView.h"



@implementation TestSubPageView

- (instancetype)initWithFrame:(CGRect)frame selectedIndex:(NSInteger)selectedIndex {
    self = [super initWithFrame:frame];
    if (self) {
        
        if (selectedIndex == 0) {
            self.backgroundColor = [UIColor grayColor];
        }else if(selectedIndex == 1){
            self.backgroundColor = [UIColor blueColor];
        }else if(selectedIndex == 2){
            self.backgroundColor = [UIColor greenColor];
        }
        
        
    }
    return self;
}

@end
