TLSegmentedControl
==================

# Introduce
* 类似于微博的SegmentedControl。

# System Requirement
* iOS 8.0 or later
* Xcode 8.0 or later

# Character
* 支持滚动 & 固定宽度两种模式

# Usage
```
    TLSegmentedControl *segmentBar = [[TLSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 100, 44) titls:@[@"Page1",@"Page2",@"Page3",@"Page4",@"Page5",@"Page6"] delegate:self];
    segmentBar.spacing = 20;
    segmentBar.padding = UIEdgeInsetsMake(10, 0, 0, 0);
    segmentBar.index = 0;
    segmentBar.indicatorBarColor = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor redColor].CGColor];
    self.navigationItem.titleView = self.segmentBar;

```

# Images

<img src="./ScreenShot/1.gif" width="320">