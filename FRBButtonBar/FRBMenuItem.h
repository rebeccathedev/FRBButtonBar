//
//  FRBMenuItem.h
//  FRBButtonBar
//
//  Created by Rebecca Peck on 12/22/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FRBButtonBarItem.h"

@protocol FRBButtonBarMenuItemDelegate <NSObject>

- (void)selectMenuItem:(id)sender;

@end

@interface FRBMenuItem : NSMenuItem

@property (nonatomic, weak) FRBButtonBarItem *representedItem;

@end
