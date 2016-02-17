//
//  ZWSMenuLabel.m
//

#import "ZWSMenuLabel.h"

@interface ZWSMenuLabel ()

@property (nonatomic, copy) UIColor *originFrontColor; // Default: textColor
@property (nonatomic, copy) UIFont *originFont; // Default: textFont

@end

@implementation ZWSMenuLabel

static float (^mix)(float a, float b, float p) = ^float(float a, float b, float p) {
    return a + (b - a) * p;
};

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return self;
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
}

- (void)setSelectedFont:(UIFont *)selectedFont
{
    _selectedFont = selectedFont;
}

- (void)transformColor:(float)progress
{
    NSAssert(self.selectedColor, @"You should setting selectedFont!");
    if (!self.selectedColor) {
        return;
    }
    
    if (!self.originFrontColor) {
        self.originFrontColor = [self.textColor copy];
    }
    
    CGFloat fr, fg, fb, fa;
    [self.originFrontColor getRed:&fr green:&fg blue:&fb alpha:&fa];
    CGFloat tr, tg, tb, ta;
    [self.selectedColor getRed:&tr green:&tg blue:&tb alpha:&ta];
    
    self.textColor = [UIColor colorWithRed:mix(fr, tr, progress)
                                     green:mix(fg, tg, progress)
                                      blue:mix(fb, tb, progress)
                                     alpha:ta];
}

- (void)transformFont:(float)progress
{
    NSAssert(self.selectedFont, @"You should setting selectedFont!");
    if (!self.selectedFont) {
        return;
    }

    if (!self.originFont) {
        self.originFont = [self.font copy];
    }
    self.font = [UIFont systemFontOfSize:mix(self.originFont.pointSize, self.selectedFont.pointSize, progress)];
}

@end