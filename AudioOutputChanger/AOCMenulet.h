//
//  AOCMenulet.h
//  AudioOutputChanger
//
//  Created by Dennis Schmidt on 11.11.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AOCOutputSwitcher.h"

@interface AOCMenulet : NSObject<NSMenuDelegate> {
    
}

@property (nonatomic) IBOutlet NSStatusItem *statusItem;
@property (nonatomic) IBOutlet AOCOutputSwitcher *outputSwitcher;

@end
