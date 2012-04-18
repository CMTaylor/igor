#import "ChainMatcher.h"
#import "IdentityMatcher.h"
#import "ViewFactory.h"
#import "BranchMatcher.h"
#import "FalseMatcher.h"
#import "DescendantCombinator.h"
#import "UniversalMatcher.h"
#import "MatchesView.h"
#import "EmptySetCombinator.h"
#import "ChildCombinator.h"
@interface BranchMatcherTests : SenTestCase
@end

@implementation BranchMatcherTests {
    UIView *root;
    UIView *middle;
    UIView *leaf;
}

- (void)setUp {
    root = [ViewFactory viewWithName:@"root"];
    middle = [ViewFactory viewWithName:@"middle"];
    leaf = [ViewFactory viewWithName:@"leaf"];
    [root addSubview:middle];
    [middle addSubview:leaf];
}

- (void)testMismatchesIfSubjectMismatchesAndThereAreNoRelativeMatchers {
    BranchMatcher *branchMatcher = [BranchMatcher matcherWithSubjectMatcher:[IdentityMatcher matcherWithView:middle]];

    assertThat(branchMatcher, isNot([MatchesView view:root]));
}

- (void)testMatchesIfSubjectMatchesAndRelativesMatch {
    id <ChainMatcher> matchEverySubjectMatchEveryRelative = [BranchMatcher matcherWithSubjectMatcher:[UniversalMatcher new]];
    [matchEverySubjectMatchEveryRelative appendCombinator:[DescendantCombinator new] matcher:[UniversalMatcher new]];

    assertThat(matchEverySubjectMatchEveryRelative, [MatchesView view:middle]);
}

- (void)testMismatchesIfSubjectMismatches {
    id <ChainMatcher> mismatchEverySubjectMatchEveryRelative = [BranchMatcher matcherWithSubjectMatcher:[FalseMatcher new]];
    [mismatchEverySubjectMatchEveryRelative appendCombinator:[DescendantCombinator new] matcher:[UniversalMatcher new]];

    assertThat(mismatchEverySubjectMatchEveryRelative, isNot([MatchesView view:leaf]));
}

- (void)testMismatchesIfRelativesMismatch {
    id <ChainMatcher> matchEverySubjectMismatchEveryRelative = [BranchMatcher matcherWithSubjectMatcher:[UniversalMatcher new]];
    [matchEverySubjectMismatchEveryRelative appendCombinator:[DescendantCombinator new] matcher:[FalseMatcher new]];

    assertThat(matchEverySubjectMismatchEveryRelative, isNot([MatchesView view:middle]));
}

- (void)testMismatchesIfCombinatorYieldsNoRelatives {
    id <ChainMatcher> combinatorYieldsNoRelatives = [BranchMatcher matcherWithSubjectMatcher:[UniversalMatcher new]];
    [combinatorYieldsNoRelatives appendCombinator:[EmptySetCombinator new] matcher:[UniversalMatcher new]];

    assertThat(combinatorYieldsNoRelatives, isNot([MatchesView view:middle]));
}

- (void)testMatchesIfSubjectMatchesAndNoRelativeMatcher {
    BranchMatcher *branchMatcher = [BranchMatcher matcherWithSubjectMatcher:[IdentityMatcher matcherWithView:middle]];

    assertThat(branchMatcher, [MatchesView view:middle]);
}

- (void)testMatchesIfSubjectMatchesAndRelativeMatches {
    BranchMatcher *branchMatcher= [BranchMatcher matcherWithSubjectMatcher:[IdentityMatcher matcherWithView:middle]];
    [branchMatcher appendCombinator:[ChildCombinator new] matcher:[IdentityMatcher matcherWithView:leaf]];

    assertThat(branchMatcher, [MatchesView view:middle]);
}

- (void)testMismatchesIfSubjectMismatchesAndRelativeMatches {
    BranchMatcher *branchMatcher = [BranchMatcher matcherWithSubjectMatcher:[IdentityMatcher matcherWithView:middle]];
    [branchMatcher appendCombinator:[ChildCombinator new] matcher:[FalseMatcher new]];

    assertThat(branchMatcher, isNot([MatchesView view:middle]));
}

@end
