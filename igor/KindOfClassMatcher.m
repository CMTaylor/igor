#import "KindOfClassMatcher.h"

@implementation KindOfClassMatcher

@synthesize matchClass = _matchClass;

- (NSString *)description {
    return [NSString stringWithFormat:@"[KindOfClass:%@]", _matchClass];
}

+ (KindOfClassMatcher *)forClass:(Class)targetClass {
    return [[self alloc] initForClass:targetClass];
}

- (KindOfClassMatcher*)initForClass:(Class)matchClass {
    if (self = [super init]) {
        _matchClass = matchClass;
    }
    return self;
}

- (BOOL)matchesView:(UIView *)view {
    return [view isKindOfClass:_matchClass];
}

@end
