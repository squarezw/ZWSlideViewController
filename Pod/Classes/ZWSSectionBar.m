//
//  JHSBrandSectionBar.m
//

#import "ZWSSectionBar.h"

@interface ZWSSectionBar ()

@end

@implementation ZWSSectionBar

@synthesize highlightedTextColor = _highlightedTextColor;
@synthesize textColor = _textColor;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _tapGestureRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:_tapGestureRecognizer];

        self.scrollsToTop = NO;
    }

    return self;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        return [UIColor grayColor];
    }
    return _textColor;
}

- (UIColor *)highlightedTextColor
{
    if (!_highlightedTextColor) {
        return [UIColor redColor];
    }
    return _highlightedTextColor;
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

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor
{
    _highlightedTextColor = highlightedTextColor;
    for (id item in self.items) {
        if ([item isKindOfClass:[UILabel class]]) {
            ((UILabel *)item).highlightedTextColor = _highlightedTextColor;
        }
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    for (id item in self.items) {
        if ([item isKindOfClass:[UILabel class]]) {
            ((UILabel *)item).textColor = _textColor;
        }
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
        UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(.0, iv.bounds.size.height - (self.indicatorHeight?:2), 2.0, self.indicatorHeight?:2)];
        iv.userInteractionEnabled = NO;
        lv.backgroundColor = self.indicatorColor?:self.highlightedTextColor;
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
    UIView *item;
    
    if (self.barDelegate && [self.barDelegate respondsToSelector:@selector(menuItemWithTitle:)]) {
        item = [self.barDelegate performSelector:@selector(menuItemWithTitle:) withObject:title];
    }
    
    if (!item) {
        ZWSMenuLabel *itemLabel = [ZWSMenuLabel new];
        itemLabel.highlightedTextColor  = self.highlightedTextColor;
        itemLabel.textColor = self.textColor;
        itemLabel.highlightedFont = self.selectedTextFont;
        itemLabel.font = self.nomarlTextFont;
        itemLabel.backgroundColor = [UIColor clearColor];
        itemLabel.text = title;
        itemLabel.textAlignment = NSTextAlignmentCenter;
        item = itemLabel;
    }
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
        if ([item isKindOfClass:[UILabel class]]) {
            [item sizeToFit];
        }
    } else {
        CGSize size = [item sizeThatFits:self.itemSize];
        size.width = MAX(size.width, self.itemSize.width);
        size.height = MAX(size.height, self.itemSize.height);
        
        item.bounds = (CGRect){CGPointZero, size};
        item.frame = CGRectOffset(item.frame, 12, 0);
    }
}

@end
