//
//  WWTagsCloudView.m
//  TagsCloud
//
//  Created by mac on 14-7-24.
//  Copyright (c) 2014年 WangWei. All rights reserved.
//

#import "WWTagsCloudView.h"

@implementation WWTagsCloudScrollView
- (void)layoutSubviews
{
    UIView* floatView = [self viewWithTag:FLOATVIEWTAG];
    floatView.frame = CGRectMake(0, 0, self.contentSize.width * _parallaxRate, self.frame.size.height);
    CGRect tempRect = floatView.frame;
    tempRect.origin.x = -self.contentOffset.x * (_parallaxRate - 1);
    floatView.frame = tempRect;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if ([hitView isMemberOfClass:[WWTagsCloudScrollView class]]) {
        for (UIView* subView in [self viewWithTag:FLOATVIEWTAG].subviews) {
            CGPoint subPoint = [self convertPoint:point toView:subView];
            if ([subView hitTest:subPoint withEvent:event]) {
                return subView;
            }
        }
    }
    return hitView;
}
@end



@interface WWTagsCloudView ()
@property (strong, nonatomic) WWTagsCloudScrollView* scrollView;
@property (strong, nonatomic) UIView* floatView;
@property (strong, nonatomic) NSArray* tagColorArray;
@property (strong, nonatomic) NSArray* fontArray;
@property (nonatomic) NSInteger lineNum;
@property (nonatomic) CGFloat parallaxRate;
@end


@implementation WWTagsCloudView
static CGFloat const kMarginWord = 20;//词间距
static CGFloat const kMarginSide = 16;//行左右间距
static CGFloat const kMarginTop = 50;//上间距
static CGFloat const kLineHeight = 50;//行距

- (id)initWithFrame:(CGRect)frame andTags:(NSArray*)tags andTagColors:(NSArray*)tagColors andFonts:(NSArray*)fonts andParallaxRate:(CGFloat)parallaxRate andNumOfLine:(NSInteger)lineNum
{
    //初始化
    self = [super initWithFrame:frame];
    [self setTags:tags andTagColors:tagColors andFonts:fonts andParallaxRate:parallaxRate andNumOfLine:lineNum];
    return self;
}

- (void)layoutSubviews
{
    _scrollView.frame = self.bounds;
    [self reloadAllTags];
}

-(void)reloadAllTags
{
    for (UIView* subView in _scrollView.subviews) {
        if ([subView isMemberOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    for (UIView* subView in _floatView.subviews) {
        if ([subView isMemberOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) * [self createLbInContainer], 0);
}

-(void)tagClickAtIndex:(UITapGestureRecognizer*)gesture
{
    [self.delegate tagClickAtIndex:gesture.view.tag];
}


-(NSInteger)createLbInContainer
{
    //当前页数
    NSInteger currentPageIndex = 0;
    //创建一个序数数组
    NSMutableArray* indexArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _tagArray.count; i++) {
        [indexArray addObject:[NSNumber numberWithInt:i]];
    }

    while (indexArray.count > 0) {//页循环
        for (int i = 0; i < _lineNum; i++) {//行循环
            //每行中的label
            NSMutableArray* tagsOfLine = [[NSMutableArray alloc] init];
            //当前行起始坐标
            CGFloat startXOfLine = kMarginSide + CGRectGetWidth([[UIScreen mainScreen] bounds]) * currentPageIndex;
            //当前tag的X坐标
            CGFloat currentX = startXOfLine;
            //当前label是属于上层还是下层
            BOOL isFloatLabel = arc4random() % 2;
            while (indexArray.count > 0) {//列循环
                NSInteger indexOfIndexArray = arc4random() % indexArray.count;
                //当前取出的标签序号
                NSInteger tagIndex = [indexArray[indexOfIndexArray] intValue];

                UILabel* label = [[UILabel alloc] init];
                label.tag = tagIndex;
                //随机文字
                label.text = _tagArray[tagIndex];
                //随机颜色
                label.textColor = _tagColorArray[arc4random() % _tagColorArray.count];
                //随机字体
                label.font = _fontArray[arc4random() % _fontArray.count];
                //设定frame
                label.frame = CGRectMake(currentX, kMarginTop + i * kLineHeight, [self getLabelWidthWithLabel:label], label.font.lineHeight);
                //如果此标签的右侧超出屏幕，则另起一行
                if (currentX + label.frame.size.width > CGRectGetWidth([[UIScreen mainScreen] bounds]) * (currentPageIndex + 1)) {
                    //换行前调整X坐标，使整行居中
                    CGFloat endXOfLine = currentX - kMarginWord;
                    CGFloat fixedStartXOfLine = (CGRectGetWidth([[UIScreen mainScreen] bounds]) - (endXOfLine - startXOfLine)) / 2 + CGRectGetWidth([[UIScreen mainScreen] bounds]) * currentPageIndex;
                    for (UILabel* lb in tagsOfLine) {
                        CGRect tempRect = lb.frame;
                        tempRect.origin.x += (fixedStartXOfLine - startXOfLine);
                        lb.frame = tempRect;
                    }
                    break;
                }
                [tagsOfLine addObject:label];
                currentX += label.frame.size.width + kMarginWord;
                //如果是在浮动层上的，那么换算x坐标,y坐标位于同一条线上
                CGRect tempRect = label.frame;
                tempRect.origin.y -= (label.font.lineHeight / 2);
                if (isFloatLabel) {
                    tempRect.origin.x += currentPageIndex * CGRectGetWidth([[UIScreen mainScreen] bounds]) * (_parallaxRate - 1);
                    label.frame = tempRect;
                    [_floatView addSubview:label];
                }
                else{
                    label.frame = tempRect;
                    [_scrollView addSubview:label];
                }
                [indexArray removeObject:indexArray[indexOfIndexArray]];

                //添加点击事件
                label.userInteractionEnabled = YES;
                UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClickAtIndex:)];
                [label addGestureRecognizer:tapGesture];

                isFloatLabel = !isFloatLabel;
            }
        }
        currentPageIndex++;
    }
    return currentPageIndex;
}

//根据label的字体和文字内容获取label宽度
-(CGFloat)getLabelWidthWithLabel:(UILabel*)label
{
    NSDictionary *attribute = @{NSFontAttributeName: label.font};
    CGSize retSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, label.font.lineHeight)
                                              options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute
                                              context:nil].size;
    return retSize.width;
}

#pragma mark - 公开方法
- (void)setTags:(NSArray*)tags andTagColors:(NSArray*)tagColors andFonts:(NSArray*)fonts andParallaxRate:(CGFloat)parallaxRate andNumOfLine:(NSInteger)lineNum
{
    _tagArray = tags;
    _tagColorArray = tagColors;
    _fontArray = fonts;
    _lineNum = lineNum;
    _parallaxRate = parallaxRate < 1 ? 1 : parallaxRate;
    
    _scrollView = [[WWTagsCloudScrollView alloc] initWithFrame:self.bounds];
    _scrollView.parallaxRate = _parallaxRate;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    //添加X轴滚动监听
    [self addSubview:_scrollView];
    
    //浮动层
    _floatView = [[UIView alloc] init];
    //为了点击事件能够穿透到scrollView上
    _floatView.userInteractionEnabled = NO;
    _floatView.tag = FLOATVIEWTAG;
    [_scrollView addSubview:_floatView];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) * [self createLbInContainer], 0);
}
@end
