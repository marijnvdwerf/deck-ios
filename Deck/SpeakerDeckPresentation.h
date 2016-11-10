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
@property NSString *descriptionText;
@property NSURL *url;
@property NSNumber *aspectRatio;
@property NSString *speakerName;
@property NSURL *speakerURL;
@property NSString *categoryName;
@property NSDate *publishDate;

- (NSURL *)thumbnailForSlide: (int) slide;
- (NSURL *)originalImageForSlide: (int) slide;

- (id)initWithHTMLElement:(HTMLElement *)element;
@end
