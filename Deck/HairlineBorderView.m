//
//  HairlineBorderView.m
//  Deck
//
//  Created by Marijn van der Werf on 07-06-16.
//  Copyright © 2016 Marijn van der Werf. All rights reserved.
//

#import "HairlineBorderView.h"

@implementation HairlineBorderView

- (void)drawRect:(CGRect)rect {
    float pixelSize = 1 / self.window.screen.scale;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Can't use [UIColor whiteColor] because it uses the wrong colour space.
    CGContextSetStrokeColor(context, CGColorGetComponents([UIColor colorWithRed:1 green:1 blue:1 alpha:0.18].CGColor));
    CGContextStrokeRectWithWidth(context, rect, pixelSize * 2);
}

@end
