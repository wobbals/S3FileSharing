//
//  OTFileSharingSession.m
//
//  Created by Charley Robinson on 3/21/16.
//
//

#import "OTFileSharingSession.h"
#import "OTSessionDelegateInterceptor.h"
#import "S3FileSharing.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

#define FILE_SHARING_SIGNAL_TYPE @"OT_S3_FILE_SHARING"

@interface OTFileSharingSession () <S3FileSharingDelegate>

@end

@implementation OTFileSharingSession {
    OTSessionDelegateInterceptor* _delegateInterceptor;
    S3FileSharing* _fileSharing;
    NSMutableDictionary* _uploadTasks;
    NSMutableDictionary* _downloadTasks;
}

static int ddLogLevel = DDLogLevelDebug;

- (id)initWithApiKey:(NSString*)apiKey
           sessionId:(NSString*)sessionId
            delegate:(id<OTSessionDelegate>)delegate
{
    self = [super initWithApiKey:apiKey sessionId:sessionId delegate:delegate];
    if (self) {
        _delegateInterceptor = [[OTSessionDelegateInterceptor alloc] init];
        [_delegateInterceptor setReceiver:self.delegate];
        [_delegateInterceptor setMiddleMan:self];
        [super setDelegate:(id<OTSessionDelegate>)_delegateInterceptor];
        
        _fileSharing = [[S3FileSharing alloc] initWithDelegate:self];
        [_fileSharing setPrefix:self.sessionId];
        
        _uploadTasks = [[NSMutableDictionary alloc] init];
        _downloadTasks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Public API

-(void)sendFile:(NSURL*)file
   toConnection:(OTConnection*)connection
{
    [_fileSharing uploadFile:file];
    if (nil == connection) {
        [_uploadTasks setObject:[NSNull null] forKey:file];
    } else {
        [_uploadTasks setObject:connection forKey:file];
    }
}

#pragma mark - S3FileSharingDelegate


-(void)file:(NSURL*)file uploadCompletedWithKey:(NSString*)key
      error:(NSError*)nsError
{
    if (nsError) {
        DDLogError(@"Aborting sendFile:%@", file);
        return;
    }
    OTConnection* connection = [_uploadTasks objectForKey:file];
    DDLogInfo(@"Notifying %@ of upload %@", connection.connectionId, key);
    OTError* otError = nil;
    [self signalWithType:FILE_SHARING_SIGNAL_TYPE
                  string:key
              connection:connection
                   error:&otError];
    if (otError) {
        DDLogError(@"Unable to signal uploaded file:%@", file);
    }
}

-(void)file:(NSURL*)file downloadCompletedWithKey:(NSString*)key
      error:(NSError*)error
{
    if (error) {
        DDLogError(@"Aborting download notification for key %@", key);
        return;
    }
    [_delegateInterceptor.receiver session:self
                              receivedFile:file
                            fromConnection:[_downloadTasks objectForKey:file]];
}

#pragma mark - Delegate Interception

- (void)setDelegate:(id<OTSessionDelegate>)delegate
{
    // we're not initialized in the subclass yet.
    if (nil == _delegateInterceptor) {
        [super setDelegate:delegate];
    } else {
        [_delegateInterceptor setReceiver:delegate];
    }
}

#pragma mark - Intercepted Signals

- (void)   session:(OTSession*)session
receivedSignalType:(NSString*)type
    fromConnection:(OTConnection*)connection
        withString:(NSString*)string
{
    if ([type isEqualToString:FILE_SHARING_SIGNAL_TYPE]) {
        NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory()
                                      isDirectory:YES];
        NSUUID* uuid = [NSUUID UUID];
        NSURL *fileURL = [tmpDirURL URLByAppendingPathComponent:uuid.UUIDString];
        [_fileSharing downloadKey:string toURL:fileURL];
        
        if (nil == connection) {
            [_downloadTasks setObject:[NSNull null] forKey:fileURL];
        } else {
            [_downloadTasks setObject:connection forKey:fileURL];
        }

    } else {
        [_delegateInterceptor.receiver session:session
                            receivedSignalType:type
                                fromConnection:connection
                                    withString:string];
    }
}
@end
