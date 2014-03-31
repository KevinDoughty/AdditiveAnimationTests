AdditiveAnimationTests
======================

## AdditiveOpacity
rdar://problem/15316223
Presentation layer opacity value is reported as correct but is not rendered properly.
More than one concurrent animation will jump between 0 and 1.
Worked in 10.5.
This one is killing me.


## AdditiveBounds
rdar://problem/12085417
Additive animation of NSRect gives absolute values for width and height struct values. 
Workaround is a CAAnimationGroup containing NSSize and NSPoint animations.
Worked in 10.5.

## AdditiveRotationY
rdar://problem/12088301
Additive animation of transform.rotation.y does not perform the same as transform.rotation.x and transform.rotation.z
Closed as "expected issue with the euler angle rotations." Recommend value functions do not work with additive at all.
Worked in 10.5.

## Additive SceneKit
rdar://problem/16094510
Additive rotation animation with CATransform3DMakeRotation broken in 10.9. 
Worked in 10.8: http://youtu.be/M-8_9vjJbKs?t=56s


## transformScale
rdar://problem/16468506
Additive animation of transform.scale.x and transform.scale.y (key value coding extensions) 
to a value of 3 cause visual errors that are not present if you animate to a value of 2.  
If 3, one or the other will fail, depending on the order the animations were added.

rdar://problem/16468554
An additive transform animation made using CATransform3DMakeScale animates differently than expected. 
Black square transform animation should match white crop mark size animation.

## FlashOfUnanimatedContent
rdar://problem/12081774
It seems animations don't start when expected.
Red flashing means failure. 
Workaround is kCAFillModeBackward.
Is this what causes Safari flickering? 
http://jsfiddle.net/R6UW5/1/

## Media Timing
rdar://problem/12081774
A guess at the cause of the flash of unanimated content.
Unit test shows CACurrentMediaTime does not always return the same value in a CATransaction group. 
I don't know if this is a bug or expected behavior.
Maybe animation starting and property value changes aren't happening at the same time.



