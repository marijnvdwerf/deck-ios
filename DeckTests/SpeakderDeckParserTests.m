//
//  DeckTests.m
//  DeckTests
//
//  Created by Marijn van der Werf on 30-05-16.
//  Copyright © 2016 Marijn van der Werf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SpeakderDeckResponseSerialization.h"

@interface DeckTests : XCTestCase

@end

@implementation DeckTests

SpeakderDeckResponseSerialization *serializer;

- (void)setUp {
    [super setUp];
    
    serializer = [[SpeakderDeckResponseSerialization alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIndexParsing {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Resources/featured" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:path];
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"https://speakerdeck.com/p/featured"] MIMEType:@"text/html; charset=utf-8" expectedContentLength:31657 textEncodingName:@"utf-8"];
    
    NSObject *data = [serializer responseObjectForResponse:response data:htmlData error:nil];
    
    XCTAssertTrue([data isKindOfClass:[NSArray class]]);
    
    NSArray *dataArray = (NSArray*)data;
    
    XCTAssertEqual(dataArray.count, 15);
    
    XCTAssertTrue([dataArray[0] isKindOfClass:[SpeakerDeckPresentation class]]);
    SpeakerDeckPresentation *firstPresentation = dataArray[0];
    
    XCTAssertTrue([firstPresentation.identifier isEqualToString:@"1f957e89563b440d96c16986507b790f"]);
    XCTAssertTrue([firstPresentation.title isEqualToString:@"Fight the Zombie Pattern Library - RWD Summit 2016"]);
    XCTAssertEqual(firstPresentation.slideCount, 134);
    XCTAssertTrue([firstPresentation.url.absoluteString isEqualToString:@"https://speakerdeck.com/marcelosomers/fight-the-zombie-pattern-library-rwd-summit-2016"]);
}

- (void)testSpecialCharacterIndexParsing {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Resources/design" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:path];
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"https://speakerdeck.com/p/design"] MIMEType:@"text/html; charset=utf-8" expectedContentLength:31657 textEncodingName:@"utf-8"];
    
    NSArray<SpeakerDeckPresentation *> *presentations = (NSArray *)[serializer responseObjectForResponse:response data:htmlData error:nil];

    XCTAssertTrue([presentations[0].title isEqualToString:@"À la poursuite de l'utile - Design & Human - Geoffrey Dorne"]);
    XCTAssertTrue([presentations[3].title isEqualToString:@"制作側とユーザーの温度差、そしてペルソナのズレ-プロゲーマーと高校生から学んだ例-"]);
}

#define NSParagraphSeparatorCharacter @"\u2029"
#define NSLineSeparatorCharacter      @"\u2028"

- (void)testDetailPageParsing {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Resources/raster-shaders-on-commodore-64" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:path];
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"https://speakerdeck.com/mehowte/raster-shaders-on-commodore-64"] MIMEType:@"text/html; charset=utf-8" expectedContentLength:31657 textEncodingName:@"utf-8"];
    
    NSObject *data = [serializer responseObjectForResponse:response data:htmlData error:nil];
    
    XCTAssertTrue([data isKindOfClass:[SpeakerDeckPresentation class]]);
    SpeakerDeckPresentation *presentation = (SpeakerDeckPresentation *)data;
    
    XCTAssertTrue([presentation.identifier isEqualToString:@"0d8bcfaa7d1f41aa89acba64b08c1066"]);
    XCTAssertTrue([presentation.aspectRatio isEqualToNumber:[NSNumber numberWithFloat:1.33333333333333]]);
    XCTAssertTrue([presentation.title isEqualToString:@"'Raster Shaders' on Commodore 64"]);
                   
    NSArray<NSString *> *description = @[
        @"Video cards can execute small programs whenever a pixel is displayed on screen.",
        NSLineSeparatorCharacter,
        @"Commodore 64 can execute small programs whenever a raster line is displayed on TV.",
        NSParagraphSeparatorCharacter,
        @"Pixel shaders can be used to create realistic lighting, special effects and even compute physics!",
        NSLineSeparatorCharacter,
        @"‘Raster shaders’ can be used to split screen, display more sprites and even play sound!"
    ];
    XCTAssertTrue([presentation.descriptionText isEqualToString:[description componentsJoinedByString:@""]]);
}

- (void)testDetailPageParsing2 {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Resources/fight-the-zombie-pattern-library-rwd-summit-2016" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:path];
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"https://speakerdeck.com/marcelosomers/fight-the-zombie-pattern-library-rwd-summit-2016"] MIMEType:@"text/html; charset=utf-8" expectedContentLength:28045 textEncodingName:@"utf-8"];
    
    NSObject *data = [serializer responseObjectForResponse:response data:htmlData error:nil];
    
    XCTAssertTrue([data isKindOfClass:[SpeakerDeckPresentation class]]);
    SpeakerDeckPresentation *presentation = (SpeakerDeckPresentation *)data;
    
    XCTAssertTrue([presentation.identifier isEqualToString:@"1f957e89563b440d96c16986507b790f"]);
    XCTAssertTrue([presentation.aspectRatio isEqualToNumber:[NSNumber numberWithFloat:1.33333333333333]]);
    XCTAssertTrue([presentation.title isEqualToString:@"Fight the Zombie Pattern Library - RWD Summit 2016"]);
    
    NSArray<NSString *> *description = @[
        @"In \"Fight the Zombie Pattern Library,\" presented at the Responsive Web Design Summit in 2016, we look at repeatable processes to implement Pattern Libraries in your product design and development workflow, so you can fight the slow rot of your interface design (and its underlying code) as your product grows and evolves.",
        NSParagraphSeparatorCharacter,
        @"These same processes can be used to \"build a tiny Bootstrap\" for every client and keep developers using them every day.",
        NSParagraphSeparatorCharacter,
        @"We also look at PatternPack (http://patternpack.org/), an open source tool for designing and building your interface, and then sharing the code. For more on getting started with PatternPack, check out the guides and resources (https://github.com/patternpack/patternpack/blob/master/docs/docs.md)"
    ];
    XCTAssertTrue([presentation.descriptionText isEqualToString:[description componentsJoinedByString:@""]]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
