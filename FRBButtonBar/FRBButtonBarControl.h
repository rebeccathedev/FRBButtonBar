//
//  FRBButtonBarControl.h
//  FRBButtonBar
//
//  Created by Rob Peck on 12/17/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FRBButtonBarProtocols.h"
#import "FRBMenuItem.h"

@interface FRBButtonBarControl : NSControl <FRBButtonBarMenuItemDelegate> {
    NSButton *moreButton;
    NSMenu *moreMenu;
}

@property (nonatomic, weak) IBOutlet id <FRBButtonBarControlDelegate> delegate;
@property (nonatomic, weak) IBOutlet id <FRBButtonBarControlDataSource> dataSource;
@property NSFont *font;

/**
 *  Causes the button bar control to clear it's items and reload from the data
 *  source.
 */
- (void)reloadItems;

@end
