//
//  MasterViewController.m
//  Deck
//
//  Created by Marijn van der Werf on 24-05-16.
//  Copyright © 2016 Marijn van der Werf. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "PresentationCell.h"
#import <AFNetworking.h>
#import "SpeakderDeckResponseSerialization.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MasterViewController ()

@property NSMutableArray<SpeakerDeckPresentation *> *objects;
@property NSIndexPath *selectedItem;
@end

@implementation MasterViewController

float _columnWidth;
float _rowHeight;
float _gutter = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://speakerdeck.com/p/featured"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    manager.responseSerializer = [[SpeakderDeckResponseSerialization alloc] init];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            [_objects addObjectsFromArray:responseObject];
            [self.collectionView reloadData];
        }
    }];
    [dataTask resume];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    float screenWidth = [self.view bounds].size.width;
    _columnWidth = (screenWidth - _gutter) / 2;
    _columnWidth = floorf(_columnWidth);
    _columnWidth = MIN(_columnWidth, 210);
    
    _rowHeight = floorf(_columnWidth / 4 * 3);
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        SpeakerDeckPresentation *presentation = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        [controller setPresentation:presentation];
    }
}

#pragma mark - Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PresentationCell *cell = (PresentationCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if([indexPath isEqual:self.selectedItem]) {
        cell.overlayView.hidden = NO;
    } else {
        cell.overlayView.hidden = YES;
    }

    SpeakerDeckPresentation *presentation = self.objects[indexPath.row];
    
    UIImageView *imageView = cell.imageView;
    [imageView sd_setImageWithURL:[presentation thumbnailForSlide:0]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SpeakerDeckPresentation *presentation = self.objects[indexPath.item];
    if (presentation.aspectRatio != nil) {
        [self performSegueWithIdentifier:@"showDetail" sender:indexPath];
    }

    // Remove selection from previous cell
    if (self.selectedItem != nil) {
        PresentationCell *cell = (PresentationCell *)[collectionView cellForItemAtIndexPath:self.selectedItem];
        if (cell != nil) {
            cell.overlayView.hidden = YES;
        }
    }

    self.selectedItem = indexPath;
    PresentationCell *cell = (PresentationCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell != nil) {
        cell.overlayView.hidden = NO;
    }

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:presentation.url];
    
    manager.responseSerializer = [[SpeakderDeckResponseSerialization alloc] init];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        
        SpeakerDeckPresentation *responsePresentation = (SpeakerDeckPresentation *)responseObject;
        SpeakerDeckPresentation *selectedPresentation = self.objects[indexPath.item];
        selectedPresentation.aspectRatio = responsePresentation.aspectRatio;
        selectedPresentation.descriptionText = responsePresentation.descriptionText;
        [self performSegueWithIdentifier:@"showDetail" sender:self.selectedItem];
    }];
    [dataTask resume];
    
}

#pragma mark - Collection View Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_columnWidth, _rowHeight);
}

@end
