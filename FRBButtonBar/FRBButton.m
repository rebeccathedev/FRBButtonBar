//
//  FRBButton.m
//  FRBButtonBar
//
//  Created by Rob Peck on 12/3/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import "FRBButton.h"
#import "FRBButtonBarControl.h"
#import "FRBMenuItem.h"
#import "NSImage+Tint.h"

@interface FRBButton ()

@property(nonatomic, strong) NSTrackingArea *trackingArea;

@end

@implementation FRBButton

@synthesize representedItem;

- (instancetype)init
{
    if (self == [super init]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    FRBButton *button = [[FRBButton allocWithZone:zone] initWithFrame:self.frame];
    [button setTitle:[self title]];
    [button setFont:[self font]];
    [button setImage:overImage];
    [button setShowsBorderOnlyWhileMouseInside:NO];
    [button removeTrackingArea:[button trackingArea]];
    return button;
}

- (void)setup
{
    [self setButtonType:NSMomentaryLightButton];
    [self setBezelStyle:NSRecessedBezelStyle];
    [self setBordered:YES];
    [self setFocusRingType:NSFocusRingTypeNone];
    [self setShowsBorderOnlyWhileMouseInside:YES];
    [self setButtonType:NSMomentaryLightButton];
    [self setImagePosition:NSImageRight];
    [self.cell sendActionOn:NSLeftMouseDownMask | NSPeriodicMask];
    [self setContinuous:YES];
}

- (void)setRepresentedItem:(FRBButtonBarItem *)_representedItem
{
    representedItem = _representedItem;
    
    if ([[representedItem children] count] > 0) {
        NSMenu *contextMenu = [self generateMenu:[representedItem children]];
        [contextMenu setDelegate:self];
        [self setMenu:contextMenu];
        
        // We only need to worry about tracking if we actually have a content
        // menu. This is so that we can swap the images around when the user
        // mouses over.
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveInActiveApp;
        focusTrackingAreaOptions |= NSTrackingMouseEnteredAndExited;
        focusTrackingAreaOptions |= NSTrackingAssumeInside;
        focusTrackingAreaOptions |= NSTrackingInVisibleRect;
        
        _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:_trackingArea];
        
        NSString *filePath = [[NSBundle bundleForClass:[FRBButton class]] pathForResource:@"DownArrow" ofType:@"pdf"];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        normalImage = [[NSImage alloc] initWithData:imageData];
        overImage = [normalImage imageTintedWithColor:[NSColor selectedMenuItemTextColor]];
        filePath = nil;
        imageData = nil;
        
        [self setImage:normalImage];
    }
}

- (NSMenu*)generateMenu:(NSArray*)childItems
{
    NSMenu *contextMenu = [NSMenu new];
    for (FRBButtonBarItem *item in childItems) {
        FRBMenuItem *menuItem = [FRBMenuItem new];
        [menuItem setTitle:[item title]];
        [menuItem setRepresentedItem:item];
        
        if ([[item children] count] > 0) {
            [menuItem setSubmenu:[self generateMenu:[item children]]];
        } else {
            [menuItem setTarget:self];
            [menuItem setAction:@selector(selectMenuItem:)];
        }
        
        [contextMenu addItem:menuItem];
    }
    
    return contextMenu;
}

- (void)menuDidClose:(NSMenu *)menu
{
    [self setHighlighted:NO];
    [self setShowsBorderOnlyWhileMouseInside:YES];
    [self setState:NSOffState];
}

- (void)selectMenuItem:(id)sender
{
    [self setHighlighted:NO];
    [self setShowsBorderOnlyWhileMouseInside:YES];
    [self setState:NSOffState];
    [[self target] selectMenuItem:sender];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [self setHighlighted:YES];
    [self setShowsBorderOnlyWhileMouseInside:NO];
    [super mouseDown:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [self setHighlighted:NO];
    [self setShowsBorderOnlyWhileMouseInside:YES];
    [super mouseUp:theEvent];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [self setImage:overImage];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [self setImage:normalImage];
}

@end
