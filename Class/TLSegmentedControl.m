//
//  TLSegmentedControl.m
//  TLSegmentedControl
//
//  Created by garry on 2017/6/22.
//  Copyright © 2017年 com.garry. All rights reserved.
//


#import "TLSegmentedControl.h"

#define UIColorFromHEX(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

@interface TLSegmentedControl ()
{
    NSUInteger lastIndex;
}
@property(nonatomic,strong)NSArray *segmentedTitles;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *btns;
@property(nonatomic,strong)UIView *indicatorBar;
@property(nonatomic,strong)CAGradientLayer *gradientLayer;
@end

@implementation TLSegmentedControl
-(instancetype)initWithTitls:(NSArray *)titles delegate:(id<TLSegmentedControlDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        self.segmentedTitles = titles;
        [self setupViews];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame titls:(NSArray *)titles delegate:(id<TLSegmentedControlDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.segmentedTitles = titles;
        [self setupViews];
    }
    return self;
}

#pragma mark - action

-(void)segmentSelectedAction:(JLSegmentedButton *)sender {
    NSInteger index = [self.btns indexOfObject:sender];
    if (lastIndex == index) {
        return;
    }
    lastIndex = index;
    
    for (UIButton *segBtn in self.btns) {
        segBtn.selected = NO;
    }
    sender.selected = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorBar.centerX = sender.centerX;
    }];
    
    [self adjustContentOffsetWithCenterX:sender.centerX];
    
    if ([self.delegate respondsToSelector:@selector(segmentedControl:didSelectIndex:)]) {
        [self.delegate segmentedControl:self didSelectIndex:index];
    }
}

#pragma mark - private method

-(void)setupViews {
    self.pageWidth = [UIScreen mainScreen].bounds.size.width;
    
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.indicatorBar];
    [self.indicatorBar sizeToFit];
    
    [self.scrollView.layer addSublayer:self.gradientLayer];
    self.gradientLayer.mask = self.indicatorBar.layer;
    
}

-(void)adjustContentOffsetWithCenterX:(CGFloat)centerX {
    if (self.scrollView.width >= self.scrollView.contentSize.width) {
        return;
    }
    if (centerX > self.scrollView.width / 2) {
        if (centerX < self.scrollView.contentSize.width - self.scrollView.width / 2) {
            [self.scrollView setContentOffset:CGPointMake(self.indicatorBar.centerX - self.scrollView.width / 2, 0) animated:YES];
        }else {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.width, 0) animated:YES];
        }
    }else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - setter
-(void)setPageWidth:(CGFloat)pageWidth {
    _pageWidth = pageWidth;
    
    [self setOffsetX:_offsetX];
}
-(void)setSegmentedTitles:(NSArray *)segmentedTitles {
    _segmentedTitles = segmentedTitles;
    
    [self.btns removeAllObjects];
    
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[JLSegmentedButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    NSInteger i = 0;
    for (NSString *title in self.segmentedTitles) {
        JLSegmentedButton *segBtn = [JLSegmentedButton buttonWithType:UIButtonTypeCustom];
        [segBtn setTitle:title forState:UIControlStateNormal];
        [segBtn setTitleColor:UIColorFromHEX(0x666666) forState:UIControlStateNormal];
        [segBtn setTitleColor:UIColorFromHEX(0x333333) forState:UIControlStateSelected];
        segBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [segBtn addTarget:self action:@selector(segmentSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
        [segBtn sizeToFit];
        segBtn.bounds = CGRectMake(0, 0, segBtn.titleLabel.intrinsicContentSize.width, segBtn.titleLabel.intrinsicContentSize.height);
        
        [self.btns addObject:segBtn];
        [self.scrollView addSubview:segBtn];
        i ++ ;
    }
    
    UIButton *firstBtn = [self.btns firstObject];
    firstBtn.selected = YES;
}
-(void)setSegmentedTitleFont:(UIFont *)segmentedTitleFont {
    _segmentedTitleFont = segmentedTitleFont;
    
    for (JLSegmentedButton *btn in self.btns) {
        btn.titleLabel.font = segmentedTitleFont;
    }
    
    [self layoutIfNeeded];
}
-(void)setSegmentedTitleNormalColor:(UIColor *)segmentedTitleNormalColor {
    _segmentedTitleNormalColor = segmentedTitleNormalColor;
    for (JLSegmentedButton *btn in self.btns) {
        [btn setTitleColor:segmentedTitleNormalColor forState:UIControlStateNormal];
    }
}
-(void)setSegmentedTitleSelectedColor:(UIColor *)segmentedTitleSelectedColor {
    _segmentedTitleSelectedColor = segmentedTitleSelectedColor;
    for (JLSegmentedButton *btn in self.btns) {
        [btn setTitleColor:segmentedTitleSelectedColor forState:UIControlStateSelected];
    }
}
-(void)setIndicatorBarSize:(CGSize)indicatorBarSize {
    _indicatorBarSize = indicatorBarSize;
    self.indicatorBar.size = _indicatorBarSize;
    self.indicatorBar.layer.cornerRadius = self.indicatorBar.height / 2;
}
-(void)setIndicatorBarColor:(NSArray *)indicatorBarColor {
    _indicatorBarColor = indicatorBarColor;
    _gradientLayer.colors = _indicatorBarColor;
}
-(void)setPadding:(UIEdgeInsets)padding {
    _padding = padding;
    [self layoutIfNeeded];
}
-(void)setOffsetX:(CGFloat)offsetX {
    if (self.pageWidth == 0) {
        return;
    }
    NSInteger index = offsetX / self.pageWidth;
    CGFloat rOffset = fmodf(offsetX, self.pageWidth);
    CGFloat width = self.indicatorBarSize.width;
    
    CGFloat centerX = ((UIButton *)self.btns[index]).centerX;
    CGFloat nextCenterX = ((UIButton *)self.btns[index + 1 >= self.btns.count ? self.btns.count - 1 : index + 1]).centerX;
    CGFloat gapWidth = fabs(nextCenterX - centerX);
    
    CGFloat bOffsetX = (rOffset / self.pageWidth) * gapWidth;
    
    if (bOffsetX < gapWidth / 2) {
        self.indicatorBar.x = centerX - width / 2;
        self.indicatorBar.width = bOffsetX * 2 + width;
    }else {
        self.indicatorBar.width = (gapWidth - bOffsetX) * 2 + width;
        self.indicatorBar.x = nextCenterX + width / 2 - self.indicatorBar.width;
    }
}
-(void)setIndex:(NSUInteger)index {
    _index = index;
    [self segmentSelectedAction:self.btns[index]];
}

#pragma mark - getter

-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
-(UIView *)indicatorBar {
    if (!_indicatorBar) {
        _indicatorBarSize = CGSizeMake(15, 3);
        _indicatorBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 3)];
        _indicatorBar.backgroundColor = UIColorFromHEX(0xffd321);
        _indicatorBar.layer.cornerRadius = 1.5;
    }
    return _indicatorBar;
}
-(CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [[CAGradientLayer alloc] init];
        _gradientLayer.colors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor redColor].CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
    }
    return _gradientLayer;
}
-(NSMutableArray *)btns {
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

#pragma mark - override

-(void)layoutSubviews {
    self.scrollView.frame = self.bounds;
    
    CGFloat btnsWidth = 0;
    for (JLSegmentedButton *btn in self.btns) {
        btnsWidth += btn.intrinsicContentSize.width;
    }
    
    CGFloat spacing = self.spacing == 0 ? (CGRectGetWidth(self.frame) - btnsWidth) / (self.segmentedTitles.count - 1) : self.spacing;
    
    self.scrollView.contentSize = CGSizeMake(btnsWidth + spacing * (self.btns.count - 1), 0);
    self.gradientLayer.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.height);
    
    JLSegmentedButton *lastBtn = nil;
    for (int j = 0; j < self.btns.count; j ++ ) {
        JLSegmentedButton *segBtn = self.btns[j];
        segBtn.center = CGPointMake(CGRectGetMidX(segBtn.frame) + (lastBtn ? CGRectGetMaxX(lastBtn.frame) + spacing : 0), segBtn.height / 2 + self.padding.top);
        lastBtn = segBtn;
    }
    
    JLSegmentedButton *firstBtn = [self.btns firstObject];
    self.indicatorBar.center = CGPointMake(CGRectGetMidX(firstBtn.frame), self.height - CGRectGetMidY(self.indicatorBar.frame) - self.padding.bottom);
}
@end



@implementation JLSegmentedButton
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
@end




@implementation UIView (TL)
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setMaxX:(CGFloat)maxX {
    CGRect frame = self.frame;
    CGFloat currMaxX = CGRectGetMaxX(self.frame);
    if (maxX > currMaxX) {
        self.x += maxX - currMaxX;
    } else {
        self.x -= maxX - currMaxX;
    }
    self.frame = frame;
}

- (void)setMaxY:(CGFloat)maxY {
    CGRect frame = self.frame;
    CGFloat currMaxY = CGRectGetMaxY(self.frame);
    if (maxY > currMaxY) {
        self.y += maxY - currMaxY;
    } else {
        self.y -= maxY - currMaxY;
    }
    self.frame = frame;
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}
@end
