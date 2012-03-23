
#import "IgorParser.h"
#import "IgorParserException.h"
#import "Matcher.h"
#import "SubjectPattern.h"
#import "SubjectSubtreeMatcher.h"

@implementation IgorParser

-(Matcher*) parse:(NSString*)pattern {
    NSScanner *scanner = [self scannerForPattern:pattern];
    Matcher* matcher = [self parseScanner:scanner];
    [self throwIfNotAtEndOfScanner:scanner];
    return matcher;
}

-(Matcher*) parseScanner:(NSScanner*)scanner {
    SubjectPattern* subjectParser = [SubjectPattern new];
    Matcher* matcher = [subjectParser parse:scanner];
    if([scanner scanString:@"!" intoString:nil]) {
        Matcher* subtreeMatcher = [subjectParser parse:scanner];
        matcher = [SubjectSubtreeMatcher withSubjectMatcher:matcher subtreeMatcher:subtreeMatcher];
    }
    return matcher;
}

-(NSScanner*) scannerForPattern:(NSString*)pattern {
    NSString* stripped = [pattern stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSScanner* scanner = [NSScanner scannerWithString:stripped];
    [scanner setCharactersToBeSkipped:nil];
    return scanner;
}

-(void) throwIfNotAtEndOfScanner:(NSScanner*)scanner {
    if(![scanner isAtEnd]) {
        NSString* badCharacters;
        [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&badCharacters];
        NSString* reason = [NSString stringWithFormat:@"Unexpected characters %@", badCharacters];
        @throw [IgorParserException exceptionWithReason:reason scanner:scanner];
    }
}

@end
