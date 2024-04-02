//
//  ViewController.m
//  FRBButtonBarDemo
//
//  Created by Rebecca Peck on 12/19/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//

#import "ViewController.h"
#import "Bookmark.h"

@implementation ViewController

@synthesize theWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *loadedBookmarks = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bookmarks" ofType:@"plist"]];

    bookmarks = [NSMutableArray arrayWithArray:[self loadBookmarks:loadedBookmarks]];
    
    [_buttonBar setDataSource:self];
    [_buttonBar setDelegate:self];
    [_buttonBar setFont:[NSFont boldSystemFontOfSize:[NSFont smallSystemFontSize]]];
    
    NSURL*url=[NSURL URLWithString:@"http://www.google.com"];
    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    [[theWebView mainFrame] loadRequest:request];
}

- (NSArray*)loadBookmarks:(NSArray*)_bookmarks
{
    NSMutableArray *ret = [NSMutableArray new];
    for (NSDictionary *dict in _bookmarks) {
        Bookmark *b = [Bookmark new];
        [b setTitle:dict[@"title"]];
        [b setUrl:dict[@"url"]];
        
        if (dict[@"children"] != nil) {
            NSArray *retur = [self loadBookmarks:dict[@"children"]];
            for (Bookmark *childB in retur) {
                [b addChild:childB];
            }
        }
        
        [ret addObject:b];
    }
    
    return ret;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (NSUInteger)buttonBarNumberOfButtons:(FRBButtonBarControl *)buttonBarControl
{
    return [bookmarks count];
}

- (id)buttonBarControl:(FRBButtonBarControl *)buttonBarControl itemAtIndex:(NSUInteger)index
{
    return [bookmarks objectAtIndex:index];
}

- (void)buttonBarControl:(FRBButtonBarControl *)buttonBarControl didReorderItems:(NSArray *)itemArray
{
    [bookmarks removeAllObjects];
    [bookmarks addObjectsFromArray:itemArray];
}

- (void)buttonBarControl:(FRBButtonBarControl *)buttonBarControl didClickItem:(FRBButtonBarItem *)item
{
    [[theWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[(Bookmark*)item url]]]];
}

@end
