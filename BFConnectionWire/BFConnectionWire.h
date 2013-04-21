//
//  BFConnectionWire.h
//  BFConnectionWire
//
//  Created by Balázs Faludi on 24.08.12.
//  Copyright (c) 2012 Balázs Faludi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol BFConnectionWireDelegate;


@interface BFConnectionWire : NSObject

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

@property (nonatomic, readonly) NSWindow *window;
@property (nonatomic) BOOL shown;

@property (nonatomic) BOOL followMouse;

@property (nonatomic) CGFloat wireWidth;
@property (nonatomic) CGFloat coatWidth;
@property (nonatomic) CGFloat pinRadius;

@property (nonatomic) NSColor *wireColor;
@property (nonatomic) NSColor *coatColor;

@property (nonatomic) NSColor *shadowColor;
@property (nonatomic) CGFloat shadowBlurRadius;
@property (nonatomic) CGSize shadowOffset;

@property (nonatomic) NSObject<BFConnectionWireDelegate> *delegate;

- (id)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
- (id)initAtMouseLocation;

- (void)show;

@end


@protocol BFConnectionWireDelegate <NSObject>

- (void)connectionWireMoved:(BFConnectionWire *)wire;
- (void)connectionWireFinished:(BFConnectionWire *)wire;

@end