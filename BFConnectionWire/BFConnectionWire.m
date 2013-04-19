//
//  BFConnectionWire.m
//  BFConnectionWire
//
//  Created by Balázs Faludi on 24.08.12.
//  Copyright (c) 2012 Balázs Faludi. All rights reserved.
//

#import "BFConnectionWire.h"
#import "BFConnectionWireView.h"


@interface BFConnectionWire ()

@property (nonatomic, readwrite) NSWindow *window;
@property (nonatomic) BFConnectionWireView *wireView;
@property (nonatomic) CFMachPortRef eventTap;
@property (nonatomic) CFRunLoopSourceRef runLoopSource;

- (void)mouseDragObserved;
- (void)mouseUpObserved;

@end

static NSMutableArray *wires;

@implementation BFConnectionWire

+ (void)initialize {
	wires = [[NSMutableArray alloc] init];
}

- (id)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    self = [super init];
    if (self) {
		NSRect rect = NSMakeRect(0.0f, 0.0f, 1.0f, 1.0f);
		_window = [[NSWindow alloc] initWithContentRect:rect
											  styleMask:NSBorderlessWindowMask
												backing:NSBackingStoreBuffered
												  defer:YES];
		_window.hasShadow = NO;
		_window.backgroundColor = [NSColor clearColor];
		_window.level = NSScreenSaverWindowLevel;
		[_window setOpaque:NO];
		[_window setIgnoresMouseEvents:YES];
		[_window setReleasedWhenClosed:NO];
		
		_wireWidth = 2.0f;
		_coatWidth = 2.0f;
		_pinRadius = 2.0f;
		_shadowBlurRadius = 3.0f;
		_shadowOffset = CGSizeMake(0.0f, -2.0f);
		_startPoint = startPoint;
		_endPoint = endPoint;
		_shown = NO;
		
		_wireColor = [NSColor colorWithCalibratedRed: 0.17 green: 0.64 blue: 1 alpha: 1];
		_wireColor = [_wireColor colorWithAlphaComponent: 0.7];
		_coatColor = [NSColor whiteColor];
		_shadowColor = [NSColor colorWithCalibratedRed:0.5 green:0.5 blue:0.5 alpha:0.6];
		
		_wireView = [[BFConnectionWireView alloc] initWithFrame:rect];
		_wireView.wire = self;
		_wireView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
		[_window.contentView addSubview:_wireView];
    }
    return self;
}

- (id)initAtMouseLocation
{
	CGPoint location = [NSEvent mouseLocation];
    return [self initWithStartPoint:location endPoint:location];
}

- (void)dealloc {
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), _runLoopSource, kCFRunLoopCommonModes);
	CFRelease(_runLoopSource);
	CFRelease(_eventTap);
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (BOOL)becomeFirstResponder {
	return YES;
}

#pragma mark - Layout & Display

- (void)show {
	if (!_shown) {
		[wires addObject:self];
		[self redraw];
		[_window orderFront:self];
		_shown = YES;
	}
}

- (void)close {
	if (_shown) {
		[_window close];
		[wires removeObject:self];
		// the wire will be release after this
	}
}

- (CGRect)requiredFrame {
	CGFloat leftEdge = MIN(self.startPoint.x, self.endPoint.x) - self.pinRadius - self.coatWidth;
	if (self.shadowOffset.width < 0) leftEdge += self.shadowOffset.width;
	CGFloat bottomEdge = MIN(self.startPoint.y, self.endPoint.y) - self.pinRadius - self.coatWidth;
	if (self.shadowOffset.height < 0) bottomEdge += self.shadowOffset.height;
	CGFloat rightEdge = MAX(self.startPoint.x, self.endPoint.x) + self.pinRadius + self.coatWidth;
	if (self.shadowOffset.width > 0) rightEdge += self.shadowOffset.width;
	CGFloat topEdge = MAX(self.startPoint.y, self.endPoint.y) + self.pinRadius + self.coatWidth;
	if (self.shadowOffset.height > 0) topEdge += self.shadowOffset.height;
	CGRect rect = CGRectMake(leftEdge, bottomEdge, rightEdge - leftEdge, topEdge - bottomEdge);
	return rect;
}

- (void)redraw {
	CGRect frame = [self requiredFrame];
	[_window setFrame:frame display:YES];
	[_wireView setNeedsDisplay:YES];
}

#pragma mark - Setters

- (void)setStartPoint:(CGPoint)startPoint {
	_startPoint = startPoint;
	[self redraw];
}

- (void)setEndPoint:(CGPoint)endPoint {
	_endPoint = endPoint;
	[self redraw];
}

- (void)setPinRadius:(CGFloat)pinRadius {
	_pinRadius = pinRadius;
	[self redraw];
}

- (void)setWireWidth:(CGFloat)wireWidth {
	_wireWidth = wireWidth;
	[self redraw];
}

- (void)setCoatWidth:(CGFloat)coatWidth {
	_coatWidth = coatWidth;
	[self redraw];
}

- (void)setWireColor:(NSColor *)wireColor {
	_wireColor = wireColor;
	[self redraw];
}

- (void)setCoatColor:(NSColor *)coatColor {
	_coatColor = coatColor;
	[self redraw];
}

- (void)setShadowColor:(NSColor *)shadowColor {
	_shadowColor = shadowColor;
	[self redraw];
}
- (void)setShadowBlurRadius:(CGFloat)shadowBlurRadius {
	_shadowBlurRadius = shadowBlurRadius;
	[self redraw];
}

- (void)setShadowOffset:(CGSize)shadowOffset {
	_shadowOffset = shadowOffset;
	[self redraw];
}

- (void)setFollowMouse:(BOOL)followMouse {
	_followMouse = followMouse;
	if (_followMouse) {
		if (!_eventTap) {
			CGEventMask eventMask = CGEventMaskBit(kCGEventLeftMouseDragged) |
									CGEventMaskBit(kCGEventRightMouseDragged) |
									CGEventMaskBit(kCGEventLeftMouseUp) |
									CGEventMaskBit(kCGEventRightMouseUp);
			_eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 1, eventMask, mouseEventCallback, (__bridge void *)(self));
			_runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, _eventTap, 0);
			CFRunLoopAddSource(CFRunLoopGetCurrent(), _runLoopSource, kCFRunLoopCommonModes);
		}
		CGEventTapEnable(_eventTap, true);
	} else {
		if (_eventTap) {
			CGEventTapEnable(_eventTap, false);
		}
	}
}

#pragma mark - Events

- (void)mouseDragObserved {
	CGPoint location = [NSEvent mouseLocation];
	self.endPoint = location;
	if ([_delegate respondsToSelector:@selector(connectionWireMoved:)]) {
		[_delegate connectionWireMoved:self];
	}
}

- (void)mouseUpObserved {
	if ([_delegate respondsToSelector:@selector(connectionWireFinished:)]) {
		[_delegate connectionWireFinished:self];
	}
	[self close];
}

CGEventRef mouseEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
	BFConnectionWire *wire = (__bridge BFConnectionWire *)refcon;
	if (CGEventMaskBit(type) & CGEventMaskBit(kCGEventLeftMouseUp) ||
		CGEventMaskBit(type) & CGEventMaskBit(kCGEventRightMouseUp)) {
		CGEventTapEnable(wire.eventTap, false);
		[wire mouseUpObserved];
	}
	if (CGEventMaskBit(type) & CGEventMaskBit(kCGEventLeftMouseDragged) ||
		CGEventMaskBit(type) & CGEventMaskBit(kCGEventRightMouseDragged)) {
		[wire mouseDragObserved];
	}
    return event;
}

@end
