
#import "KindOfClassMatcher.h"

@implementation KindOfClassMatcher

@synthesize matchClass;

-(NSString*) description {
    return [NSString stringWithFormat:@"[KindOfClassMatcher:[matchClass:%@]]", matchClass];
}

+(KindOfClassMatcher*) forClass:(Class)targetClass {
    return [[self alloc] initForClass:targetClass];
}

-(KindOfClassMatcher*) initForClass:(Class)targetClass {
    self = [super init];
    if(self) {
        matchClass = targetClass;
    }
    return self;
}

-(BOOL) matchesView:(UIView*)view {
    return [view isKindOfClass:self.matchClass];
}

@end
