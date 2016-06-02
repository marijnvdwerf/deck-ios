//
//  MJWSpeakerdeckPresentation.h
//  Deck
//
//  Created by Marijn van der Werf on 31-05-16.
//  Copyright © 2016 Marijn van der Werf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTMLKit.h>

@interface SpeakerDeckPresentation : NSObject
@property NSString *identifier;
@property int slideCount;
@property NSString *title;
@property NSURL *url;

- (NSURL *)thumbnailForSlide: (int) slide;
- (NSURL *)originalImageForSlide: (int) slide;

- (id)initWithHTMLElement:(HTMLElement *)element;
@end
