#import "InstanceParser.h"
#import "SubjectChainParser.h"
#import "IgorQueryStringScanner.h"
#import "DescendantCombinator.h"
#import "SubjectMatcher.h"
#import "CombinatorMatcher.h"
#import "CombinatorParser.h"

@implementation SubjectChainParser {
    id <IgorQueryScanner> scanner;
    NSArray *combinatorParsers;
}

@synthesize subjectParsers;

+ (SubjectChainParser *)parserWithSubjectParsers:(NSArray *)subjectParsers combinatorParsers:(NSArray *)combinatorParsers {
    return [[self alloc] initWithSubjectParsers:subjectParsers combinatorParsers:combinatorParsers];
}

+ (SubjectChainParser *)parserWithCombinatorParsers:(NSArray *)combinatorParsers {
    return [self parserWithSubjectParsers:[NSArray array] combinatorParsers:combinatorParsers];
}

- (SubjectChainParser *)initWithSubjectParsers:(NSArray *)theSubjectParsers combinatorParsers:(NSArray *)theCombinatorParsers {
    if (self = [super init]) {
        subjectParsers = theSubjectParsers;
        combinatorParsers = theCombinatorParsers;
    }
    return self;
}

- (id <SubjectMatcher>)parseSubjectMatcher {
    for (id <SubjectPatternParser>parser in subjectParsers) {
        id <SubjectMatcher> matcher = [parser parseSubjectMatcher];
        if (matcher) return matcher;
    }
    return nil;
}

- (id <Combinator>)parseCombinator {
    for (id <CombinatorParser>parser in combinatorParsers) {
        id <Combinator> combinator = [parser parseCombinator];
        if (combinator) return combinator;
    }
    return nil;
}

- (SubjectChain *)parseOneSubject {
    id <SubjectMatcher> matcher = [self parseSubjectMatcher];
    id <Combinator> combinator = nil;
    if (matcher) {
        combinator = [self parseCombinator];
    }
    return [SubjectChain stateWithMatcher:matcher combinator:combinator];
}

- (SubjectChain *)parseSubjectChain {
    SubjectChain *collected = [self parseOneSubject];
    SubjectChain *step = [self parseOneSubject];
    while(step.started) {
        id <SubjectMatcher> matcher = [CombinatorMatcher matcherWithSubjectMatcher:step.matcher combinator:collected.combinator relativeMatcher:collected.matcher];
        collected = [SubjectChain stateWithMatcher:matcher combinator:step.combinator];
        if (step.done) return collected;
        step = [self parseOneSubject];
    }
    return collected;
}

@end
