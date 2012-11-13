//
//  AOCOutputSwitcher.h
//  AudioOutputChanger
//
//  Created by Dennis Schmidt on 10.11.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import <CoreAudio/CoreAudio.h>

@interface AOCOutputSwitcher : NSObject

- (NSArray *)outputDeviceNames;
- (NSString *)currentlySelectedOutputDeviceName;
- (void)setDeviceByName:(NSString *)requestedDeviceName;

@end
