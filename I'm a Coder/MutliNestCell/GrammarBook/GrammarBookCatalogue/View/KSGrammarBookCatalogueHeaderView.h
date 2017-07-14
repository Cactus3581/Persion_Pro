//
//  KSGrammarBookCatalogueHeaderView.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/10.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSGrammarBookCatalogueHeaderView : UITableViewHeaderFooterView
//@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UILabel *chapterName;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineviewTop;

@property (nonatomic,strong) NSString *chapterTitle;
@end
