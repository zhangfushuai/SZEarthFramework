//
//  UARTPeripheral.h
//  nRF UART
//
//  Created by Ole Morten on 1/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol SZEarthUARTPeripheralDelegate
- (void) didReceiveData:(NSString *) string;
@optional
- (void) didReadHardwareRevisionString:(NSString *) string;
@end


@interface SZEarthUARTPeripheral : NSObject <CBPeripheralDelegate>
@property CBPeripheral *peripheral;
@property id<SZEarthUARTPeripheralDelegate> delegate;

@property CBService *uartService;
@property CBCharacteristic *rxCharacteristic;
@property CBCharacteristic *txCharacteristic;

+ (CBUUID *) uartServiceUUID;

- (SZEarthUARTPeripheral *) initWithPeripheral:(CBPeripheral*)peripheral delegate:(id<SZEarthUARTPeripheralDelegate>) delegate;

- (void) writeString:(NSData *) data;

- (void) didConnect;
- (void) didDisconnect;
@end
