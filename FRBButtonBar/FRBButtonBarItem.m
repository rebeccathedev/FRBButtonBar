//
//  FRBButtonBarItem.m
//  FRBButtonBar
//
//  Created by Rebecca Peck on 12/3/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import "FRBButtonBarItem.h"

@implementation FRBButtonBarItem

@synthesize title;

- (id)init
{
    if (self == [super init]) {
        children = [NSMutableArray new];
    }
    
    return self;
}

- (void)addChildren:(NSArray*)childrenArray
{
    [children addObjectsFromArray:childrenArray];
}

- (void)addChild:(FRBButtonBarItem*)child
{
    [children addObject:child];
}

- (void)removeChild:(FRBButtonBarItem *)child
{
    [children removeObject:child];
}

- (void)removeAllChildren
{
    [children removeAllObjects];
}

- (NSArray*)children
{
    return children;
}

@end
