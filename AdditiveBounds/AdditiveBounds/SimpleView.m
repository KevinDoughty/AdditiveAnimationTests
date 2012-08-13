//
//  SimpleView.m
//  AdditiveBounds
//
//  Created by Kevin Doughty on 4/7/11.
//  Copyright 2011 Kevin Doughty. All rights reserved.
//

#import "SimpleView.h"


@implementation SimpleView


-(void) awakeFromNib {
	self.layer = [CALayer layer];
	self.wantsLayer = YES;
	
    large = 200;
    small = 50;
    
	main = [CALayer layer];
    main.position = CGPointMake(self.layer.bounds.size.width/2.0, large);
	main.bounds = CGRectMake(0,0,large,large);
	main.cornerRadius = large / 10.0;
    main.borderWidth = large / 20.0;
	CGColorRef bgColor = CGColorCreateGenericRGB(0, 0, 0, 1);
    main.backgroundColor = bgColor;
	
    CGFloat red = (random() % 256) / 256.0;
    CGFloat green =  (random() % 256) / 256.0;
    CGFloat blue =  (random() % 256) / 256.0;
    CGColorRef backgroundColorRef = CGColorCreateGenericRGB(red,green,blue,1);
    main.backgroundColor = backgroundColorRef;
    CGColorRelease(backgroundColorRef);
    
    CGColorRef borderColorRef = CGColorCreateGenericRGB(1-red,1-green,1-blue,1);
    main.borderColor = borderColorRef;
    CGColorRelease(borderColorRef);
    
	[self.layer addSublayer:main];
}

-(BOOL) isFlipped {
    return YES;
}

-(CABasicAnimation*)additiveAnimationWithKeyPath:(NSString*)theKeyPath {
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:theKeyPath];
    theAnimation.additive = YES;
    theAnimation.duration = ([[[NSApplication sharedApplication] currentEvent] modifierFlags] & NSShiftKeyMask) ? 5.0 : 1.0;
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :0 :.5 :1];
    return theAnimation;
}

-(IBAction)testRect:(id)sender {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGRect largeRect = CGRectMake(0,0,large,large);
    CGRect smallRect = CGRectMake(0,0,small,small);
    CGRect old, new;
    if (main.bounds.size.width == large) {
        old = largeRect;
        new = smallRect;
    } else {
        old = smallRect;
        new = largeRect;
    }
    
    CABasicAnimation *theAnimation = [self additiveAnimationWithKeyPath:@"bounds"];
    theAnimation.fromValue = [NSValue valueWithRect:NSMakeRect(old.origin.x-new.origin.x, old.origin.y-new.origin.y, old.size.width-new.size.width, old.size.height-new.size.height)];
    theAnimation.toValue = [NSValue valueWithRect:NSZeroRect];
    main.bounds = new;
    [main addAnimation:theAnimation forKey:nil];
    
    [CATransaction commit];
}

-(IBAction)testSize:(id)sender {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGSize largeSize = CGSizeMake(large,large);
    CGSize smallSize = CGSizeMake(small,small);
    CGSize old, new;
    if (main.bounds.size.width == large) {
        old = largeSize;
        new = smallSize;
    } else {
        old = smallSize;
        new = largeSize;
    }
    
    CABasicAnimation *theAnimation = [self additiveAnimationWithKeyPath:@"bounds.size"];
    theAnimation.fromValue = [NSValue valueWithSize:NSMakeSize(old.width-new.width, old.height-new.height)];
    theAnimation.toValue = [NSValue valueWithSize:NSZeroSize];
    main.bounds = CGRectMake(0,0,new.width,new.height);
    [main addAnimation:theAnimation forKey:nil];
    
    [CATransaction commit];
}

@end
