//
//  MCManager.h
//  MCDemo
//
//  Created by Shariif Islam on 8/30/16.
//  Copyright © 2016 myth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "Peer.h"

@protocol MCManagerDelegate;

@interface MCManager : NSObject <MCSessionDelegate,MCNearbyServiceAdvertiserDelegate,MCNearbyServiceBrowserDelegate>

@property (weak,nonatomic) id <MCManagerDelegate> delegate;

@property (readonly,nonatomic) MCPeerID *peerID;
@property (readonly,nonatomic) MCSession *session;
@property (readonly,nonatomic) MCNearbyServiceAdvertiser *nearByServiceAdvertiser;
@property (readonly,nonatomic) MCNearbyServiceBrowser *nearByServiceBrowser;

+(MCManager*) sharedInstance;
-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;
-(void) invitePeer:(Peer*) peer;
-(void) acceptInvitation;

@end

@protocol MCManagerDelegate <NSObject>

//-(void) getFoundPeer:(MCPeerID*)peerID;
-(void) getFoundPeer:(Peer*)peer;
-(void) lostPeer:(Peer*)peer;
-(void) receivedInvitation:(Peer*)peer;
-(void) didChangeState:(NSString*) sessionState peerID:(Peer*)peer;

@end