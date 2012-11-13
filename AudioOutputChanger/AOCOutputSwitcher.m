//
//  AOCOutputSwitcher.m
//  AudioOutputChanger
//
//  Created by Dennis Schmidt on 10.11.12.
//  Copyright (c) 2012 Dennis Schmidt. All rights reserved.
//

#import "AOCOutputSwitcher.h"

@interface AOCOutputSwitcher ()
- (BOOL)isOutputDevice:(AudioDeviceID)deviceID;
- (NSArray *)availableOutputDeviceIDs;
- (AudioDeviceID)currentOutputDeviceID;
- (AudioDeviceID)deviceIDForName:(NSString *)requestedDeviceName;
- (NSString *)deviceNameForID:(AudioDeviceID)deviceID;
- (void)setDeviceByID:(AudioDeviceID)newDeviceID;
@end


@implementation AOCOutputSwitcher

- (NSArray *)outputDeviceNames {
    NSArray *availableOutputDeviceIDs = [self availableOutputDeviceIDs];

    UInt32 deviceCount = (UInt32)[availableOutputDeviceIDs count];
    NSMutableArray *deviceNamesForType = [[NSMutableArray alloc] initWithCapacity:deviceCount];

    for(NSNumber *deviceIDNumber in availableOutputDeviceIDs) {
        UInt32 deviceID = [deviceIDNumber unsignedIntValue];
        NSString *deviceName = [self deviceNameForID:deviceID];

        [deviceNamesForType addObject:deviceName];
    }

    return [NSArray arrayWithArray:deviceNamesForType];
}

- (NSString *)currentlySelectedOutputDeviceName {
    AudioDeviceID currentDeviceID = [self currentOutputDeviceID];
    NSString *currentDeviceName = [self deviceNameForID:currentDeviceID];

    return currentDeviceName;
}

- (void)setDeviceByName:(NSString *)deviceName {
    AudioDeviceID deviceID = [self deviceIDForName:deviceName];
    [self setDeviceByID:deviceID];
}

#pragma mark -
#pragma mark Private Interface

- (BOOL)isOutputDevice:(AudioDeviceID)deviceID {
    UInt32 propertySize = 256;

    AudioDeviceGetPropertyInfo(deviceID, 0, false, kAudioDevicePropertyStreams, &propertySize, NULL);
    BOOL isOutputDevice = (propertySize > 0);

    return isOutputDevice;
}

- (NSArray *)availableOutputDeviceIDs {
    UInt32 propertySize;
    AudioDeviceID devices[64];
    int devicesCount = 0;

    AudioHardwareGetPropertyInfo(kAudioHardwarePropertyDevices, &propertySize, NULL);
    AudioHardwareGetProperty(kAudioHardwarePropertyDevices, &propertySize, devices);
    devicesCount = (propertySize / sizeof(AudioDeviceID));

    NSMutableArray *availableOutputDeviceIDs = [[NSMutableArray alloc] initWithCapacity:devicesCount];

    for(int i = 0; i < devicesCount; ++i) {
        if ([self isOutputDevice:devices[i]]) {
            NSNumber *outputDeviceID = [NSNumber numberWithUnsignedInt:devices[i]];
            [availableOutputDeviceIDs addObject:outputDeviceID];
        }
    }

    return [NSArray arrayWithArray:availableOutputDeviceIDs];
}

- (AudioDeviceID)currentOutputDeviceID {
    UInt32 propertySize;
    AudioDeviceID deviceID = kAudioDeviceUnknown;

    propertySize = sizeof(deviceID);
    AudioHardwareGetProperty(kAudioHardwarePropertyDefaultOutputDevice, &propertySize, &deviceID);

    return deviceID;
}

- (NSString *)deviceNameForID:(AudioDeviceID)deviceID {
    UInt32 propertySize = 256;
    char deviceName[256];

    AudioDeviceGetProperty(deviceID, 0, false, kAudioDevicePropertyDeviceName, &propertySize, deviceName);
    NSString *deviceNameForID = [NSString stringWithCString:deviceName encoding:NSUTF8StringEncoding];

    return deviceNameForID;
}

- (AudioDeviceID)deviceIDForName:(NSString *)requestedDeviceName {
    AudioDeviceID deviceIDForName = kAudioDeviceUnknown;
    NSArray *availableOutputDeviceIDs = [self availableOutputDeviceIDs];

    for(NSNumber *deviceIDNumber in availableOutputDeviceIDs) {
        UInt32 deviceID = [deviceIDNumber unsignedIntValue];
        NSString *deviceName = [self deviceNameForID:deviceID];

        if ([requestedDeviceName isEqualToString:deviceName]) {
            deviceIDForName = deviceID;
            break;
        }
    }

    return deviceIDForName;
}

- (void)setDeviceByID:(AudioDeviceID)newDeviceID {
    UInt32 propertySize = sizeof(UInt32);
    AudioHardwareSetProperty(kAudioHardwarePropertyDefaultOutputDevice, propertySize, &newDeviceID);
}

@end
