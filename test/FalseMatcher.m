#import "FalseMatcher.h"

@implementation FalseMatcher

- (BOOL)matchesView:(UIView *)view {
    return NO;
}

- (BOOL)matchesView:(UIView *)view inTree:(UIView *)root {
    return NO;
}

@end