//
//  MasterViewController.h
//  Deck
//
//  Created by Marijn van der Werf on 24-05-16.
//  Copyright © 2016 Marijn van der Werf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

