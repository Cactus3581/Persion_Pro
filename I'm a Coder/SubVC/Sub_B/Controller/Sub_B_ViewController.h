//
//  Sub_B_ViewController.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/1/12.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "BaseViewController.h"

@protocol Sub_B_ViewControllerDelegate <NSObject>
@optional

-(void) pushViewControllerWithModel;
@end

@interface Sub_B_ViewController : BaseViewController
@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic, weak) id<Sub_B_ViewControllerDelegate> delegate;

@end
