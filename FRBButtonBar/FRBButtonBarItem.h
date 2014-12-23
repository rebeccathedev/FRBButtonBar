//
//  FRBButtonBarItem.h
//  FRBButtonBar
//
//  Created by Rob Peck on 12/3/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRBButtonBarItem : NSObject {
    NSMutableArray *children;
}

@property (strong) NSString *title;

- (void)addChild:(FRBButtonBarItem*)child;
- (void)removeChild:(FRBButtonBarItem*)child;
- (void)removeAllChildren;
- (NSArray*)children;

@end
