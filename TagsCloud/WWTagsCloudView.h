//
//  WWTagsCloudView.h
//  TagsCloud
//
//  Created by mac on 14-7-24.
//  Copyright (c) 2014年 WangWei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FLOATVIEWTAG 1000

@interface WWTagsCloudScrollView : UIScrollView
@property (nonatomic) CGFloat parallaxRate;
@end

@protocol WWTagsCloudViewDelegate <NSObject>
@optional
- (void)tagClickAtIndex:(NSInteger)tagIndex;
@end

@interface WWTagsCloudView : UIView
@property (strong, nonatomic) id<WWTagsCloudViewDelegate> delegate;
@property (strong, nonatomic) NSArray* tagArray;

- (id)initWithFrame:(CGRect)frame andTags:(NSArray*)tags andTagColors:(NSArray*)tagColors andFonts:(NSArray*)fonts andParallaxRate:(CGFloat)parallaxRate andNumOfLine:(NSInteger)lineNum;
- (void)setTags:(NSArray*)tags andTagColors:(NSArray*)tagColors andFonts:(NSArray*)fonts andParallaxRate:(CGFloat)parallaxRate andNumOfLine:(NSInteger)lineNum;
- (void)reloadAllTags;
@end
