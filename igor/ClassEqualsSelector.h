//
//  ClassEqualsSelector.h
//  igor
//
//  Created by Dale Emery on 11/9/11.
//  Copyright (c) 2011 Dale H. Emery. All rights reserved.
//

#import "Selector.h"

@interface ClassEqualsSelector : NSObject <Selector>
@property(retain,readonly) Class targetClass;
-(ClassEqualsSelector*) initWithTargetClass:(Class)targetClass;
@end
