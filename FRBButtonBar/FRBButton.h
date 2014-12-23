//
//  FRBButton.h
//  FRBButtonBar
//
//  Created by Rob Peck on 12/3/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FRBButtonBarItem.h"
#import "FRBMenuItem.h"

@interface FRBButton : NSButton <NSCopying, NSMenuDelegate, FRBButtonBarMenuItemDelegate>

@property (nonatomic, weak) FRBButtonBarItem *representedItem;

@end
