//
//  OBLEBeaconIdentifier.h
//  OrangeBLE
//
//  Created by Romain Menetrier on 27/08/2015.
//  Copyright (c) 2015 Orange Vallee. All rights reserved.
//

#ifndef OrangeBLE_OBLEBeaconIdentifier_h
#define OrangeBLE_OBLEBeaconIdentifier_h

@interface OBLEBeaconIdentifier : NSObject

@property (readonly, nonatomic) NSString *uuid;
@property (readonly, nonatomic) NSNumber *major;
@property (readonly, nonatomic) NSNumber *minor;
@property (readonly, nonatomic) NSString *fullId;

- (instancetype)initWithUUID:(NSString *)uuid major:(NSNumber *)major minor:(NSNumber *) minor;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithFullId:(NSString *)fullId;

- (NSDictionary *)toDictionary;

@end


#endif
