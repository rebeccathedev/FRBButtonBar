# FRBButtonBar

FRBButtonBar is an button bar implemntation designed to superficially resemble the bevahvior and appearance of the Safari Bookmarks bar. Among other things, it features:

* Buttons can represent individual items or groups of items. Groups will be displayed as a dropdown menu beneath (like folders in Safari).
* Overflow control: If there are more buttons than the bar can handle, they overflow into a menu off the right side (again, like Safari).
* Drag buttons to rearrange them.
* Infinite level of child items. Well, there's probably some theoretical Apple imposed limit, but I haven't found it yet. :)
* Makes no assumptions about colors or the like. Uses system colors internally. Wrap it in a container NSView to give it background colors, gradients, etc.

This is actually something I've been tinkering with for some months. Much of the code for this project was inspired by the excellent KPCTabsControl by Cédric Foellmi.

# Screenshots

![Normal](https://raw.githubusercontent.com/peckrob/FRBButtonBar/master/Screenshots/normal.png?raw=true "Normal")

*Normal Mode*

![Dropdown Open](https://raw.githubusercontent.com/peckrob/FRBButtonBar/master/Screenshots/open.png?raw=true "Dropdown Open")

*Dropdown Menu Open*

![Rearranging](https://raw.githubusercontent.com/peckrob/FRBButtonBar/master/Screenshots/drag.png?raw=true "Rearranging")

*Rearranging Mode. Bar buttons animate sliding.*

![Overflow Mode](https://raw.githubusercontent.com/peckrob/FRBButtonBar/master/Screenshots/overflow.png?raw=true "Overflow Mode")

*Demonstrating Overflow Mode*

# Installation

Installation is dead easy with Cocoapods.

```
pod 'FRBButtonBar', :git => 'https://www.github.com/peckrob/FRBButtonBar'
```

Alternatively, you can download the project, build the framework, and import it into your app.

# Usage

A Demonstration app is available. In general, here are the following things you should do.

1. Subclass FRBButtonBarItem and add whatever data you want to be tracked. In the Demo app, this is the Bookmark class.
1. Implement some way of tracking what should be displayed in the button bar. A simple NSMutableArray works great.
1. Implement the FRBButtonBarControlDataSource and FRBButtonBarControlDelegate protocols in your controller class. Specifically, you must implement the following methods:

```objective-c
// Return the number of items in the button bar (the count of the first level)
- (NSUInteger)buttonBarNumberOfButtons:(FRBButtonBarControl *)buttonBarControl;

// Return the item at index "index" from your array.
- (FRBButtonBarItem*)buttonBarControl:(FRBButtonBarControl *)buttonBarControl itemAtIndex:(NSUInteger)index;

// Called when a user clicks on one of your FRBButtonBarItem subclass items.
- (void)buttonBarControl:(FRBButtonBarControl *)buttonBarControl didClickItem:(FRBButtonBarItem*)item;

// Called when the user rearranges the buttons. You should now store the new arrangement.
// Optional. If it's not implemented, rearranging is disabled.
- (void)buttonBarControl:(FRBButtonBarControl *)buttonBarControl didReorderItems:(NSArray *)itemArray;
```

# License

MIT.

# Author

Rebecca Peck
