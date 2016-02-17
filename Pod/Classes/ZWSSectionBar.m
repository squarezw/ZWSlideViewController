//
//  JHSBrandSectionBar.m
//

#import "ZWSSectionBar.h"

@interface ZWSSectionBar ()

@end

@implementation ZWSSectionBar

@synthesize selectedTextColor = _selectedTextColor;
@synthesize nomarlTextColor = _nomarlTextColor;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _tapGestureRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:_tapGestureRecognizer];

        self.scrollsToTop = NO;
    }

    return self;
}

- (UIColor *)nomarlTextColor
{
    if (!_nomarlTextColor) {
        return [UIColor grayColor];
    }
    return _nomarlTextColor;
}

- (UIColor *)selectedTextColor
{
    if (!_selectedTextColor) {
        return [UIColor redColor];
    }
    return _selectedTextColor;
}

- (UIFont *)nomarlTextFont
{
    if (!_nomarlTextFont) {
        return [UIFont systemFontOfSize:14.0f];
    }
    return _nomarlTextFont;
}

- (UIFont *)selectedTextFont
{
    if (!_selectedTextFont) {
        return [UIFont systemFontOfSize:15.0f];
    }
    return _selectedTextFont;
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor
{
    _selectedTextColor = selectedTextColor;
    for (ZWSMenuLabel *item in self.items) {
        item.selectedColor = _selectedTextColor;
    }
}

- (void)setNomarlTextColor:(UIColor *)nomarlTextColor
{
    _nomarlTextColor = nomarlTextColor;
    for (ZWSMenuLabel *item in self.items) {
        item.textColor = _nomarlTextColor;
    }
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;

    NSMutableArray *items = [NSMutableArray arrayWithCapacity:titles.count];

    if ([titles count] > 0) {
        
        for (NSString *s in titles) {
            [items addObject:[self itemForTitle:s]];
        }
        
        UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(.0, .0, 2.0, 10.0)];
        UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(.0, 8.0, 2.0, 2.0)];
        iv.userInteractionEnabled = NO;
        lv.backgroundColor = self.selectedTextColor;
        lv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [iv addSubview:lv];

        self.items = items;
        self.indicatorView = iv;
    } else {
        self.items = nil;
        self.indicatorView = nil;
    }
}

- (void)setItemSize:(CGSize)itemSize {
    if (CGSizeEqualToSize(itemSize, _itemSize)) {
        return;
    }

    _itemSize = itemSize;

    for (UIView *item in self.items) {
        [self resizeItem:item];
    }
}

- (UIView *)itemForTitle:(NSString *)title {
    ZWSMenuLabel *item = [ZWSMenuLabel new];
    item.selectedColor  = self.selectedTextColor;
    item.textColor = self.nomarlTextColor;
    item.selectedFont = self.selectedTextFont;
    item.font = self.nomarlTextFont;
    item.backgroundColor = [UIColor clearColor];
    item.text = title;
    [self resizeItem:item];
    
    if (self.barDelegate && [self.barDelegate respondsToSelector:@selector(didCreateItemView:)]) {
        [self.barDelegate performSelector:@selector(didCreateItemView:) withObject:item];
    }
    
    return item;
}

- (void)tapped:(UITapGestureRecognizer *)sender {
    NSInteger index = [super indexOfItemContainsPoint:[sender locationInView:self]];
    
    if (![super indexIsValid:index]) {
        return;
    }
    
    if ([_barDelegate respondsToSelector:@selector(sectionBar:didSelectAtInedx:)]) {
        [_barDelegate sectionBar:self didSelectAtInedx:index];
    }
}


#pragma mark - Private

- (void)resizeItem:(UIView *)item {
    if (CGSizeEqualToSize(self.itemSize, CGSizeZero)) {
        [item sizeToFit];
    } else {
        CGSize size = [item sizeThatFits:self.itemSize];
        size.width = MAX(size.width, self.itemSize.width);
        size.height = MAX(size.height, self.itemSize.height);
        
        item.bounds = (CGRect){CGPointZero, size};
        item.frame = CGRectOffset(item.frame, 12, 0);
    }
}

@end
