//
//  Created by Dale on 11/4/11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

#import <UIKit/UIKit.h>
#import "Igor.h"


@interface IgorTests : SenTestCase
@end

@implementation IgorTests {
    CGRect frame;
}

-(void) setUp {
    frame = CGRectMake(0, 0, 100, 100);
}

- (void) testAUniversalSelectorSelectsAllViews {
    UIView *root = [[UIView alloc] initWithFrame:frame];
    UIView *view1 = [[UIView alloc] initWithFrame: frame];
    UIView *view11 = [[UIView alloc] initWithFrame:frame];
    UIView *view12 = [[UIView alloc] initWithFrame:frame];
    UIView *view2 = [[UIView alloc] initWithFrame: frame];
    UIView *view21 = [[UIView alloc] initWithFrame:frame];
    UIView *view211 = [[UIView alloc] initWithFrame:frame];
    UIView *view212 = [[UIView alloc] initWithFrame:frame];
    UIView *view213 = [[UIView alloc] initWithFrame:frame];
    UIView *view22 = [[UIView alloc] initWithFrame:frame];
    UIView *view23 = [[UIView alloc] initWithFrame:frame];

    [root addSubview:view1];
        [view1 addSubview:view11];
        [view1 addSubview:view12];
    [root addSubview:view2];
        [view2 addSubview:view21];
            [view21 addSubview:view211];
            [view21 addSubview:view212];
            [view21 addSubview:view213];
        [view2 addSubview:view22];
        [view2 addSubview:view23];

    Igor *igor = [Igor igorFor:@"*"];
    NSArray *selectedViews = [igor selectViewsFromRoot:root];

    assertThat(selectedViews, hasItem(root));
    assertThat(selectedViews, hasItem(view1));
    assertThat(selectedViews, hasItem(view11));
    assertThat(selectedViews, hasItem(view12));
    assertThat(selectedViews, hasItem(view2));
    assertThat(selectedViews, hasItem(view21));
    assertThat(selectedViews, hasItem(view211));
    assertThat(selectedViews, hasItem(view212));
    assertThat(selectedViews, hasItem(view213));
    assertThat(selectedViews, hasItem(view22));
    assertThat(selectedViews, hasItem(view23));
}

- (void) testAClassEqualsSelectorSelectsViewsOfTheSpecifiedClass {
    UIView *root = [[UIView alloc] initWithFrame:frame];
    UIView *button = [[UIButton alloc] initWithFrame: frame];
    UIView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [root addSubview:button];
    [button addSubview:imageView];
    
    Igor *igor = [Igor igorFor:@"UIButton"];
    NSArray *selectedViews = [igor selectViewsFromRoot:root];
    
    assertThat(selectedViews, hasItem(button));
    assertThat(selectedViews, isNot(hasItem(root)));
    assertThat(selectedViews, isNot(hasItem(imageView)));
}

@end