//
//  FRBButtonBarProtocols.h
//  FRBButtonBar
//
//  Created by Rob Peck on 12/17/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//  Portions of this code are based on KPCTabsControl, which is Copyright (c)
//  2014 @onekiloparsec (Cédric Foellmi). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRBButtonBarControl;
@class FRBButtonBarItem;

@protocol FRBButtonBarControlDataSource <NSObject>

/**
 *  Returns the number of buttons in the button bar (the count of the first level).
 *
 *  @param buttonBarControl The button bar
 *
 *  @return A number indicating the number of items
 */
- (NSUInteger)buttonBarNumberOfButtons:(FRBButtonBarControl *)buttonBarControl;

/**
 *  Returns the item at the specified index
 *
 *  @param buttonBarControl The button bar control
 *  @param index            The index
 *
 *  @return An instance of FRBButtonBarItem or a subclass thereof.
 */
- (FRBButtonBarItem*)buttonBarControl:(FRBButtonBarControl *)buttonBarControl itemAtIndex:(NSUInteger)index;

@end

@protocol FRBButtonBarControlDelegate <NSObject>

/**
 *  Called when a user clicks on an item, either a menu or a button.
 *
 *  @param buttonBarControl The button bar
 *  @param item             The item clicked on
 */
- (void)buttonBarControl:(FRBButtonBarControl *)buttonBarControl didClickItem:(FRBButtonBarItem*)item;

@optional

/**
 *  Called when a user reorders the items. The delegate is responsible for 
 *  storing the proper order, so the delegate should now store the reordered 
 *  array of items.
 *
 *  @param buttonBarControl The button bar
 *  @param itemArray        A reordered array of items.
 */
- (void)buttonBarControl:(FRBButtonBarControl *)buttonBarControl didReorderItems:(NSArray *)itemArray;

@end