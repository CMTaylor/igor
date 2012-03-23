#import "PredicateMatcher.h"
#import "PredicatePattern.h"
#import "PatternScanner.h"

@interface PredicateParserTests : SenTestCase
@end

@implementation PredicateParserTests

- (void)testReturnsTruePredicateIfNoLeftBracket {
    NSString *noLeadingLeftBracket = @"+notAPropertySelector+";
    PatternScanner *scanner = [PatternScanner withPattern:noLeadingLeftBracket];
    PredicatePattern *parser = [PredicatePattern forScanner:scanner];
    PredicateMatcher *matcher = [parser parse];
    expect([matcher matchExpression]).toEqual(@"TRUEPREDICATE");
}

- (void)testThrowsIfNoPredicate {
    NSString *noPropertyName = @"[]";
    PatternScanner *scanner = [PatternScanner withPattern:noPropertyName];
    PredicatePattern *parser = [PredicatePattern forScanner:scanner];
    STAssertThrowsSpecificNamed([parser parse], NSException, @"IgorParserException", @"Expected IgorParserException");
}

- (void)testParsesAPredicate {
    NSString *propertyEqualsPattern = @"[pearlBailey='opreylady']";
    PatternScanner *scanner = [PatternScanner withPattern:propertyEqualsPattern];
    PredicatePattern *parser = [PredicatePattern forScanner:scanner];
    PredicateMatcher *matcher = [parser parse];
    expect(matcher).toBeInstanceOf([PredicateMatcher class]);
    expect(matcher.matchExpression).toEqual(@"pearlBailey == \"opreylady\"");
}

- (void)testThrowsIfNoRightBracket {
    NSString *noTrailingRightBracket = @"[royClark='pickin'";
    PatternScanner *scanner = [PatternScanner withPattern:noTrailingRightBracket];
    PredicatePattern *parser = [PredicatePattern forScanner:scanner];
    STAssertThrowsSpecificNamed([parser parse], NSException, @"IgorParserException", @"Expected IgorParserException");
}

@end
