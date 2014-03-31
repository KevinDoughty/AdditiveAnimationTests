//
//  KxDxView.m
//  transformScale
//
//  Created by Kevin Doughty on 3/30/14.
//  Copyright (c) 2014 Kevin Doughty. All rights reserved.
//

#import "KxDxView.h"
#import <QuartzCore/QuartzCore.h>

@interface KxDxView ()
@property (weak) CALayer *square;
@property (weak) CALayer *xMark;
@property (weak) CALayer *yMark;
@end

@implementation KxDxView

-(void) awakeFromNib {
    self.layer = [CALayer layer];
	self.wantsLayer = YES;
    
    CALayer *square = [CALayer layer];
    CALayer *xMark = [CALayer layer];
    CALayer *yMark = [CALayer layer];
    
	square.zPosition = -1;
    xMark.zPosition = -1;
    yMark.zPosition = -1;
    
    CGColorRef bgColor = CGColorCreateGenericRGB(0, 0, 0, 1);
    square.backgroundColor = bgColor;
	CGColorRelease(bgColor);
	
    CGColorRef whiteColor = CGColorCreateGenericRGB(1, 1, 1, 1);
    xMark.backgroundColor = whiteColor;
	yMark.backgroundColor = whiteColor;
	CGColorRelease(whiteColor);
    
	[self.layer addSublayer:xMark];
    [self.layer addSublayer:yMark];
    [self.layer addSublayer:square];
	
    self.xMark = xMark;
    self.yMark = yMark;
    self.square = square;
    
    [self layoutLayers];
}

-(void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    [self layoutLayers];
}

-(void)layoutLayers {
    CGFloat d = MIN(self.bounds.size.width,self.bounds.size.height) / 6;
    [CATransaction setDisableActions:YES];
    CGPoint center = CGPointMake(self.layer.bounds.size.width/2, self.layer.bounds.size.height/2);
    self.square.position = center;
	self.square.bounds = CGRectMake(0, 0, d, d);
    self.xMark.position = center;
	self.xMark.bounds = CGRectMake(0, 0, self.layer.bounds.size.width, d);
    self.yMark.position = center;
	self.yMark.bounds = CGRectMake(0, 0, d, self.layer.bounds.size.height);
}

-(void)mouseDown:(NSEvent*)theEvent {
    CGFloat scale = 2;
    NSInteger index = [self.radio selectedRow];
    if (index < 4) {
        if (index == 1 || index == 3) scale = 3;
        [self scaleAnimateLayer:self.square from:1 to:scale];
    } else {
        [self transformAnimateLayer:self.square to:CATransform3DMakeScale(scale,scale,1)];
    }
    
    CGFloat dimension = self.square.bounds.size.width;
    [self sizeAnimateLayer:self.xMark to:NSMakeSize(self.layer.bounds.size.width, dimension * scale)];
    [self sizeAnimateLayer:self.yMark to:NSMakeSize(dimension * scale, self.layer.bounds.size.height)];
}

-(void)mouseUp:(NSEvent*)theEvent {
    CGFloat scale = 2;
	NSInteger index = [self.radio selectedRow];
    if (index < 4) {
        if (index == 1 || index == 3) scale = 3;
        [self scaleAnimateLayer:self.square from:scale to:1];
    } else {
        [self transformAnimateLayer:self.square to:CATransform3DIdentity];
    }
    
    CGFloat dimension = self.square.bounds.size.width;
    [self sizeAnimateLayer:self.xMark to:NSMakeSize(self.layer.bounds.size.width, dimension)];
    [self sizeAnimateLayer:self.yMark to:NSMakeSize(dimension, self.layer.bounds.size.height)];
}

-(CABasicAnimation *)additiveAnimationWithKeyPath:(NSString*)keyPath {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
	BOOL shiftKeyDown = ([[[NSApplication sharedApplication] currentEvent] modifierFlags] & NSShiftKeyMask)!=0;
	animation.duration = (shiftKeyDown) ? 5.0 : 1.0;
	if ([self.check state] == NSOnState) animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :0.0 :0.5 :1.0f];
	animation.additive = YES;
    animation.fillMode = kCAFillModeBoth;
	return animation;
}

-(void)scaleAnimateLayer:(CALayer*)theLayer from:(CGFloat)from to:(CGFloat)to {
	CABasicAnimation *xAnimation = [self additiveAnimationWithKeyPath:@"transform.scale.x"];
	xAnimation.fromValue = @(from-to);
    xAnimation.toValue = @(0);
	
    CABasicAnimation *yAnimation = [self additiveAnimationWithKeyPath:@"transform.scale.y"];
	yAnimation.fromValue = @(from-to);
    yAnimation.toValue = @(0);
    
	[CATransaction begin];
	[CATransaction setValue: (id)kCFBooleanTrue forKey: kCATransactionDisableActions];
	
    NSInteger index = [self.radio selectedRow];
    if (index == 0 || index == 1) {
        [theLayer addAnimation:yAnimation forKey:nil]; // order matters, error if scale is 3 instead of 2
        [theLayer addAnimation:xAnimation forKey:nil]; // order matters, error if scale is 3 instead of 2
    } else if (index == 2 || index == 3) {
        [theLayer addAnimation:xAnimation forKey:nil]; // order matters, error if scale is 3 instead of 2
        [theLayer addAnimation:yAnimation forKey:nil]; // order matters, error if scale is 3 instead of 2
    }
    theLayer.transform = CATransform3DMakeScale(to, to, 1);
    
	[CATransaction commit];
}

-(void)transformAnimateLayer:(CALayer*)theLayer to:(CATransform3D)theTransform {
	CABasicAnimation *transformAnimation = [self additiveAnimationWithKeyPath:@"transform"];
	transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(theLayer.transform,CATransform3DInvert(theTransform))];
	transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	
	[CATransaction begin];
	[CATransaction setValue: (id)kCFBooleanTrue forKey: kCATransactionDisableActions];
	
	theLayer.transform = theTransform;
	[theLayer addAnimation:transformAnimation forKey:nil]; // error on rapid click
	
	[CATransaction commit];
}

-(void)sizeAnimateLayer:(CALayer*)theLayer to:(CGSize)theSize { // works as expected
	
	CABasicAnimation *boundsAnimation = [self additiveAnimationWithKeyPath:@"bounds.size"];
	
	boundsAnimation.fromValue = [NSValue valueWithSize:NSMakeSize(theLayer.bounds.size.width - theSize.width, theLayer.bounds.size.height - theSize.height)];
	boundsAnimation.toValue = [NSValue valueWithSize:NSZeroSize];
	
	[CATransaction begin];
	[CATransaction setValue: (id)kCFBooleanTrue forKey: kCATransactionDisableActions];
	
	theLayer.bounds = CGRectMake(0,0,theSize.width,theSize.height);
	[theLayer addAnimation:boundsAnimation forKey:nil];
	
	[CATransaction commit];
}


@end
