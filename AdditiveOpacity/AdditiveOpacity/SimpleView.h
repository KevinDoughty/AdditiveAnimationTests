//
//  SimpleView.h
//  AdditiveOpacity
//
//  Created by Kevin Doughty on 4/7/11.
//  Copyright 2011 Kevin Doughty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface SimpleView : NSView {
    CATextLayer *main;
	CALayer *gauge;
    CALayer *marker;
}

-(IBAction)testOpacity:(id)sender;

@end
