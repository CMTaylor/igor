#import "DEIgor.h"
#import "ViewFactory.h"

@interface PredicatePatternTests : SenTestCase
@end

@implementation PredicatePatternTests {
    DEIgor *igor;
    UIView *view;
}

- (void)setUp {
    igor = [DEIgor igor];
    view = [ViewFactory button];
    view.accessibilityHint = @"the right accessibility hint";
}

- (void)testMatchesSubjectThatSatisfiesPredicate {
    NSArray *matchingViews = [igor findViewsThatMatchQuery:@"[accessibilityHint='the right accessibility hint']" inTree:view];
    assertThat(matchingViews, hasItem(view));
}

- (void)testMismatchesSubjectThatDoesNotSatisfyPredicate {
    NSArray *matchingViews = [igor findViewsThatMatchQuery:@"[accessibilityHint='wrong accessibility hint']" inTree:view];
    assertThat(matchingViews, is(empty()));
}

- (void)testThrowsIfPatternIsIllegal {
    STAssertThrows([igor findViewsThatMatchQuery:@"[this is not a valid predicate]" inTree:nil], nil);
}
@end
