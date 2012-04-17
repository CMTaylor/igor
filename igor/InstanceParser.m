#import "ClassParser.h"
#import "InstanceMatcher.h"
#import "InstanceParser.h"

@implementation InstanceParser {
    NSArray *simplePatternParsers;
}

- (id <SubjectPatternParser>)initWithSimplePatternParsers:(NSArray *)theSimplePatternParsers {
    self = [super init];
    if (self) {
        simplePatternParsers = [NSArray arrayWithArray:theSimplePatternParsers];
    }
    return self;
}

- (id <Matcher>)parseSimpleMatcher {
    for (id <SimplePatternParser> parser in simplePatternParsers) {
        id <Matcher> matcher = [parser parseMatcher];
        if (matcher) return matcher;
    }
    return nil;
}

- (id <Matcher>)parseMatcher {
    id <Matcher> matcher = [self parseSimpleMatcher];

    if (!matcher) return nil;

    NSMutableArray *simpleMatchers = [NSMutableArray array];
    while(matcher) {
        [simpleMatchers addObject:matcher];
        matcher = [self parseSimpleMatcher];
    }
    return [InstanceMatcher matcherWithSimpleMatchers:simpleMatchers];
}

+ (id <SubjectPatternParser>)parserWithSimplePatternParsers:(NSArray *)simplePatternParsers {
    return [[self alloc] initWithSimplePatternParsers:simplePatternParsers];
}

@end
