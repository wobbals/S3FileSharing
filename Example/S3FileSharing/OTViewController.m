//
//  OTViewController.m
//  S3FileSharing
//
//  Created by Charley Robinson on 03/18/2016.
//  Copyright (c) 2016 Charley Robinson. All rights reserved.
//

#import "OTViewController.h"
#import <S3FileSharing/S3FileSharing.h>

@interface OTViewController ()

@end

@implementation OTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // highly recommend not using static credentials in your app binary
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString* key = [settings valueForKey:@"AWS_KEY"];
    NSString* secret = [settings valueForKey:@"AWS_SECRET"];
    
    S3FileSharing* fileSharing =
    [[S3FileSharing alloc] initWithAccessKey:key secret:secret];

    NSLog(@"Generate test data");
    // Create a test file in the temporary directory
    NSMutableString *dataString = [NSMutableString new];
    for (int32_t i = 1; i < 5000000; i++) {
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

@end
