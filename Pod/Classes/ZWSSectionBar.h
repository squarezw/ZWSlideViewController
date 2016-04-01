//
//  JHSBrandSectionBar.h
//

#import <UIKit/UIKit.h>
#import "ZWSFlowMenu.h"
#import "ZWSMenuLabel.h"

@protocol ZWSSectionBarDelegate;

@interface ZWSSectionBar : ZWSFlowMenu {
    UITapGestureRecognizer *_tapGestureRecognizer;
    NSArray *_titles;
}

@property (nonatomic, strong) UIColor *textColor; // Default: grayColor
@property (nonatomic, strong) UIColor *highlightedTextColor; // Default: redColor
@property (nonatomic, assign) CGFloat indicatorHeight; // Default: 2px

@property (nonatomic, strong) UIFont *nomarlTextFont; // Default: 14.0f
@property (nonatomic, strong) UIFont *selectedTextFont; // Default: 15.0f

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, assign) CGSize itemSize;

@property(nonatomic, weak) id<ZWSSectionBarDelegate> barDelegate;

- (UIView *)itemForTitle:(NSString *)title;

@end

@protocol ZWSSectionBarDelegate<NSObject>

@optional

- (void)sectionBar:(ZWSSectionBar *)sectionBar didSelectAtInedx:(NSUInteger)index;

- (void)didCreateItemView:(UIView *)itemView;

- (UIView *)menuItemWithTitle:(NSString *)title;

@end
