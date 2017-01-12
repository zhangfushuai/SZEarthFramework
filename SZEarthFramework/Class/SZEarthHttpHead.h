//
//  HttpHead.h
//  smartbadminton
//
//  Created by Earth on 15/11/16.
//  Copyright © 2015年 Earth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZEarthHttpHead : NSObject
@property NSString *valid;
@property NSNumber *ID;
@property NSNumber *length;
@property NSNumber *error;

//-(id)initWithValid:(NSString*)valid andID:(int)ID Length:(int)length error:(int)error;
-(id)initWithValid:(NSString*)valid andID:(NSNumber*)ID Length:(NSNumber*)length error:(NSNumber*)error;


@end
