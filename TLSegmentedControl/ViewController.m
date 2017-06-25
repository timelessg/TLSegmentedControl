//
//  ViewController.m
//  TLSegmentedControl
//
//  Created by garry on 2017/6/22.
//  Copyright © 2017年 com.garry. All rights reserved.
//

#import "ViewController.h"
#import "TLSegmentedControl.h"

@interface ViewController () <TLSegmentedControlDelegate, UIScrollViewDelegate>
@property(nonatomic,strong)TLSegmentedControl *segmentBar;
@property(nonatomic,strong)UIScrollView *pageScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.segmentBar = [[TLSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 100, 44) titls:@[@"Page1",@"Page2",@"Page3",@"Page4",@"Page5",@"Page6"] delegate:self];
    self.segmentBar.spacing = 20;
    self.segmentBar.padding = UIEdgeInsetsMake(10, 0, 8, 0);
    self.segmentBar.index = 2;
    self.segmentBar.pageWidth = self.view.bounds.size.width / 2;
    self.segmentBar.indicatorBarSize = CGSizeMake(15, 3);
    self.segmentBar.indicatorBarColor = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor redColor].CGColor];
    self.navigationItem.titleView = self.segmentBar;
    
    [self.view addSubview:self.pageScrollView];
    self.pageScrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width / 2, 200);
    self.pageScrollView.center = CGPointMake(self.view.bounds.size.width / 2, 200);
    
    self.pageScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 3, 0);
    self.pageScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
}
-(void)segmentedControl:(TLSegmentedControl *)segmentedControl didSelectIndex:(NSUInteger)index {
    self.pageScrollView.contentOffset = CGPointMake(index * (self.view.bounds.size.width / 2), 0);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.segmentBar.offsetX = scrollView.contentOffset.x;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.segmentBar.index = index;
}
-(UIScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] init];
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.delegate = self;
        _pageScrollView.backgroundColor = [UIColor grayColor];
        _pageScrollView.bounces = NO;
        _pageScrollView.showsVerticalScrollIndicator = NO;
    }
    return _pageScrollView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
