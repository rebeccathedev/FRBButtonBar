//
//  ContainerView.m
//  FRBButtonBar
//
//  Created by Rob Peck on 12/23/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import "ContainerView.h"

@implementation ContainerView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSGradient *gradient = [[NSGradient alloc] initWithColors:@[[NSColor colorWithDeviceWhite:180. / 0xff alpha:1],
                                         [NSColor colorWithDeviceWhite:195. / 0xff alpha:1],
                                         [NSColor colorWithDeviceWhite:210. / 0xff alpha:1]]
                           atLocations:(const CGFloat[]){0.0, 0.25, 0.5, 1.0}
                            colorSpace:[NSColorSpace deviceRGBColorSpace]];
    

    [gradient drawInRect:dirtyRect angle:90];
}

@end
