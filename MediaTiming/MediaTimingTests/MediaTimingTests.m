//
//  mediaTimingTests.m
//  mediaTimingTests
//
//  Created by Kevin Doughty on 3/30/14.
//  Copyright (c) 2014 Kevin Doughty. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <QuartzCore/QuartzCore.h>

@interface mediaTimingTests : XCTestCase
-(void)testMediaTiming;
@end

@implementation mediaTimingTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
/*
 - (void)testExample
 {
 XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
 }
 */
-(void)testMediaTiming {
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CFTimeInterval start = CACurrentMediaTime();
    CALayer *layer = [CALayer layer];
    NSUInteger index = 9999;
    while (index--) {
        CALayer *sublayer = [CALayer layer];
        [layer addSublayer:sublayer];
        layer = sublayer;
    }
    CFTimeInterval end = CACurrentMediaTime();
    XCTAssertEqual(start, end, @"should CACurrentMediaTime() always return the same value in a transaction grouping?");
    [CATransaction commit];
}
@end
