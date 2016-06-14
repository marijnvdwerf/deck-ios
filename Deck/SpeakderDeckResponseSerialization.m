//
//  SpeakderDeckResponseSerialization.m
//  Deck
//
//  Created by Marijn van der Werf on 24-05-16.
//  Copyright © 2016 Marijn van der Werf. All rights reserved.
//

#import "SpeakderDeckResponseSerialization.h"
#import <HTMLKit.h>

@implementation SpeakderDeckResponseSerialization



#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error {
    NSString * htmlString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    HTMLDocument *document = [HTMLDocument documentWithString:htmlString];
    
    NSArray<NSString *> *pathComponents = response.URL.pathComponents;
    
    if (pathComponents.count == 3) {
        // First component is a forward slash
        if ([pathComponents[1] isEqualToString:@"p"] || [pathComponents[1] isEqualToString:@"c"]) {
            // overview page
            return [self parseOverviewPage:document];
        }
        
        return [self parseDetailPage:document];
    }
        
    return nil;
}
    
- (NSArray<SpeakerDeckPresentation *> *)parseOverviewPage:(HTMLDocument *)document {
    NSArray<HTMLElement *> * talkElements = [document querySelectorAll:@".talks .talk"];
    
    NSMutableArray *decks = [[NSMutableArray alloc] initWithCapacity:talkElements.count];
    
    [talkElements enumerateObjectsUsingBlock:^(HTMLElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [decks addObject:[[SpeakerDeckPresentation alloc] initWithHTMLElement: obj]];
        
    }];
    
    return [[NSArray alloc] initWithArray:decks];
}

- (SpeakerDeckPresentation *)parseDetailPage:(HTMLDocument *)document {
    SpeakerDeckPresentation *presentation = [[SpeakerDeckPresentation alloc] init];
    
    HTMLElement *embedElement = [document querySelector:@".speakerdeck-embed"];
    presentation.aspectRatio = [NSNumber numberWithFloat:[[embedElement.attributes valueForKey:@"data-ratio"] floatValue]];
    presentation.identifier = [embedElement.attributes valueForKey:@"data-id"];
    
    HTMLElement *talkDetailsElement = [document querySelector:@"#talk-details"];
    presentation.title = [talkDetailsElement querySelector:@"h1"].textContent;
    
    HTMLElement *descriptionElement = [talkDetailsElement querySelector:@".description"];
    NSMutableArray<NSString *> *paragraphs = [[NSMutableArray alloc] initWithCapacity:descriptionElement.childElementsCount];
    
    [descriptionElement enumerateChildElementsUsingBlock:^(HTMLElement * _Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
        assert([element.tagName isEqualToStringIgnoringCase:@"p"]);
        
        NSMutableString *paragraph = [[NSMutableString alloc] init];
        
        [element enumerateChildNodesUsingBlock:^(HTMLNode * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
            if (node.nodeType == HTMLNodeText) {
                [paragraph appendString:[node.textContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                return;
            }
            
            if (node.nodeType == HTMLNodeElement) {
                HTMLElement *element = (HTMLElement *)node;
                if ([element.tagName isEqualToStringIgnoringCase:@"br"]) {
                    // Line Separator
                    [paragraph appendString:@"\u2028"];
                    return;
                }
            }
            
            NSLog(@"Unknown element");
            [paragraph appendString:node.textContent];
            //assert(false);
        }];
        
        [paragraphs addObject:[paragraph stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }];
    
    // Paragraph Separator
    presentation.descriptionText = [paragraphs componentsJoinedByString:@"\u2029"];
    
    return presentation;
}

@end
