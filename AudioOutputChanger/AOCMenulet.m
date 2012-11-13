//
//  AOCMenulet.m
//  AudioOutputChanger
//
//  Created by Dennis Schmidt on 11.11.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import "AOCMenulet.h"

@implementation AOCMenulet

@synthesize statusItem;
@synthesize outputSwitcher;

#pragma mark -
#pragma mark Initialization

- (AOCMenulet *)init {
    if(self = [super init]) {
        NSString *titleGlyph = [NSString stringWithUTF8String:"\xf0\x9f\x94\x88"];
        
        statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
        [statusItem setHighlightMode:YES];
        [statusItem setTitle:titleGlyph];
        [statusItem setEnabled:YES];
        [statusItem setToolTip:@"Audio Output Device Switcher"];
        
        outputSwitcher = [[AOCOutputSwitcher alloc] init];
        
        [self initMenu];
    }
    
    return self;
}

- (void)initMenu {
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Switch Audio Output Device"];
    NSArray *deviceNames = [outputSwitcher outputDeviceNames];
    
    for(NSString *outputDeviceName in deviceNames) {
        NSMenuItem *menuItem = [menu addItemWithTitle:outputDeviceName
                                               action:@selector(clickedMenuItem:)
                                        keyEquivalent:@""];
        NSString *keyEquivalent = [NSString stringWithFormat:@"%lu", ([menu indexOfItem:menuItem] + 1)];
        [menuItem setKeyEquivalentModifierMask:NSAlternateKeyMask];
        [menuItem setKeyEquivalent:keyEquivalent];
        [menuItem setTarget:self];
    }
    
    NSMenuItem *separatorItem = [NSMenuItem separatorItem];
    [menu addItem:separatorItem];
    
    NSMenuItem *menuItem = [menu addItemWithTitle:@"About" action:@selector(showAbout) keyEquivalent:@"a"];
    [menuItem setTarget:self];
    
    menuItem = [menu addItemWithTitle:@"Quit" action:@selector(quitApp) keyEquivalent:@"q"];
    [menuItem setTarget:self];
    
    [menu setDelegate:self];
    [statusItem setMenu:menu];
}

#pragma mark -
#pragma mark Menu Management

- (void)updateMenuItemStates {
    NSString *currentDeviceName = [outputSwitcher currentlySelectedOutputDeviceName];
    
    for(NSMenuItem *menuItem in [[statusItem menu] itemArray]) {
        NSString *menuItemName = [menuItem title];
        
        if([menuItemName isEqualToString:currentDeviceName]) {
            [menuItem setState:NSOnState];
        } else {
            [menuItem setState:NSOffState];
        }
    }
}

#pragma mark -
#pragma mark NSMenuDelegate methods

- (void)menuWillOpen:(NSMenu *)menu {
    [self updateMenuItemStates];
}

#pragma mark -
#pragma mark User Event Handling

- (void)clickedMenuItem:(NSMenuItem *)menuItem {
    NSString *menuItemName = [menuItem title];
    
    [outputSwitcher setDeviceByName:menuItemName];
    [self updateMenuItemStates];
}

- (void)showAbout {
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:self];
}

- (void)quitApp {
    [NSApp terminate:self];
}


@end
