//
//  NSImage+Tint.m
//  FRBButtonBar
//
//  Created by Rob Peck on 12/22/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import "NSImage+Tint.h"

@implementation NSImage (Tint)

- (NSImage *)imageTintedWithColor:(NSColor *)tint
{
    NSImage *image = [self copy];
    if (tint) {
        [image lockFocus];
        [tint set];
        NSRect imageRect = {NSZeroPoint, [image size]};
        NSRectFillUsingOperation(imageRect, NSCompositeSourceAtop);
        [image unlockFocus];
    }
    return image;
}

@end
