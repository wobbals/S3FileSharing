//
//  OTDelegateInterceptor.h
//  Pods
//
//  Created by Charley Robinson on 3/21/16.
//
//

#import <Foundation/Foundation.h>

#import <OpenTok/OTSession.h>

// Used for intercepting delegate messages for special processing by an external
// class, in this case the OTSession additions for file sharing.
@interface OTSessionDelegateInterceptor : NSObject <OTSessionDelegate>

@property (nonatomic, assign) id receiver;
@property (nonatomic, assign) id middleMan;

@end
