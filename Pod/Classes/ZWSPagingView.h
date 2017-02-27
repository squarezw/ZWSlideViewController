//
//  ZWSPagingView.h
//

#import <UIKit/UIKit.h>

@interface ZWSPage : UIView {
    NSUInteger _index;
}

@property(nonatomic, strong) UIView *contentView;

@end

@protocol ZWSPagingViewDelegate;
@protocol ZWSPagingViewDataSource;

@interface ZWSPagingView : UIScrollView<UIScrollViewDelegate> {
    BOOL _scrollInfinitelyEnabled;

    NSUInteger _numberOfPages;

    NSMutableSet *_visiblePages;
    NSMutableSet *_recycledPages;

    ZWSPage *_centerPage;

    __weak id<ZWSPagingViewDelegate> _pagingDelegate;
    __weak id<ZWSPagingViewDataSource> _pagingDataSource;

    __weak id _actualDelegate;
}

@property(nonatomic, assign) BOOL scrollInfinitelyEnabled;

@property(nonatomic, weak) id<ZWSPagingViewDelegate> pagingDelegate;
@property(nonatomic, weak) id<ZWSPagingViewDataSource> pagingDataSource;

@property(nonatomic, readonly) ZWSPage *centerPage;
@property(nonatomic, readonly) NSSet *visiblePages;

// it will be pre-fetched content and cached for next page
@property(nonatomic, getter=isPreload) BOOL preload;

- (NSUInteger)indexOfPage:(ZWSPage *)page;
- (NSUInteger)indexOfCenterPage;

- (ZWSPage *)pageAtLocation:(CGPoint)location;

- (CGFloat)widthInSight:(ZWSPage *)page;

- (float)floatIndex;
- (void)moveToPageAtFloatIndex:(float)index animated:(BOOL)animated;

- (ZWSPage *)dequeueReusablePage;
- (void)reloadPages;

@end

@protocol ZWSPagingViewDataSource

@required
- (NSUInteger)numberOfPagesInPagingView:(ZWSPagingView *)pagingView;
- (ZWSPage *)pagingView:(ZWSPagingView *)pagingView pageForIndex:(NSUInteger)index;

@end

@protocol ZWSPagingViewDelegate

- (void)pagingView:(ZWSPagingView *)pagingView didRemovePage:(ZWSPage *)page;
- (void)pagingView:(ZWSPagingView *)pagingView willMoveToPage:(ZWSPage *)page;
- (void)pagingView:(ZWSPagingView *)pagingView didMoveToPage:(ZWSPage *)page;
- (void)pagingViewLayoutChanged:(ZWSPagingView *)pagingView;

@end
