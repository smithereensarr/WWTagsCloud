//
//  ViewController.h
//  TagsCloud
//
//  Created by mac on 15/2/11.
//  Copyright (c) 2015年 WangWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWTagsCloudView.h"
@interface ViewController : UIViewController <WWTagsCloudViewDelegate>

@property (weak, nonatomic) IBOutlet WWTagsCloudView *tagsCloudView;
- (IBAction)reloadBtnClick:(UIButton*)sender;

@end

