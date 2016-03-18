//
//  S3FileSharing.m
//  S3FileSharing
//
//  Created by Charley Robinson on 3/17/16.
//  Copyright © 2016 TokBox, Inc. All rights reserved.
//

#import "S3FileSharing.h"
#import <AWSS3/AWSS3.h>
#import <AWSCore/AWSCore.h>

@implementation S3FileSharing {
    AWSTask* _uploadTask;
    AWSS3TransferUtilityUploadExpression* _uploadExpression;
}

- (instancetype)initWithAccessKey:(NSString*)key secret:(NSString*)secret
{
    self = [super init];
    if (self) {
        [AWSLogger defaultLogger].logLevel = AWSLogLevelDebug;
    
        // TODO: Set this up to work with Cognito or something.
        // This is not recommended at all.
        AWSStaticCredentialsProvider* credentials =
        [[AWSStaticCredentialsProvider alloc] initWithAccessKey:key
                                                      secretKey:secret];
        
        AWSServiceConfiguration *configuration =
        [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                    credentialsProvider:credentials];
        
        AWSServiceManager.defaultServiceManager.defaultServiceConfiguration =
        configuration;
        
        self.bucket = @"artifact.tokbox.com";

    }
    return self;
}

- (void)uploadFile:(NSURL*)file {
    NSDictionary *fileAttributes =
    [[NSFileManager defaultManager] attributesOfItemAtPath:file.path error:nil];
    NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
    NSLog(@"uploading %@ bytes", fileSize);
    
    NSString* fileName = [file lastPathComponent];

    AWSS3TransferUtility* transferUtility =
    [AWSS3TransferUtility defaultS3TransferUtility];
    
    _uploadExpression = [AWSS3TransferUtilityUploadExpression new];
    _uploadExpression.uploadProgress = ^void(AWSS3TransferUtilityUploadTask *task,
                                             int64_t bytesSent,
                                             int64_t totalBytesSent,
                                             int64_t totalBytesExpectedToSend)
    {
        NSLog(@"bytesOut: %lld of %lld",
              totalBytesSent,
              totalBytesExpectedToSend);
    };
    
    AWSS3TransferUtilityUploadCompletionHandlerBlock completionBlock =
    ^(AWSS3TransferUtilityUploadTask * _Nonnull task,
      NSError * _Nullable error)
    {
        NSLog(@"new block task: %@", task);
        NSLog(@"error: %@", error);
    };
    
    [[transferUtility uploadFile:file
                         bucket:self.bucket
                            key:[NSString stringWithFormat:@"charley/%@", fileName]
                    contentType:@"text/plain"
                     expression:_uploadExpression
               completionHander:completionBlock] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
        }
        if (task.result) {
            NSLog(@"Result: %@", task.result);
        }
        
        return nil;
    }];
    
    NSLog(@"started");
}

- (void)releaseFile:(NSString *)key {
    
}

@end
