//
//  S3FileSharing.h
//  S3FileSharing
//
//  Created by Charley Robinson on 3/17/16.
//  Copyright © 2016 TokBox, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol S3FileSharingDelegate;

@interface S3FileSharing : NSObject

@property (nonatomic, retain) NSString* bucket;
@property (nonatomic, retain) NSString* prefix;
@property (nonatomic, assign) id<S3FileSharingDelegate> delegate;

- (instancetype)initWithDelegate:(id<S3FileSharingDelegate>)delegate;

// File management
- (void)uploadFile:(NSURL*)file;
- (void)releaseFile:(NSString*)key;

@end

@protocol S3FileSharingDelegate <NSObject>

-(void)file:(NSURL*)file uploadCompletedWithKey:(NSString*)key
      error:(NSError*)error;

@end