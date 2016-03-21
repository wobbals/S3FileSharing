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
#import "NSData+MD5.h"

@interface OTViewController () <S3FileSharingDelegate>

@end

@implementation OTViewController {
    S3FileSharing* _fileSharing;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Be sure to create a Config.plist (see Config.plist.sample)
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config"
                                                     ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString* cognitoPoolID = [settings objectForKey:@"AWS_COGNITO_POOL_ID"];
    NSLog(@"Using Cognito Pool ID %@", cognitoPoolID);
    
    AWSCognitoCredentialsProvider *credentialsProvider =
    [[AWSCognitoCredentialsProvider alloc]
     initWithRegionType:AWSRegionUSEast1
     identityPoolId:cognitoPoolID];
    
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
    
    _fileSharing = [[S3FileSharing alloc] initWithDelegate:self];

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
        [_fileSharing uploadFile:fileURL];
    }
    
    NSLog(@"source MD5: %@", [data MD5]);
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
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory()
                                  isDirectory:YES];
    NSUUID* uuid = [NSUUID UUID];
    NSURL *fileURL = [tmpDirURL URLByAppendingPathComponent:uuid.UUIDString];
    
    [_fileSharing downloadKey:key toURL:fileURL];
    
    // ...or just delete it
    //[_fileSharing releaseKey:key];
}

-(void)file:(NSURL*)file downloadCompletedWithKey:(NSString*)key
      error:(NSError*)error
{
    NSData* contents = [NSData dataWithContentsOfURL:file];
    NSLog(@"downloaded MD5: %@", [contents MD5]);
    
    [_fileSharing releaseKey:key];
}


@end
