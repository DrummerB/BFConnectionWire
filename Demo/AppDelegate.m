//
//  AppDelegate.m
//  BFConnectionWire
//
//  Created by Balázs Faludi on 24.08.12.
//  Copyright (c) 2012 Balázs Faludi. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
	
	[_window.contentView setNextResponder:self];
	
	CGPoint startPoint = [self.window convertBaseToScreen:CGPointMake(50, 50)];
	CGPoint endPoint = [self.window convertBaseToScreen:CGPointMake(self.window.frame.size.width - 50, 50)];
	_wire = [[BFConnectionWire alloc] initWithStartPoint:startPoint endPoint:endPoint];
	[_wire.window setParentWindow:self.window];
	[_wire.window setLevel:self.window.level];
	[_wire show];
	
	_wireColorTextField.color = _wire.wireColor;
	_coatColorTextField.color = _wire.coatColor;
	_shadowColorWell.color = _wire.shadowColor;
}

- (void)startConnectionWire {
	BFConnectionWire *wire = [[BFConnectionWire alloc] initAtMouseLocation];
	wire.followMouse = YES;
	wire.wireWidth = [_wireWidthTextField floatValue];
	wire.coatWidth = [_coatWidthTextField floatValue];
	wire.pinRadius = [_pinRadiusTextField floatValue];
	wire.wireColor = [_wireColorTextField color];
	wire.coatColor = [_coatColorTextField color];
	wire.shadowColor = [_shadowColorWell color];
	wire.shadowBlurRadius = [_shadowRadiusTextField floatValue];
	wire.shadowOffset = CGSizeMake([_shadowOffsetXTextField floatValue], [_shadowOffsetYTextField floatValue]);
	wire.delegate = self;
	[wire show];
}

- (void)mouseDown:(NSEvent *)theEvent {
	[self startConnectionWire];
	NSLog(@"Left mouse down. Created wire.");
}

- (void)rightMouseDown:(NSEvent *)theEvent {
	[self startConnectionWire];
	NSLog(@"Right mouse down. Created wire.");
}

- (void)connectionWireMoved:(BFConnectionWire *)wire {
//	NSLog(@"Connection wire moved to %@", NSStringFromPoint(wire.endPoint));
}

- (void)connectionWireFinished:(BFConnectionWire *)wire {
	NSLog(@"Connection wire ended at %@", NSStringFromPoint(wire.endPoint));
}

- (IBAction)wireWidthChanged:(id)sender {
	_wire.wireWidth = [sender floatValue];
}

- (IBAction)coatWidthChanged:(id)sender {
	_wire.coatWidth = [sender floatValue];
}

- (IBAction)pinRadiusChanged:(id)sender {
	_wire.pinRadius = [sender floatValue];
}

- (IBAction)wireColorChanged:(id)sender {
	_wire.wireColor = [sender color];
}

- (IBAction)coatColorChanged:(id)sender {
	_wire.coatColor = [sender color];
}

- (IBAction)shadowColorChanged:(id)sender {
	_wire.shadowColor = [sender color];
}

- (IBAction)shadowRadiusChanged:(id)sender {
	_wire.shadowBlurRadius = [sender floatValue];
}

- (IBAction)shadowOffsetChanged:(id)sender {
	_wire.shadowOffset = CGSizeMake([_shadowOffsetXTextField floatValue], [_shadowOffsetYTextField floatValue]);
}

@end
