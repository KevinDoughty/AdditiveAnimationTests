//
//  SimpleView.h
//  Simple Additive
//
//  Created by Kevin Doughty on 4/7/11.
//  Copyright 2011 Kevin Doughty. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface SimpleView : NSView {
    CATextLayer *main;
}
-(IBAction)flipX:(id)sender;
-(IBAction)flipY:(id)sender;
-(IBAction)flipZ:(id)sender;

@end
