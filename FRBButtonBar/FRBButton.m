//
//  FRBButton.m
//  FRBButtonBar
//
//  Created by Rebecca Peck on 12/3/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import "FRBButton.h"
#import "FRBButtonBarControl.h"
#import "FRBMenuItem.h"
#import "NSImage+Tint.h"

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
    [button setImage:[self image]];
    [button setShowsBorderOnlyWhileMouseInside:NO];
    return button;
}

- (void)setup
{
    [self setButtonType:NSMomentaryPushInButton];
    [self setBezelStyle:NSRecessedBezelStyle];
    [self setBordered:YES];
    [self setFocusRingType:NSFocusRingTypeNone];
    [self setShowsBorderOnlyWhileMouseInside:YES];
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
        
        NSString *filePath = [[NSBundle bundleForClass:[FRBButton class]] pathForResource:@"DownArrow" ofType:@"pdf"];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        NSImage *normalImage = [[NSImage alloc] initWithData:imageData];
        [normalImage setTemplate:YES];
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

@end
