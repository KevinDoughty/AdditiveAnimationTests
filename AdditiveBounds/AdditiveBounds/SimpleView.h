//
//  SimpleView.h
//  AdditiveBounds
//
//  Created by Kevin Doughty on 4/7/11.
//  Copyright 2011 Kevin Doughty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface SimpleView : NSView {
    CALayer *main;
    CGFloat large;
    CGFloat small;
}
-(IBAction)testRect:(id)sender;
-(IBAction)testSize:(id)sender;

@end
