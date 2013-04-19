//
//  BFConnectionWireView.m
//  BFConnectionWire
//
//  Created by Balázs Faludi on 25.08.12.
//  Copyright (c) 2012 Balázs Faludi. All rights reserved.
//

#import "BFConnectionWireView.h"
#import "BFConnectionWire.h"

static inline CGRect CGRectMakeAtCenter(CGPoint center, CGSize size) {
	return CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
}

@implementation BFConnectionWireView

- (void)drawRect:(NSRect)dirtyRect {
	
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
	//// Color Declarations
	NSColor* wireColor = self.wire.wireColor;
	NSColor* coatColor = self.wire.coatColor;
	NSColor* shadowColor = self.wire.shadowColor;
	
	//// Abstracted Graphic Attributes
	CGPoint startPoint = [self convertPoint:[self.wire.window convertScreenToBase:self.wire.startPoint] fromView:nil];
	CGPoint endPoint = [self convertPoint:[self.wire.window convertScreenToBase:self.wire.endPoint] fromView:nil];
	
	CGSize pinSize = CGSizeMake(self.wire.pinRadius * 2, self.wire.pinRadius * 2);
	CGSize pinCoatSize = CGSizeMake(self.wire.pinRadius * 2 + self.wire.coatWidth, self.wire.pinRadius * 2 + self.wire.coatWidth);
	
	NSRect startPinCoatOvalRect = CGRectMakeAtCenter(startPoint, pinCoatSize);
	NSRect endPinCoatOvalRect = CGRectMakeAtCenter(endPoint, pinCoatSize);
	
	NSRect startPinWireOvalRect = CGRectMakeAtCenter(startPoint, pinSize);
	NSRect endPinWireOvalRect = CGRectMakeAtCenter(endPoint, pinSize);
	
	CGFloat coatLineStrokeWidth = + self.wire.wireWidth + self.wire.coatWidth;
	CGFloat wireLineStrokeWidth = self.wire.wireWidth;
	
	CGSize shadowOffset = self.wire.shadowOffset;
	CGFloat shadowRadius = self.wire.shadowBlurRadius;
	
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowRadius, shadowColor.CGColor);
	
	//// Start Pin Coat Oval Drawing
	NSBezierPath* startPinCoatOvalPath = [NSBezierPath bezierPathWithOvalInRect: startPinCoatOvalRect];
	[coatColor setFill];
	[startPinCoatOvalPath fill];
	
	//// End Pin Coat Oval Drawing
	NSBezierPath* endPinCoatOvalPath = [NSBezierPath bezierPathWithOvalInRect: endPinCoatOvalRect];
	[coatColor setFill];
	[endPinCoatOvalPath fill];
	
	//// Coat Line Drawing
	NSBezierPath* coatLinePath = [NSBezierPath bezierPath];
	[coatLinePath moveToPoint:startPoint];
	[coatLinePath lineToPoint:endPoint];
	[coatColor setStroke];
	[coatLinePath setLineWidth: coatLineStrokeWidth];
	[coatLinePath stroke];
	
	//// Start Pin Wire Oval Drawing
	NSBezierPath* startPinWireOvalPath = [NSBezierPath bezierPathWithOvalInRect: startPinWireOvalRect];
	[wireColor setFill];
	[startPinWireOvalPath fill];
	
	//// End Pin Wire Oval Drawing
	NSBezierPath* endPinWireOvalPath = [NSBezierPath bezierPathWithOvalInRect: endPinWireOvalRect];
	[wireColor setFill];
	[endPinWireOvalPath fill];
	
	//// Wire Line Drawing
	NSBezierPath* wireLinePath = [NSBezierPath bezierPath];
	[wireLinePath moveToPoint:startPoint];
	[wireLinePath lineToPoint:endPoint];
	[wireColor setStroke];
	[wireLinePath setLineWidth: wireLineStrokeWidth];
	[wireLinePath stroke];
	

}

@end
