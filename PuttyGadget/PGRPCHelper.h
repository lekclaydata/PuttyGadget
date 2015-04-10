//
//  PGRPCHelper.h
//  PuttyGadget
//
//  Created by Frank An on 27/04/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PGRPCHelperDelegate 

-(void)OnFinishReceiveJSONResponse: (NSDictionary *)result;

@end


@interface PGRPCHelper : NSObject <NSURLConnectionDelegate>

@property(nonatomic,strong) NSMutableData *receivedData;

@property(nonatomic,strong) NSString *requestData;

@property(nonatomic,strong) NSDictionary *result;

@property(nonatomic,strong) id <PGRPCHelperDelegate> delegate;


-(NSDictionary *)parseJSON:(NSData *)data;

-(void)getResponse: (NSString *)from withData:(NSString *)data;

@end
