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
    CGFloat xMin = CGRectGetMinX(rect);
    CGFloat xMax = CGRectGetMaxX(rect);
    
    CGFloat yMin = CGRectGetMinY(rect);
    CGFloat yMax = CGRectGetMaxY(rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Can't use [UIColor whiteColor] because it uses the wrong colour space.
    CGContextSetStrokeColor(context, CGColorGetComponents([UIColor colorWithRed:1 green:1 blue:1 alpha:0.18].CGColor));
    CGContextStrokeRectWithWidth(context, rect, 1);
}

@end
