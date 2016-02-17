//
//  ZWSFlowMenu.h
//

#import <UIKit/UIKit.h>
#import "ZWSMenuLabel.h"

#define ZWStructWith(_Origin_, _Path_, _Value_) \
    ({                                          \
        typeof(_Origin_) a = (_Origin_);        \
        a._Path_ = (_Value_);                   \
        a;                                      \
    })

#define __SetIfMoreThan(_a_, _b_) ((_a_) = MIN((_a_), (_b_)))
#define __SetIfLessThan(_a_, _b_) ((_a_) = MAX((_a_), (_b_)))

@interface ZWSFlowMenu : UIScrollView

@property(nonatomic, copy) NSArray *items;
@property(nonatomic, strong) UIView *indicatorView;
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, assign) UIEdgeInsets menuInsets;

- (void)layoutItems;

- (void)moveToMenuAtIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

/*
 Used a fractional index values to exactly control the menu moving position
 floatIndex from (-0.999) to (items.count - 0.001)
 */
- (void)moveToMenuAtFloatIndex:(float)floatIndex animated:(BOOL)animated;

- (NSInteger)indexOfItemContainsPoint:(CGPoint)point;

- (BOOL)indexIsValid:(NSInteger)index;

@end
