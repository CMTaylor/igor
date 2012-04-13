#import "Igor.h"
#import "ViewFactory.h"

@interface ClassPatternTests : SenTestCase
@end

@implementation ClassPatternTests {
    CGRect frame;
    Igor *igor;
}

- (void)setUp {
    igor = [Igor igor];
}

- (void)testAnyClassPattern {
    NSString *query = @"*";

    UIView *root = [ViewFactory buttonWithAccessibilityHint:@"root"];
    UIView *view1 = [ViewFactory buttonWithAccessibilityHint:@"view1"];
    UIView *view11 = [ViewFactory buttonWithAccessibilityHint:@"view11"];
    UIView *view12 = [ViewFactory buttonWithAccessibilityHint:@"view12"];
    UIView *view2 = [ViewFactory buttonWithAccessibilityHint:@"view2"];
    UIView *view21 = [ViewFactory buttonWithAccessibilityHint:@"view21"];
    UIView *view211 = [ViewFactory buttonWithAccessibilityHint:@"view211"];
    UIView *view212 = [ViewFactory buttonWithAccessibilityHint:@"view212"];
    UIView *view213 = [ViewFactory buttonWithAccessibilityHint:@"view213"];
    UIView *view22 = [ViewFactory buttonWithAccessibilityHint:@"view22"];
    UIView *view23 = [ViewFactory buttonWithAccessibilityHint:@"view23"];

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

    NSArray *matchingViews = [igor findViewsThatMatchQuery:query inTree:root];

    assertThat(matchingViews, containsInAnyOrder(root, view1, view11, view12, view2, view21, view211, view212, view213, view22, view23, nil));
}

- (void)testMemberOfClassPattern {
    NSString *query = @"UIButton";

    UIView *view = [ViewFactory view];
    UIView *button = [ViewFactory button];
    UIView *imageView = [ViewFactory view];
    UIView *root = view;
    [root addSubview:button];
    [button addSubview:imageView];

    NSArray *matchingViews = [igor findViewsThatMatchQuery:query inTree:root];

    assertThat(matchingViews, hasItem(button));
    assertThat(matchingViews, hasCountOf(1));
}

- (void)testKindOfClassPattern {
    NSString *query = @"UIControl*";

    UIView *viewOfBaseClassOfTargetClass = [ViewFactory view];
    UIControl *viewOfTargetClass = [ViewFactory control];
    UIView *viewOfClassDerivedFromTargetClass = [ViewFactory button];
    UIView *viewOfUnrelatedClass = [ViewFactory window];

    UIView *root = viewOfBaseClassOfTargetClass;
    [root addSubview:viewOfTargetClass];
    [root addSubview:viewOfClassDerivedFromTargetClass];
    [root addSubview:viewOfUnrelatedClass];

    NSArray *matchingViews = [igor findViewsThatMatchQuery:query inTree:root];

    assertThat(matchingViews, hasItem(viewOfTargetClass));
    assertThat(matchingViews, hasItem(viewOfClassDerivedFromTargetClass));
    assertThat(matchingViews, isNot(hasItem(viewOfBaseClassOfTargetClass)));
    assertThat(matchingViews, isNot(hasItem(viewOfUnrelatedClass)));
}

@end