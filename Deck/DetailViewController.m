//
//  DetailViewController.m
//  Deck
//
//  Created by Marijn van der Werf on 24-05-16.
//  Copyright © 2016 Marijn van der Werf. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(SpeakerDeckPresentation *)presentation {
    if (_presentation != presentation) {
        _presentation = presentation;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.presentation) {
        self.titleLabel.text = self.presentation.title;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    [self.descriptionTextView setTextContainerInset:UIEdgeInsetsMake(0, 16, 0, 16)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.presentation) {
        return self.presentation.slideCount;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"presentationDetailSlide" forIndexPath:indexPath];
    
    UIImageView *imageView = ((UIImageView *)[cell viewWithTag:2]);
    NSURL *slideURL = [self.presentation originalImageForSlide:indexPath.item];
    [imageView sd_setImageWithURL:slideURL];
    
    return cell;
}

@end
