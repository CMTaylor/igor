
#import "MemberOfClassMatcher.h"

@implementation MemberOfClassMatcher

@synthesize matchClass;

-(NSString*) description {
    return [NSString stringWithFormat:@"[MemberOfClassMatcher:[matchClass:%@]]", matchClass];
}

+(MemberOfClassMatcher*) forClass:(Class)aClass {
    return [[self alloc] initForClass:aClass];
}

-(MemberOfClassMatcher*) initForClass:(Class)aClass {
    if(self = [super init]) {
        matchClass = aClass;
    }
    return self;
}

-(BOOL) matchesView:(UIView*)view {
    return [view isMemberOfClass:self.matchClass];
}

@end
