//
//  networkClient.h
//  Nimbl3
//
//  Created by NICOLAS DEMOGUE on 15/10/2015.
//  Copyright © 2015 NICOLAS DEMOGUE. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "constants.h"
#import "surveysData.h"

@class networkSingleton;

// define the protocol for the delegate
@protocol networkSingletonDelegate

-(void)isDownloaded:(networkSingleton*)networkSingleton;
-(void)isError:(networkSingleton*)networkSingleton error:(NSError*)error;

@end


@interface networkSingleton : AFHTTPSessionManager

@property (nonatomic, weak) 	id  			delegate;
@property (nonatomic, strong)	NSMutableArray	*jsonSurveys;

+(networkSingleton*)sharedNetwork;

-(void)openURL;
-(void)setDelegate:(id)delegate;


@end
