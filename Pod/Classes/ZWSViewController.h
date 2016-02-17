//
//  ZWSViewController.h
//  ZWSlideViewController
//
//  Created by square on 09/07/2015.
//  Copyright (c) 2015 square. All rights reserved.
//

#import "ZWSPagingView.h"
#import "ZWSSectionBar.h"

@interface ZWSViewController : UIViewController <ZWSPagingViewDataSource, ZWSPagingViewDelegate, ZWSSectionBarDelegate>

@property (nonatomic, readonly) ZWSPagingView *pagingView;
@property (nonatomic, readonly) ZWSSectionBar *sectionBar;

/**
 Whether to use 3D effects scrolling to next page. Defaults to `NO`.
 */
@property(nonatomic, assign) BOOL useTransform3DEffects;

@property(nonatomic, assign) CGFloat menuHeight;

@property(nonatomic, copy) NSArray *menuTitles;

// This method could be overridden in subclasses to prepare some data source, The default is a nop.
- (void)loadData;

// This method could be invoked to refresh all subViews.
- (void)refreshViews;

// This method could be overridden in subclasses to create custom content view in page
- (UIView *)contentViewForPage:(ZWSPage *)page atIndex:(NSInteger)index;

@end
