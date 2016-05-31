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
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"https://speakerdeck.com/p/featured"] MIMEType:@"ttext/html; charset=utf-8" expectedContentLength:31657 textEncodingName:@"utf-8"];
    
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
    
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL URLWithString:@"https://speakerdeck.com/p/design"] MIMEType:@"ttext/html; charset=utf-8" expectedContentLength:31657 textEncodingName:@"utf-8"];
    
    NSArray<SpeakerDeckPresentation *> *presentations = (NSArray *)[serializer responseObjectForResponse:response data:htmlData error:nil];

    XCTAssertTrue([presentations[0].title isEqualToString:@"À la poursuite de l'utile - Design & Human - Geoffrey Dorne"]);
    XCTAssertTrue([presentations[3].title isEqualToString:@"制作側とユーザーの温度差、そしてペルソナのズレ-プロゲーマーと高校生から学んだ例-"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
