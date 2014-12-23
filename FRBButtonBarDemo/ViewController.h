//
//  ViewController.h
//  FRBButtonBarDemo
//
//  Created by Rob Peck on 12/19/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "FRBButtonBar.h"

@interface ViewController : NSViewController <FRBButtonBarControlDataSource, FRBButtonBarControlDelegate> {
    NSMutableArray *bookmarks;
}

@property (weak) IBOutlet FRBButtonBarControl *buttonBar;
@property (weak) IBOutlet WebView *theWebView;

@end

