//
//  OTViewController.m
//  S3FileSharing
//
//  Created by Charley Robinson on 03/18/2016.
//  Copyright (c) 2016 Charley Robinson. All rights reserved.
//

#import "OTViewController.h"
#import <S3FileSharing/S3FileSharing.h>
#import <AWSCore/AWSCore.h>

@interface OTViewController () <S3FileSharingDelegate>

@end

@implementation OTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    AWSCognitoCredentialsProvider *credentialsProvider =
    [[AWSCognitoCredentialsProvider alloc]
     initWithRegionType:AWSRegionUSEast1
     identityPoolId:@"us-east-1:33e7db10-39e5-42a5-ab11-83baf9241de6"];
    
    AWSServiceConfiguration *configuration =
    [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration =
    configuration;
    
    // Retrieve your Amazon Cognito ID
    [[credentialsProvider getIdentityId] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        else {
            // the task result will contain the identity id
            NSString *cognitoId = task.result;
            NSLog(@"cognitoID: %@", cognitoId);
        }
        return nil;
    }];
    
    S3FileSharing* fileSharing =
    [[S3FileSharing alloc] initWithDelegate:self];

    NSLog(@"Generate test data");
    // Create a test file in the temporary directory
    NSMutableString *dataString = [NSMutableString new];
    for (int32_t i = 1; i < 1000000; i++) {
        [dataString appendFormat:@"%d\n", i];
    }
    NSLog(@"...done");
    
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory()
                                  isDirectory:YES];
    NSUUID* uuid = [NSUUID UUID];
    NSURL *fileURL = [tmpDirURL URLByAppendingPathComponent:uuid.UUIDString];
    NSData* data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    [data writeToURL:fileURL options:NSDataWritingAtomic error:&error];
    if (error) {
        NSLog(@"failed to write out file: %@", error);
    } else {
        [fileSharing uploadFile:fileURL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)file:(NSURL*)file uploadCompletedWithKey:(NSString*)key
      error:(NSError*)error
{
    // share the key with some user, who whill fetch it
}

@end
