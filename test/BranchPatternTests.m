#import "ViewFactory.h"
#import "Igor.h"

@interface BranchPatternTests : SenTestCase
@end

@implementation BranchPatternTests {
    Igor *igor;
    UIView *root;
    UIView *middle1;
    UIView *middle1leaf1;
    UIView *middle1leaf2;
    UIView *middle2;
    UIView *middle2leaf1;
    UIView *middle2leaf2;
}

- (void)setUp {
    igor = [Igor igor];
    root = [ViewFactory buttonWithAccessibilityHint:@"root"];
    middle1 = [ViewFactory buttonWithAccessibilityHint:@"middle 1"];
    middle1leaf1 = [ViewFactory buttonWithAccessibilityHint:@"middle 1 leaf 1"];
    middle1leaf2 = [ViewFactory buttonWithAccessibilityHint:@"middle 1 leaf 2"];
    middle2 = [ViewFactory buttonWithAccessibilityHint:@"middle 2"];
    middle2leaf1 = [ViewFactory buttonWithAccessibilityHint:@"middle 2 leaf 1"];
    middle2leaf2 = [ViewFactory buttonWithAccessibilityHint:@"middle 2 leaf 2"];
    [root addSubview:middle1];
    [middle1 addSubview:middle1leaf1];
    [middle1 addSubview:middle1leaf2];
    [root addSubview:middle2];
    [middle2 addSubview:middle2leaf1];
    [middle2 addSubview:middle2leaf2];
}

- (void)testBranchAroundOnlySubjectPattern {
    NSArray *matchingViews = [igor findViewsThatMatchQuery:@"([accessibilityHint='middle 1'])" inTree:root];
    assertThat(matchingViews, hasItem(middle1));
    assertThat(matchingViews, hasCountOf(1));
}

- (void)testSubjectMatchesViewTailMatchesDescendant {
    NSArray *matchingViews = [igor findViewsThatMatchQuery:@"([accessibilityHint='middle 1'] [accessibilityHint='middle 1 leaf 1'])" inTree:root];
    assertThat(matchingViews, hasItem(middle1));
    assertThat(matchingViews, hasCountOf(1));
}

- (void)testSubjectMatchesViewTailMismatchesDescendants {
    NSArray *matchingViews = [igor findViewsThatMatchQuery:@"([accessibilityHint='middle 1'] [accessibilityHint='does not exist'])" inTree:root];
    assertThat(matchingViews, is(empty()));
}

- (void)testSubjectMatchesViewHeadBranchMatchesSubjectAndDescendants {
    NSArray *matchingViews = [igor findViewsThatMatchQuery:@"([accessibilityHint='root'] [accessibilityHint='middle 1 leaf 1']) [accessibilityHint='middle 2 leaf 1']" inTree:root];
    assertThat(matchingViews, hasItem(middle2leaf1));
    assertThat(matchingViews, hasCountOf(1));
}

- (void)testTailHasAChainOfMatchers {
    NSArray *matchingViews = [igor findViewsThatMatchQuery:@"([accessibilityHint='root'] [accessibilityHint='middle 1'] [accessibilityHint='middle 1 leaf 1'])" inTree:root];
    assertThat(matchingViews, hasItem(root));
    assertThat(matchingViews, hasCountOf(1));
}

- (void)testSubjectMatchesViewHeadBranchMatchesSubjectMismatchesDescendants {
    NSArray *matchingViews = [igor findViewsThatMatchQuery:@"([accessibilityHint='root'] [accessibilityHint='does not exist']) [accessibilityHint='middle 2 leaf 1']" inTree:root];
    assertThat(matchingViews, is(empty()));
}

- (void)testSubjectMatchesViewWithinAncestorBranchSubjects {
    NSArray *matchingViews = [igor findViewsThatMatchQuery:@"[accessibilityHint='root'] ([accessibilityHint='middle 1'] [accessibilityHint='middle 1 leaf 1']) [accessibilityHint='middle 1 leaf 2']" inTree:root];
    assertThat(matchingViews, hasItem(middle1leaf2));
    assertThat(matchingViews, hasCountOf(1));
}

- (void)testBranchMatchesViewsButQueryMatchesNoSubjectsInsideBranchSubjects {
    NSArray *matchingViews = [igor findViewsThatMatchQuery:@"[accessibilityHint='root'] ([accessibilityHint='middle 1'] [accessibilityHint='middle 1 leaf 1']) [accessibilityHint='middle 2 leaf 2']" inTree:root];
    assertThat(matchingViews, is(empty()));
}

- (void)testSiblingBranchesInQuery {
    NSArray *matchingViews = [igor findViewsThatMatchQuery:@"([accessibilityHint='root'] [accessibilityHint='middle 1 leaf 1']) ([accessibilityHint='middle 2'] [accessibilityHint='middle 2 leaf 1'])" inTree:root];
    assertThat(matchingViews, hasItem(middle2));
    assertThat(matchingViews, hasCountOf(1));
}

- (void)testNestedBranchesInQuery {
    NSArray *matchingViews = [igor findViewsThatMatchQuery:@"([accessibilityHint='root'] ([accessibilityHint='middle 1'] [accessibilityHint='middle 1 leaf 1'])) [accessibilityHint='middle 2']" inTree:root];
    assertThat(matchingViews, hasItem(middle2));
    assertThat(matchingViews, hasCountOf(1));
}

@end
