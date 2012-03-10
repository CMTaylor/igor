//
//  KindOfClassSelector.m
//  igor
//
//  Created by Dale Emery on 11/17/11.
//  Copyright (c) 2011 Dale H. Emery. All rights reserved.
//

#import "KindOfClassMatcher.h"

@implementation KindOfClassMatcher

@synthesize matchClass;

-(id) initForClass:(Class)targetClass {
    if(self = [super init]) {
        matchClass = targetClass;
    }
    return self;
}

+(id) forClass:(Class)targetClass {
    return [[self alloc] initForClass:targetClass];
}

-(BOOL) matchesView:(UIView *)view {
    return [view isKindOfClass:self.matchClass];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"[KindOfClassMatcher:[matchClass:%@]]", matchClass];
}
@end
