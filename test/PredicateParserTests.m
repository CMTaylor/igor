#import "PredicateParser.h"
#import "StringQueryScanner.h"
#import "IsPredicateMatcher.h"

@interface PredicateParserTests : SenTestCase
@end

@implementation PredicateParserTests {
    id <QueryScanner> scanner;
    id <PatternParser> parser;
}

- (void)setUp {
    scanner = [StringQueryScanner scanner];
    parser = [PredicateParser parserWithScanner:scanner];
}

- (void)testParsesAPredicateBetweenBrackets {
    NSString *expression = @"pearlBailey='opreylady'";
    [scanner setQuery:[NSString stringWithFormat:@"[%@]", expression]];

    assertThat([parser parseMatcher], [IsPredicateMatcher forExpression:expression]);
}

- (void)testIgnoresBracketWithinStringsInPredicate {
    NSString *expression = @"myProperty='bracket: ]'";
    [scanner setQuery:[NSString stringWithFormat:@"[%@]", expression]];

    assertThat([parser parseMatcher], [IsPredicateMatcher forExpression:expression]);
}

- (void)testIgnoresConsecutiveBracketsWithinStringsInPredicate {
    NSString *expression = @"myProperty='brackets: ]]]]]'";
    [scanner setQuery:[NSString stringWithFormat:@"[%@]", expression]];

    assertThat([parser parseMatcher], [IsPredicateMatcher forExpression:expression]);
}

- (void)testDeliversNoMatcherIfNoLeftBracket {
    [scanner setQuery:@"no left bracket"];

    assertThat([parser parseMatcher], is(nilValue()));
}

- (void)testThrowsIfNoPredicateBetweenBrackets {
    [scanner setQuery:@"[]"];

    STAssertThrowsSpecificNamed([parser parseMatcher], NSException, @"IgorParserException", @"Expected IgorParserException");
}

- (void)testThrowsIfNoRightBracket {
    [scanner setQuery:@"[royClark='pickin'"];

    STAssertThrowsSpecificNamed([parser parseMatcher], NSException, @"IgorParserException", @"Expected IgorParserException");
}

@end
