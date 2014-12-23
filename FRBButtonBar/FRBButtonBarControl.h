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

/**
 *  A delegate that implements the FRBButtonBarControlDelegate protocol.
 */
@property (nonatomic, weak) IBOutlet id <FRBButtonBarControlDelegate> delegate;

/**
 *  A data source that implements the FRBButtonBarControlDataSource protocol.
 */
@property (nonatomic, weak) IBOutlet id <FRBButtonBarControlDataSource> dataSource;

/**
 *  Font properties that are applied to the buttons on the button bar.
 */
@property NSFont *font;

/**
 *  Causes the button bar control to clear it's items and reload from the data
 *  source.
 */
- (void)reloadItems;

@end
