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

- (void)setHighlightedFont:(UIFont *)highlightedFont
{
    _highlightedFont = highlightedFont;
}

- (void)transformColor:(float)progress
{
    NSAssert(self.highlightedTextColor, @"You should setting highlightedTextColor!");
    if (!self.highlightedTextColor) {
        return;
    }
    
    if (!self.originFrontColor) {
        self.originFrontColor = [self.textColor copy];
    }
    
    CGFloat fr, fg, fb, fa;
    [self.originFrontColor getRed:&fr green:&fg blue:&fb alpha:&fa];
    CGFloat tr, tg, tb, ta;
    [self.highlightedTextColor getRed:&tr green:&tg blue:&tb alpha:&ta];
    
    self.textColor = [UIColor colorWithRed:mix(fr, tr, progress)
                                     green:mix(fg, tg, progress)
                                      blue:mix(fb, tb, progress)
                                     alpha:ta];
}

- (void)transformFont:(float)progress
{
    NSAssert(self.highlightedFont, @"You should setting highlightedFont!");
    if (!self.highlightedFont) {
        return;
    }

    if (!self.originFont) {
        self.originFont = [self.font copy];
    }
    self.font = [UIFont systemFontOfSize:mix(self.originFont.pointSize, self.highlightedFont.pointSize, progress)];
}

- (void)transformToNormal
{
    [self transformColor:.0];
}

- (void)transformToHighlight
{
    [self transformColor:1.0];
}

- (void)transformPercent:(float)progressPercent
{
    [self transformColor:progressPercent];
}

@end