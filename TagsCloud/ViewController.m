//
//  ViewController.m
//  TagsCloud
//
//  Created by mac on 15/2/11.
//  Copyright (c) 2015年 WangWei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSArray* _tags;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _tags = @[@"当幸福来敲门", @"海滩", @"如此的夜晚", @"大进军", @"险地", @"姻缘订三生", @"死亡城", @"苦海孤雏", @"老人与海", @"烽火异乡情", @"父亲离家时", @"无情大地补情天", @"以眼还眼", @"锦绣人生", @"修女传", @"第十三号", @"末代启示录", @"西北前线", @"西北区骑警", @"黄金广场大劫案", @"畸恋山庄", @"守夜", @"我们爱黑夜", @"恐怖夜校", @"夏尔洛结婚", @"特别的一夜", @"下一站格林威治村", @"升职记", @"恶夜之吻", @"木匠兄妹故事"];
    [self.tagsCloudView setTags:_tags
                   andTagColors:@[[UIColor colorWithRed:0 green:0.63 blue:0.8 alpha:1],
                                  [UIColor colorWithRed:1 green:0.2 blue:0.31 alpha:1],
                                  [UIColor colorWithRed:0.53 green:0.78 blue:0 alpha:1],
                                  [UIColor colorWithRed:1 green:0.55 blue:0 alpha:1]]
                       andFonts:@[[UIFont systemFontOfSize:12],
                                  [UIFont systemFontOfSize:16],
                                  [UIFont systemFontOfSize:20]]
                andParallaxRate:1.7
                   andNumOfLine:3];
    self.tagsCloudView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadBtnClick:(UIButton *)sender
{
    [self.tagsCloudView reloadAllTags];
}

#pragma WWTagsCloudViewDelegate
- (void)tagClickAtIndex:(NSInteger)tagIndex
{
    NSLog(@"%@ be clicked.", _tags[tagIndex]);
}
@end
