//
//  MJWSpeakerdeckPresentation.m
//  Deck
//
//  Created by Marijn van der Werf on 31-05-16.
//  Copyright © 2016 Marijn van der Werf. All rights reserved.
//

#import "SpeakerDeckPresentation.h"

@interface SpeakerDeckPresentation ()
@property NSURL *_thumbnailURL;
@end

@implementation SpeakerDeckPresentation


- (id)initWithHTMLElement:(HTMLElement *)element
{
    self = [super init];
    if (self) {
        self.identifier = [element.attributes valueForKey:@"data-id"];
        self.slideCount = [[element.attributes valueForKey:@"data-slide-count"] intValue];
        self.url = [[NSURL alloc] initWithString:[[element querySelector:@".title a"].attributes valueForKey:@"href"] relativeToURL:[NSURL URLWithString:@"https://speakerdeck.com/"]];
        self.title = [element querySelector:@".title a"].textContent;
        self._thumbnailURL =[NSURL URLWithString:[[[element querySelector:@"img"].attributes valueForKey:@"src"] stringByReplacingOccurrencesOfString:@"/thumb_slide_0.jpg" withString:@"/"]];
    }
    
    return self;
}

- (NSURL *)thumbnailForSlide: (int) slide
{
    return [[NSURL alloc] initWithString:[NSString stringWithFormat:@"thumb_slide_%d.jpg", slide] relativeToURL:__thumbnailURL];
}

- (NSURL *)originalImageForSlide: (int) slide
{
    return [[NSURL alloc] initWithString:[NSString stringWithFormat:@"slide_%d.jpg", slide] relativeToURL:__thumbnailURL];
}

@end
