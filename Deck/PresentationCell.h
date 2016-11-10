//
//  PresentationCell.h
//  Deck
//
//  Created by Marijn van der Werf on 08-11-16.
//  Copyright © 2016 Marijn van der Werf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentationCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
