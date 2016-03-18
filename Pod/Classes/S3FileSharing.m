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
#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation S3FileSharing {
    AWSTask* _uploadTask;
    AWSS3TransferUtilityUploadExpression* _uploadExpression;
    
}

- (instancetype)initWithDelegate:(id<S3FileSharingDelegate>)delegate
{
    self = [super init];
    if (self) {
        [self setDelegate:delegate];
        [self setBucket:@"com.wobbals.s3filesharing"];
        [self setPrefix:@"S3FileSharing"];
    }
    return self;
}

- (void)uploadFile:(NSURL*)file {
    NSDictionary *fileAttributes =
    [[NSFileManager defaultManager] attributesOfItemAtPath:file.path error:nil];
    NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
    DDLogInfo(@"Will upload %@ bytes", fileSize);
    
    NSString* fileName = [file lastPathComponent];

    AWSS3TransferUtility* transferUtility =
    [AWSS3TransferUtility defaultS3TransferUtility];
    
    _uploadExpression = [AWSS3TransferUtilityUploadExpression new];
    _uploadExpression.uploadProgress = ^void(AWSS3TransferUtilityUploadTask *task,
                                             int64_t bytesSent,
                                             int64_t totalBytesSent,
                                             int64_t totalBytesExpectedToSend)
    {
        DDLogDebug(@"bytesOut: %lld of %lld",
              totalBytesSent,
              totalBytesExpectedToSend);
    };
    
    AWSS3TransferUtilityUploadCompletionHandlerBlock completionBlock =
    ^(AWSS3TransferUtilityUploadTask * _Nonnull task,
      NSError * _Nullable error)
    {
        [self.delegate file:file uploadCompletedWithKey:task.key error:error];
    };
    
    [[transferUtility uploadFile:file
                         bucket:self.bucket
                            key:[NSString stringWithFormat:@"%@/%@",
                                 self.prefix, fileName]
                    contentType:@"text/plain"
                     expression:_uploadExpression
               completionHander:completionBlock]
     continueWithBlock:^id(AWSTask *task)
     {
        if (task.error) {
            DDLogError(@"Error: %@", task.error);
        }
        if (task.exception) {
            DDLogError(@"Exception: %@", task.exception);
        }
        if (task.result) {
            DDLogInfo(@"Result: %@", task.result);
        }
        
        return nil;
    }];
    
    DDLogInfo(@"started upload!");
}

- (void)releaseFile:(NSString *)key
{
    
}

- (void)fetchKey:(NSString*)key {
    NSURL* tempURL;
    [self fetchKey:key toURL:tempURL];
}

- (void)fetchKey:(NSString*)key toURL:(NSURL*)url
{
    
}


@end
