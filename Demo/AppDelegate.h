//
//  AppDelegate.h
//  BFConnectionWire
//
//  Created by Balázs Faludi on 24.08.12.
//  Copyright (c) 2012 Balázs Faludi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BFConnectionWire.h"

@interface AppDelegate : NSResponder <NSApplicationDelegate, BFConnectionWireDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic) BFConnectionWire *wire;

@property (weak) IBOutlet NSTextField *coatWidthTextField;
@property (weak) IBOutlet NSTextField *wireWidthTextField;
@property (weak) IBOutlet NSTextField *pinRadiusTextField;
@property (weak) IBOutlet NSColorWell *wireColorTextField;
@property (weak) IBOutlet NSColorWell *coatColorTextField;
@property (weak) IBOutlet NSColorWell *shadowColorWell;
@property (weak) IBOutlet NSTextField *shadowRadiusTextField;
@property (weak) IBOutlet NSTextField *shadowOffsetXTextField;
@property (weak) IBOutlet NSTextField *shadowOffsetYTextField;

- (IBAction)wireWidthChanged:(id)sender;
- (IBAction)coatWidthChanged:(id)sender;
- (IBAction)pinRadiusChanged:(id)sender;
- (IBAction)wireColorChanged:(id)sender;
- (IBAction)coatColorChanged:(id)sender;
- (IBAction)shadowColorChanged:(id)sender;
- (IBAction)shadowRadiusChanged:(id)sender;
- (IBAction)shadowOffsetChanged:(id)sender;

@end
