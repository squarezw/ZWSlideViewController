//
//  ZWSPagingView.m
//

#import "ZWSPagingView.h"

@interface ZWSPage (Private)

@property(nonatomic, assign) NSUInteger index;

@end

@implementation ZWSPagingView

- (void)commonInit {
    _visiblePages = [[NSMutableSet alloc] init];
    _recycledPages = [[NSMutableSet alloc] init];
    _preload = NO;

    self.pagingEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.contentOffset = CGPointZero;
    self.scrollsToTop = NO;
    [super setDelegate:self];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc {
    if (_pagingDelegate && _centerPage) {
        [_pagingDelegate pagingView:self didRemovePage:_centerPage];
    }
}

- (NSUInteger)indexOfPage:(ZWSPage *)page {
    if (page.index < _numberOfPages) {
        return page.index;
    } else {
        return page.index - _numberOfPages;
    }
}

- (NSUInteger)indexOfCenterPage {
    return [self indexOfPage:self.centerPage];
}

- (ZWSPage *)pageAtLocation:(CGPoint)location {
    if (!CGRectContainsPoint(self.bounds, location)) {
        return nil;
    }

    NSUInteger index = location.x / CGRectGetWidth(self.frame);
    for (ZWSPage *page in self.visiblePages) {
        if (page.index == index) {
            return page;
        }
    }

    return nil;
}

- (CGFloat)widthInSight:(ZWSPage *)page {
    if (!page || ![_visiblePages containsObject:page]) {
        return .0;
    }

    CGFloat offsetX = self.contentOffset.x, left = CGRectGetMinX(page.frame), right = CGRectGetMaxX(page.frame);

    if (offsetX >= left) {
        return right - offsetX;
    } else {
        return offsetX + CGRectGetWidth(self.frame) - left;
    }
}

- (float)floatIndex {
    CGFloat w = CGRectGetWidth(self.frame) * _numberOfPages, offsetX = self.contentOffset.x;
    return ((_scrollInfinitelyEnabled && offsetX >= w) ? (offsetX - w) : offsetX) / CGRectGetWidth(self.frame);
}

- (void)moveToPageAtFloatIndex:(float)index animated:(BOOL)animated {
    CGFloat w = CGRectGetWidth(self.frame) * _numberOfPages,
            x = self.contentOffset.x >= w ? w + CGRectGetWidth(self.frame) * index : CGRectGetWidth(self.frame) * index;
    CGPoint offset = CGPointMake(x, .0);

    // setContentOffset:animated: 优与 animation block
    [self setContentOffset:offset animated:animated];
}

- (CGSize)contentSizeWithPagingViewSize:(CGSize)size {
       return CGSizeMake(size.width * _numberOfPages * (_scrollInfinitelyEnabled ? 2 : 1),
                                      size.height);

}

- (void)setBounds:(CGRect)bounds {
    if (CGRectEqualToRect(bounds, self.bounds)) {
        return;
    }
    [super setBounds:bounds];
    self.contentSize = [self contentSizeWithPagingViewSize:bounds.size];
}

- (void)setFrame:(CGRect)frame {
    if (CGRectEqualToRect(frame, self.frame)) {
        return;
    }
    [super setFrame:frame];
    self.contentSize = [self contentSizeWithPagingViewSize:frame.size];
}

- (NSSet *)visiblePages {
    return [NSSet setWithSet:_visiblePages];
}

#pragma mark - reload

- (void)setScrollInfinitelyEnabled:(BOOL)scrollInfinitelyEnabled {
    if (scrollInfinitelyEnabled == _scrollInfinitelyEnabled) {
        return;
    }

    _scrollInfinitelyEnabled = scrollInfinitelyEnabled;

    self.contentSize = CGSizeMake(
        CGRectGetWidth(self.frame) * _numberOfPages * (_scrollInfinitelyEnabled ? 2 : 1), CGRectGetHeight(self.frame));
    [self setNeedsLayout];
}

- (void)reloadPages {
    for (ZWSPage *page in _visiblePages) {
        page.hidden = YES;
        page.index = NSUIntegerMax;
        [_recycledPages addObject:page];

        [_pagingDelegate pagingView:self didRemovePage:page];
    }
    [_visiblePages removeAllObjects];
    _centerPage = nil;

    _numberOfPages = [_pagingDataSource numberOfPagesInPagingView:self];

    self.contentSize = [self contentSizeWithPagingViewSize:self.bounds.size];
    
    self.contentOffset = CGPointZero;
    [self setNeedsLayout];
}

- (UIView *)dequeueReusablePage {
    ZWSPage *page = [_recycledPages anyObject];
    if (page != nil) {
        [_recycledPages removeObject:page];
        return page;
    }
    return nil;
}

#pragma mark - scroll

- (BOOL)isDisplayingPageOfIndex:(NSUInteger)index {
    for (ZWSPage *page in _visiblePages) {
        if (page.index == index)
            return YES;
    }
    return NO;
}

- (void)tilePages:(CGPoint)offset {
    CGFloat x = self.contentOffset.x;

    NSUInteger lastNeededPageIndex, firstNeededPageIndex;  // = (NSUInteger)(x / self.width);
    if (!_scrollInfinitelyEnabled && offset.x < .0) {
        firstNeededPageIndex = lastNeededPageIndex = 0;
    } else if (!_scrollInfinitelyEnabled && offset.x + CGRectGetWidth(self.frame) > self.contentSize.width) {
        firstNeededPageIndex = lastNeededPageIndex = _numberOfPages - 1;
    } else {
        firstNeededPageIndex = (NSUInteger)(x / CGRectGetWidth(self.frame));

        if (firstNeededPageIndex * CGRectGetWidth(self.frame) == x) {
            lastNeededPageIndex = firstNeededPageIndex;
        } else {
            lastNeededPageIndex = firstNeededPageIndex + 1;
        }
    }

    for (ZWSPage *page in _visiblePages) {
        if (page.index % _numberOfPages == firstNeededPageIndex % _numberOfPages) {
            page.index = firstNeededPageIndex;
            continue;
        } else if (page.index % _numberOfPages == lastNeededPageIndex % _numberOfPages) {
            page.index = lastNeededPageIndex;
            continue;
        }

        [_recycledPages addObject:page];
        [page setHidden:YES];

        [_pagingDelegate pagingView:self didRemovePage:page];

        page.contentView = nil;

        if (page == _centerPage) {
            _centerPage = nil;
        }

        page.index = NSUIntegerMax;
    }

    [_visiblePages minusSet:_recycledPages];
    
    NSNumber *cachePageIndex;

    if (_preload && (firstNeededPageIndex != lastNeededPageIndex)) {
        cachePageIndex = @(lastNeededPageIndex);
    }
    
    NSArray *indexes = [NSArray arrayWithObjects:@(firstNeededPageIndex),
                   cachePageIndex,
                   nil];

    for (NSNumber *number in indexes) {
        NSUInteger i = number.unsignedIntegerValue;

        if ([self isDisplayingPageOfIndex:i]) {
            continue;
        }

        ZWSPage *page = [_pagingDataSource pagingView:self pageForIndex:i % _numberOfPages];
        page.index = i;

        page.bounds = (CGRect){CGPointZero, self.bounds.size};
        page.center = CGPointMake((i + .5) * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2.0);
        page.hidden = NO;
        if (page.superview != self) {
            [self addSubview:page];
        }

        [_visiblePages addObject:page];

        [_pagingDelegate pagingView:self willMoveToPage:page];
    }
}

- (void)layoutVisiblePages {
    for (ZWSPage *page in _visiblePages) {
        page.bounds = (CGRect){CGPointZero, self.bounds.size};
        page.center = CGPointMake((page.index + .5) * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2.0);
    }

    if (_visiblePages.count != 1 || _centerPage == _visiblePages.anyObject) {
        return;
    }

    _centerPage = _visiblePages.anyObject;

    [_pagingDelegate pagingView:self didMoveToPage:_centerPage];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (_numberOfPages == 0) {
        return;
    }

    if (_scrollInfinitelyEnabled) {
        CGFloat w = _numberOfPages * CGRectGetWidth(self.frame);
        CGPoint offset = self.contentOffset;
        if (self.contentOffset.x + CGRectGetWidth(self.frame) > self.contentSize.width) {
            offset.x -= w;
            self.contentOffset = offset;
        } else if (self.contentOffset.x < .0) {
            offset.x += w;
            self.contentOffset = offset;
        }
    }

    [self tilePages:self.contentOffset];

    [self layoutVisiblePages];

    [_pagingDelegate pagingViewLayoutChanged:self];
}

@end

@implementation ZWSPage

- (void)setIndex:(NSUInteger)index {
    _index = index;
}

- (NSUInteger)index {
    return _index;
}

- (void)setContentView:(UIView *)view {
    if (_contentView == view) {
        return;
    }

    if (_contentView) {
        [_contentView removeFromSuperview];
        _contentView = nil;
    }

    if (view) {
        view.frame = self.bounds;
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:view];
    }

    _contentView = view;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p;frame=%@,contentView=%@", [self class], self,
                                      NSStringFromCGRect(self.frame), _contentView];
}

@end
