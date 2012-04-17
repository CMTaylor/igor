#import "ViewFactory.h"
#import "DescendantCombinator.h"
#import "ChildCombinator.h"

@interface ChildCombinatorTests : SenTestCase
@end

@implementation ChildCombinatorTests {
    id <Combinator> childCombinator;
    UIView *subject;
}

- (void)setUp {
    childCombinator = [ChildCombinator new];
    subject = [ViewFactory buttonWithAccessibilityHint:@"subject"];
}

- (void)testNoRelativesIfNoChildren {
    NSArray *relatives = [childCombinator relativesOfView:subject];

    assertThat(relatives, is(empty()));
}

- (void)testChildIsRelativeIfOneChild {
    UIView *onlyChild = [ViewFactory buttonWithAccessibilityHint:@"child"];
    [subject addSubview:onlyChild];

    NSArray *relatives = [childCombinator relativesOfView:subject];

    assertThat(relatives, contains(sameInstance(onlyChild), nil));
}

- (void)testAllChildrenAreRelatives {
    UIView *child1 = [ViewFactory buttonWithAccessibilityHint:@"child 1"];
    UIView *child2 = [ViewFactory buttonWithAccessibilityHint:@"child 2"];
    UIView *child3 = [ViewFactory buttonWithAccessibilityHint:@"child 3"];
    UIView *child4 = [ViewFactory buttonWithAccessibilityHint:@"child 4"];
    UIView *child5 = [ViewFactory buttonWithAccessibilityHint:@"child 5"];
    [subject addSubview:child1];
    [subject addSubview:child2];
    [subject addSubview:child3];
    [subject addSubview:child4];
    [subject addSubview:child5];

    NSArray *relatives = [childCombinator relativesOfView:subject];

    assertThat(relatives, containsInAnyOrder(
            sameInstance(child1),
            sameInstance(child2),
            sameInstance(child3),
            sameInstance(child4),
            sameInstance(child5),
            nil));
}

- (void)testGrandchildrenAreNotRelatives {
    UIView *child = [ViewFactory buttonWithAccessibilityHint:@"child"];
    UIView *grandchild = [ViewFactory buttonWithAccessibilityHint:@"grandchild"];
    [subject addSubview:child];
    [child addSubview:grandchild];

    NSArray *relatives = [childCombinator relativesOfView:subject];

    assertThat(relatives, isNot(hasItem(grandchild)));
}

- (void)testNoInverseRelativesIfNoParent {
    NSArray *relatives = [childCombinator inverseRelativesOfView:subject];

    assertThat(relatives, is(empty()));
}

- (void)testParentIsInverseRelative {
    UIView *parent = [ViewFactory buttonWithAccessibilityHint:@"parent"];
    [parent addSubview:subject];

    NSArray *relatives = [childCombinator inverseRelativesOfView:subject];

    assertThat(relatives, contains(sameInstance(parent), nil));
}

- (void)testGrandParentIsNotInverseRelative {
    UIView *parent = [ViewFactory buttonWithAccessibilityHint:@"parent"];
    UIView *grandparent = [ViewFactory buttonWithAccessibilityHint:@"grandparent"];
    [grandparent addSubview:parent];
    [parent addSubview:subject];

    NSArray *relatives = [childCombinator inverseRelativesOfView:subject];

    assertThat(relatives, isNot(hasItem(grandparent)));
}

- (void)testParentIsInverseRelativeInTreeRootedAtParent {
    UIView *parent = [ViewFactory buttonWithAccessibilityHint:@"parent"];
    [parent addSubview:subject];

    NSArray *relatives = [childCombinator inverseRelativesOfView:subject inTree:parent];

    assertThat(relatives, hasItem(parent));
}

- (void)testParentIsInverseRelativeInTreeRootedAboveParent {
    UIView *parent = [ViewFactory buttonWithAccessibilityHint:@"parent"];
    UIView *grandparent = [ViewFactory buttonWithAccessibilityHint:@"grandparent"];
    [grandparent addSubview:parent];
    [parent addSubview:subject];

    NSArray *relatives = [childCombinator inverseRelativesOfView:subject inTree:grandparent];

    assertThat(relatives, hasItem(parent));
}

- (void)testParentIsNotInverseRelativeInTreeRootedBelowParent {
    UIView *parent = [ViewFactory buttonWithAccessibilityHint:@"parent"];
    UIView *grandparent = [ViewFactory buttonWithAccessibilityHint:@"grandparent"];
    [grandparent addSubview:parent];
    [parent addSubview:subject];

    NSArray *relatives = [childCombinator inverseRelativesOfView:subject inTree:subject];

    assertThat(relatives, isNot(hasItem(parent)));
}

@end
