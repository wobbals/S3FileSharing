//
//  S3FileSharing.h
//  S3FileSharing
//
//  Created by Charley Robinson on 3/17/16.
//  Copyright © 2016 TokBox, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for S3FileSharing.
FOUNDATION_EXPORT double S3FileSharingVersionNumber;

//! Project version string for S3FileSharing.
FOUNDATION_EXPORT const unsigned char S3FileSharingVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <S3FileSharing/PublicHeader.h>


@interface S3FileSharing : NSObject

@property (nonatomic, retain) NSString* bucket;

- (instancetype)initWithAccessKey:(NSString*)key secret:(NSString*)secret;
- (void)uploadFile:(NSURL*)file;
- (void)releaseFile:(NSString*)key;

@end