//
//  OTSession+(S3FileSharing).h
//  Pods
//
//  Created by Charley Robinson on 3/21/16.
//
//

#import <Foundation/Foundation.h>

#import <OpenTok/OpenTok.h>

@interface OTFileSharingSession : OTSession

// Initialize as usual, but be aware that we are taking over the delegate, so
// OTSession.delegate will be broken if you use this class.
- (id)initWithApiKey:(NSString*)apiKey
           sessionId:(NSString*)sessionId
            delegate:(id<OTSessionDelegate>)delegate;

// Pass null for connection to send to all participants in the call
-(void)sendFile:(NSURL*)file
   toConnection:(OTConnection*)connection;

// Some other ideas:
//-(NSArray*)filesUploadedToSession;
//-(NSArray*)filesFromConnection:(OTConnection*)connection;
//@property (nonatomic) BOOL automaticallyDownloadsIncomingFiles;
//@property (nonatomic) BOOL fileCompressionEnabled;

@end

@protocol OTFileSharingSessionDelegate <OTSessionDelegate>

- (void)session:(OTSession*)session
   receivedFile:(NSURL*)file
 fromConnection:(OTConnection*)connection;

//Some other ideas:
//-(void)file:didBeginSending:
//-(void)fileDidSend:
//-(void)file:sendProgress:

@end