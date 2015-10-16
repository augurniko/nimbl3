//
//  networkClient.m
//  Nimbl3
//
//  Created by NICOLAS DEMOGUE on 15/10/2015.
//  Copyright © 2015 NICOLAS DEMOGUE. All rights reserved.
//

#import "networkSingleton.h"

@implementation networkSingleton

+(networkSingleton*)sharedNetwork {
    static networkSingleton *sharedNetwork = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetwork = [[self alloc] init];
    });
    return sharedNetwork;
}

-(void)openURL
{
    if (_jsonSurveys != nil)
    {
        [_jsonSurveys removeAllObjects];
        _jsonSurveys = nil;
    }
    _jsonSurveys = [NSMutableArray new];
    
    AFHTTPRequestOperationManager *AFHTTPmanager = [AFHTTPRequestOperationManager manager];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:USERNAME password:PASSWORD persistence:NSURLCredentialPersistenceNone];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_NIMBL3,CREDENTIAL];
    NSMutableURLRequest *request = [AFHTTPmanager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCredential:credential];
    [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id response)
    {
        [self initJsonSurveys:response];
        if ((_jsonSurveys == nil) || ([_jsonSurveys count] == 0))
            [_delegate isError:self error:nil];
        else
	        [_delegate isDownloaded:self];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Failure: %@", error);
        [_delegate isError:self error:error];
    }];
    [AFHTTPmanager.operationQueue addOperation:operation];
}

-(void)initJsonSurveys:(id)response
{
    for(NSDictionary *json in response)
    {
        surveysData *value = [surveysData new];
        
        value.backgroundSurvey	= [json objectForKey:@"cover_image_url"];
        value.titleSurvey		= [json objectForKey:@"title"];
        value.descriptionSurvey	= [json objectForKey:@"description"];
        
        [_jsonSurveys addObject:value];
    }
}

-(void)setDelegate:(id)delegate
{
    _delegate = delegate;
}
@end
