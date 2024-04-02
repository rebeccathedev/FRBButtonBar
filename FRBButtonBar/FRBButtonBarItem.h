//
//  FRBButtonBarItem.h
//  FRBButtonBar
//
//  Created by Rebecca Peck on 12/3/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRBButtonBarItem : NSObject {
    NSMutableArray *children;
}

@property (strong) NSString *title;

/**
 *  Adds a child FRBButtonBarItem to this item.
 *
 *  @param child An instance of FRBButtonBarItem or a subclass
 */
- (void)addChild:(FRBButtonBarItem*)child;

/**
 *  Removes a child.
 *
 *  @param child An instance of FRBButtonBarItem or a subclass
 */
- (void)removeChild:(FRBButtonBarItem*)child;

/**
 *  Adds an array of FRBButtonBarItems.
 *
 *  @param childrenArray An array of FRBButtonBarItems (or a subclass)
 */
- (void)addChildren:(NSArray*)childrenArray;

/**
 *  Removes all children.
 */
- (void)removeAllChildren;

/**
 *  Returns an array of all children of this item
 *
 *  @return NSArray
 */
- (NSArray*)children;

@end
