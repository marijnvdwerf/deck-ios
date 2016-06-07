//
//  DetailViewController.m
//  Deck
//
//  Created by Marijn van der Werf on 24-05-16.
//  Copyright © 2016 Marijn van der Werf. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController () <UICollectionViewDelegateFlowLayout>

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
    
    self.navigationBar.shadowImage = [UIImage alloc];
    [self.navigationBar setBackgroundImage:[UIImage alloc] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat lineFragmentPadding = self.descriptionTextView.textContainer.lineFragmentPadding;
    self.descriptionTextView.textContainerInset = UIEdgeInsetsMake(0, 5 - lineFragmentPadding, 0, 5 - lineFragmentPadding);
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

#pragma mark - Collection View Delegate Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.slideWidthPlaceholderView.bounds.size.width, self.slideWidthPlaceholderView.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    float insets = (self.view.bounds.size.width - self.slideWidthPlaceholderView.bounds.size.width) / 2;
    return UIEdgeInsetsMake(0, insets, 0, insets);
}

#pragma mark - Scroll View Delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    float slideWidth = self.slideWidthPlaceholderView.bounds.size.width + 4;
    float targetSlide = targetContentOffset->x / slideWidth;
    int roundedSlide = round(targetSlide);
    
    targetContentOffset->x = roundedSlide * slideWidth;
}

- (IBAction)doneAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
