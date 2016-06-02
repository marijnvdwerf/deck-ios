//
//  MasterViewController.m
//  Deck
//
//  Created by Marijn van der Werf on 24-05-16.
//  Copyright © 2016 Marijn van der Werf. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <AFNetworking.h>
#import "SpeakderDeckResponseSerialization.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MasterViewController ()

@property NSMutableArray<SpeakerDeckPresentation *> *objects;
@end

@implementation MasterViewController

float _columnWidth;

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

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    float screenWidth = [self.view bounds].size.width;
    _columnWidth = (screenWidth - 1) / 2;
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
        NSIndexPath *indexPath = [self.collectionView indexPathForSelectedRow];
        SpeakerDeckPresentation *presentation = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:presentation.title];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    SpeakerDeckPresentation *presentation = self.objects[indexPath.row];
    
    UIImageView *imageView = ((UIImageView *)[cell viewWithTag:2]);
    [imageView sd_setImageWithURL:[presentation thumbnailForSlide:0]];
    ((UITextView *)[cell viewWithTag:1]).text = presentation.title;
    return cell;
}

#pragma mark - Collection View Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_columnWidth, _columnWidth / 4 * 3);
}

@end
