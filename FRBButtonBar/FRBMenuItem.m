//
//  FRBMenuItem.m
//  FRBButtonBar
//
//  Created by Rob Peck on 12/22/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import "FRBMenuItem.h"

@implementation FRBMenuItem

@synthesize representedItem;

- (void)setRepresentedItem:(FRBButtonBarItem *)_representedItem
{
    representedItem = _representedItem;
    
    if ([[representedItem children] count] > 0) {
        NSMenu *contextMenu = [self generateMenu:[representedItem children]];
        [self setSubmenu:contextMenu];
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
            [menuItem setTarget:[self target]];
            [menuItem setAction:[self action]];
        }
        
        [contextMenu addItem:menuItem];
    }
    
    return contextMenu;
}

@end
