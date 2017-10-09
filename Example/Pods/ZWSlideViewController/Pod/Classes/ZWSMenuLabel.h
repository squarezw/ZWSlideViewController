//
//  ZWSMenuLabel.h
//

#import <Foundation/Foundation.h>
#import "ZWSFlowMenu.h"

@interface ZWSMenuLabel : UILabel <ZWSMenuAppearance>

@property (nonatomic, strong) UIFont *highlightedFont;

- (void)transformColor:(float)progress;

- (void)transformFont:(float)progress;

@end
