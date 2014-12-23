//
//  FRBButtonBarControl.m
//  FRBButtonBar
//
//  Created by Rob Peck on 12/17/14.
//  Copyright (c) 2014 Frobaus. All rights reserved.
//  Portions of this code are based on KPCTabsControl, which is Copyright (c)
//  2014 @onekiloparsec (Cédric Foellmi). All rights reserved.
//

#import "FRBButtonBarControl.h"
#import "FRBButton.h"
#import "FRBButtonBarItem.h"
#import "FRBMenuItem.h"

@interface FRBButtonBarControl ()
@property (nonatomic, strong) NSView *buttonsView;
@end

@implementation FRBButtonBarControl

@synthesize delegate;
@synthesize font;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setWantsLayer:YES];
    [self setLayer:[CALayer layer]];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setButtonsView:[NSView new]];
    [[self buttonsView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:[self buttonsView]];
    
    // This is for the overflow menu.
    moreMenu = [NSMenu new];
    
    // This is for the more button, which is hidden unless it's needed.
    moreButton = [NSButton new];
    [moreButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [moreButton setTitle:@">>"];
    [moreButton setButtonType:NSMomentaryPushInButton];
    [moreButton setBezelStyle:NSRecessedBezelStyle];
    [moreButton setBordered:NO];
    [moreButton setFocusRingType:NSFocusRingTypeNone];
    [moreButton setHidden:YES];
    [moreButton setAction:@selector(moreButtonClicked:)];
    [moreButton setTarget:self];
    [self addSubview:moreButton];
    
    NSView *bView = [self buttonsView];
    
    // Add constraints to keep the layout correct.
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(bView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[moreButton]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(moreButton)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bView][moreButton(20)]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(bView, moreButton)]];
}

- (void)layout
{
    [super layout];
    [self reloadItems];
}

- (void)viewWillStartLiveResize
{
    [super viewWillStartLiveResize];
    [self reloadItems];
}

- (void)setDataSource:(id<FRBButtonBarControlDataSource>)dataSource
{
    if (_dataSource == dataSource) {
        return;
    }
    
    _dataSource = dataSource;
    [self reloadItems];
}

- (void)reloadItems
{
    [[self buttons] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [moreMenu removeAllItems];
    
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0, count = [self.dataSource buttonBarNumberOfButtons:self]; i < count; i++) {
        [newItems addObject:[self.dataSource buttonBarControl:self itemAtIndex:i]];
    }
    
    BOOL overflow = NO;
    float contentWidth = 0;
    for (NSUInteger i = 0; i < newItems.count; i++) {
        FRBButtonBarItem *item = newItems[i];
        
        if (!overflow) {
            FRBButton *button = [FRBButton new];
            [button setTarget:self];
            [button setAction:@selector(selectButton:)];
            [button setTitle:[item title]];
            [button setRepresentedItem:item];
            
            if ([self font] != nil) {
                [[button cell] setFont:[self font]];
            }
            
            [button sizeToFit];
            
            if (CGRectGetWidth([button frame]) + contentWidth > CGRectGetWidth([[self buttonsView] frame])) {
                overflow = YES;
                button = nil;
            } else {
                [[self buttonsView] addSubview:button];
                contentWidth += CGRectGetWidth([button frame]);
            }
        }
        
        if (overflow) {
            FRBMenuItem *menuItem = [FRBMenuItem new];
            [menuItem setTitle:[item title]];
            [menuItem setTarget:self];
            [menuItem setAction:@selector(selectMenuItem:)];
            [menuItem setRepresentedItem:item];
            
            [moreMenu addItem:menuItem];
        }
    }
    
    if (overflow) {
        [moreButton setHidden:NO];
    } else {
        [moreButton setHidden:YES];
    }
    
    [self layoutButtons:nil animated:NO];
    [self invalidateRestorableState];
}

- (void)moreButtonClicked:(id)sender
{
    [moreMenu popUpMenuPositioningItem:nil atLocation:[sender frame].origin inView:self];
}

- (void)reorderButton:(FRBButton *)button withEvent:(NSEvent *)event
{
    NSMutableArray *orderedButtons = [[NSMutableArray alloc] initWithArray:[self buttons]];
    
    CGFloat tabX = NSMinX(button.frame);
    NSPoint dragPoint = [self.buttonsView convertPoint:event.locationInWindow fromView:nil];
    
    FRBButton *draggingButton = [button copy];
    [[self buttonsView] addSubview:draggingButton];
    [button setHidden:YES];
    
    CGPoint prevPoint = dragPoint;
    BOOL reordered = NO;
    
    while (1) {
        event = [self.window nextEventMatchingMask:NSLeftMouseDraggedMask|NSLeftMouseUpMask];
        
        if (event.type == NSLeftMouseUp) {
            [[NSAnimationContext currentContext] setCompletionHandler:^{
                [draggingButton removeFromSuperview];
                [button setHidden:NO];
                
                NSMutableArray *reorderedArray = [NSMutableArray arrayWithArray:[orderedButtons valueForKeyPath:@"representedItem"]];
                if ([[moreMenu itemArray] count] > 0) {
                    [reorderedArray addObjectsFromArray:[[moreMenu itemArray] valueForKeyPath:@"representedItem"]];
                }
                
                if (reordered && [[self delegate] respondsToSelector:@selector(buttonBarControl:didReorderItems:)]) {
                    [[self delegate] buttonBarControl:self didReorderItems:reorderedArray];
                }
                
                [self reloadItems]; // That's the delegate responsability to store new order of items.
            }];
            [[draggingButton animator] setFrame:button.frame];
            break;
        };
        
        NSPoint nextPoint = [self.buttonsView convertPoint:event.locationInWindow fromView:nil];
        CGFloat nextX = tabX + (nextPoint.x - dragPoint.x);
        
        // Don't let it go beyond the left or right bounds.
        if (nextX < 0) {
            nextX = 0;
        }
        
        if (nextX + CGRectGetWidth([draggingButton frame]) > CGRectGetWidth([[self buttonsView] frame])) {
            nextX = CGRectGetWidth([[self buttonsView] frame]) - CGRectGetWidth([draggingButton frame]);
        }
        
        CGRect r = draggingButton.frame;
        r.origin.x = nextX;
        draggingButton.frame = r;
        
        BOOL movingLeft = (nextPoint.x < prevPoint.x);
        BOOL movingRight = (nextPoint.x > prevPoint.x);
        
        prevPoint = nextPoint;
        
        if (movingLeft && NSMidX(draggingButton.frame) < NSMinX(button.frame) && button != orderedButtons.firstObject) {
            // shift left
            NSUInteger index = [orderedButtons indexOfObject:button];
            [orderedButtons exchangeObjectAtIndex:index withObjectAtIndex:index - 1];
            [self layoutButtons:orderedButtons animated:YES];
            reordered = YES;
        }
        else if (movingRight && NSMidX(draggingButton.frame) > NSMaxX(button.frame) && button != orderedButtons.lastObject) {
            // shift right
            NSUInteger index = [orderedButtons indexOfObject:button];
            [orderedButtons exchangeObjectAtIndex:index+1 withObjectAtIndex:index];
            [self layoutButtons:orderedButtons animated:YES];
            reordered = YES;
        }
    }
}

- (NSArray*)buttons
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"class == %@", [FRBButton class]];
    return [self.buttonsView.subviews filteredArrayUsingPredicate:predicate];
}

- (void)layoutButtons:(NSArray *)buttons animated:(BOOL)anim
{
    if (!buttons) {
        buttons = [self buttons];
    }
    
    __block CGFloat tabsViewWidth = 0.0;
    [buttons enumerateObjectsUsingBlock:^(FRBButton *button, NSUInteger idx, BOOL *stop) {
        CGFloat buttonWidth = button.frame.size.width;
        CGRect r = CGRectMake(tabsViewWidth, 0, buttonWidth, CGRectGetHeight(self.buttonsView.frame));
        
        // Don't animate if it is hidden, as it will screw order of tabs
        if (anim && ![button isHidden]) {
            [[button animator] setFrame:r];
        }
        else {
            [button setFrame:r];
        }
        
        tabsViewWidth += CGRectGetWidth(button.frame);
    }];
}

- (void)selectButton:(id)sender
{
    FRBButton *selectedButton = sender;
    
    // If the delegate doesn't implement this method, we don't need to allow
    // rearranging because the delegate will have no way to store the rearranged
    // data so we can rebuild it.
    if ([[self delegate] respondsToSelector:@selector(buttonBarControl:didReorderItems:)]) {
        
        NSEvent *currentEvent = [NSApp currentEvent];
        
        // watch for a drag event and initiate dragging if a drag is found...
        NSEvent *event = [self.window nextEventMatchingMask:NSLeftMouseUpMask | NSLeftMouseDraggedMask
                                                  untilDate:[NSDate distantFuture]
                                                     inMode:NSEventTrackingRunLoopMode
                                                    dequeue:NO];
        
        if (event.type == NSLeftMouseDragged) {
            [self reorderButton:sender withEvent:currentEvent];
            return;
        }
    } else {
        for (FRBButton *button in [self buttons]) {
            [button setHighlighted:NO];
            [button setShowsBorderOnlyWhileMouseInside:YES];
        }
    }
    
    if ([selectedButton menu] != nil) {
        [[selectedButton menu] popUpMenuPositioningItem:nil atLocation:[selectedButton frame].origin inView:[self buttonsView]];
    } else {
        if ([[self delegate] respondsToSelector:@selector(buttonBarControl:didClickItem:)]) {
            [[self delegate] buttonBarControl:self didClickItem:[selectedButton representedItem]];
        }
    }
    
    [self invalidateRestorableState];
}

- (void)selectMenuItem:(id)sender
{
    FRBMenuItem *menuItem = sender;
    if ([[self delegate] respondsToSelector:@selector(buttonBarControl:didClickItem:)]) {
        [[self delegate] buttonBarControl:self didClickItem:[menuItem representedItem]];
    }
}

@end
