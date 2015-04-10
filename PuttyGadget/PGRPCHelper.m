//
//  PGRPCHelper.m
//  PuttyGadget
//
//  Created by Frank An on 27/04/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "PGRPCHelper.h"

@implementation PGRPCHelper

@synthesize receivedData=_receivedData;
@synthesize requestData=_requestData;
@synthesize result=_result;
@synthesize delegate=_delegate;

/*-(id)init
{
    
    return [[PGRPCHelper alloc]init];

}*/


-(NSObject *)parseJSON:(NSMutableData *)data
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData: data
                          options:kNilOptions
                          error:&error];
    //NSMutableDictionary *result;
    NSLog(@"JSON Parse error:%@",error);
    /*if([json isKindOfClass:[NSArray class]])
    {
        NSArray *j=(NSArray*)json;
        result=[[NSMutableDictionary alloc]init];
        for(int i=0;i<[j count];i++)
        {
            NSLog(@"%@",[j objectAtIndex:i]);
        }
    }
    else
    {
        result=[json mutableCopy];
    }*/
    
    //NSLog(@"parseJSON:%@ error:%@",[result allKeys],error);
    //NSLog(@"odd%@",[[json objectAtIndex:0] valueForKey:@"first_name"]);
    return json;

}

-(void)getResponse: (NSString *)from withData:(NSString *)data{

    //NSString *message=@"d={\"func\":\"getPatientInfo\",\"param\":[\"16964\"]}";
    //NSString *message=@"d=123";
    NSLog(@"JSON QUERY %@",data);
    NSURL *url = [NSURL URLWithString:@"http://extjs.claydata.com/pgrpc/pgrpc.php"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [data length]];
    
    [theRequest addValue: @"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    //[theConnection start];
    if( theConnection )
    {
        // webData = [[NSMutableData data] retain];
       // NSLog(@"Received data %@",)
        self.receivedData=[[NSMutableData alloc]init];
        
    } 
    else
    {
        NSLog(@"theConnection is NULL");
    }    
    // NSLog(@"HTTP:%@",[[NSString alloc] initWithData:[theRequest HTTPBody] encoding:NSUTF8StringEncoding] );
    //  NSLog(@"POST:%@",message);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    NSLog(@"REceived:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    [self.receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    // connection 
    NSLog(@"Final REceived:%@",[[NSString alloc]initWithData:self.receivedData encoding:NSUTF8StringEncoding]);
    self.result=[self parseJSON:self.receivedData];
    if([self.result respondsToSelector:@selector(valueForKey:)])
    {
        //NSLog(@"test%@",[self.result allKeys]);
        [self.delegate OnFinishReceiveJSONResponse:self.result];
    }
    
    
    
}



@end
