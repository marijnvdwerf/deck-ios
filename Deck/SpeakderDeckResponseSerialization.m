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
    
    NSArray<HTMLElement *> * talkElements = [document querySelectorAll:@".talks .talk"];
    
    NSMutableArray *decks = [[NSMutableArray alloc] initWithCapacity:talkElements.count];
    
    [talkElements enumerateObjectsUsingBlock:^(HTMLElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [decks addObject:[[SpeakerDeckPresentation alloc] initWithHTMLElement: obj]];
        
    }];
    
    return [[NSArray alloc] initWithArray:decks];
}

@end
