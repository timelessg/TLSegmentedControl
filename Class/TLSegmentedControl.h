//
//  TLSegmentedControl.h
//  TLSegmentedControl
//
//  Created by garry on 2017/6/22.
//  Copyright © 2017年 com.garry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLSegmentedControl;

@protocol TLSegmentedControlDelegate <NSObject>
-(void)segmentedControl:(TLSegmentedControl *)segmentedControl didSelectIndex:(NSUInteger)index;
@end

@interface TLSegmentedControl : UIView
//for indicatorBar scroll
@property(nonatomic,assign)CGFloat offsetX;
//current index
@property(nonatomic,assign)NSUInteger index;
//spacing > 0 && segment's totoal width > segmentedControl.width => scroll = true。default is zero，scroll enable = false
@property(nonatomic,assign)CGFloat spacing;
@property(nonatomic,assign)UIEdgeInsets padding;
//gradient colors, if set single color indicatorBar will be pure color
@property(nonatomic,strong)NSArray *indicatorBarColor;
//default is {15,3}
@property(nonatomic,assign)CGSize   indicatorBarSize;
//default is 0x666666
@property(nonatomic,strong)UIColor *segmentedTitleNormalColor;
//default is 0x333333
@property(nonatomic,strong)UIColor *segmentedTitleSelectedColor;
//default is system 15
@property(nonatomic,strong)UIFont  *segmentedTitleFont;
@property(nonatomic,assign)id <TLSegmentedControlDelegate> delegate;

-(instancetype)initWithTitls:(NSArray *)titles delegate:(id <TLSegmentedControlDelegate>)delegate;
-(instancetype)initWithFrame:(CGRect)frame titls:(NSArray *)titles delegate:(id <TLSegmentedControlDelegate>)delegate;
@end


@interface JLSegmentedButton : UIButton

@end


@interface UIView (TL)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
@end
