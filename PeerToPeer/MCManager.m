//
//  MCManager.m
//  MCDemo
//
//  Created by Shariif Islam on 8/30/16.
//  Copyright © 2016 myth. All rights reserved.
//

#import "MCManager.h"
#import "Peer.h"

NSMutableArray *mAr_foundPeer;
NSArray *ar_invitationHandler;

@implementation MCManager

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        _peerID = nil;
        _session = nil;
        _nearByServiceBrowser = nil;
        _nearByServiceAdvertiser= nil;
        
        mAr_foundPeer = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+(MCManager*) sharedInstance{
    
    static MCManager* _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedInstance = [[MCManager alloc] init];
    });
    
    return _sharedInstance;
}

#pragma user define methods

-(NSDictionary*) getMyInfo{
 
    UIDevice *device = [UIDevice currentDevice];
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:currentDeviceId, @"UNIQUE_ID", nil];

    return info;
  
}



-(Peer*) getPeerByPeerID : (MCPeerID*) peerID{

    for (Peer *peer in mAr_foundPeer) {
        if (peer.peerID == peerID){
            return peer;
        }
    }
    return nil;
}

-(void)setupPeerAndSessionWithDisplayName:(NSString*)displayName{
    
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
    
}

-(void)setupMCBrowser{
    
    _nearByServiceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerID serviceType:@"peer-to-peer"];
    [_nearByServiceBrowser setDelegate:self];
    [_nearByServiceBrowser startBrowsingForPeers];
    
}

-(void)advertiseSelf:(BOOL)shouldAdvertise {
    
    if (shouldAdvertise) {
        
        NSLog(@"advertising peer ID ---- %@",_peerID);
        _nearByServiceAdvertiser = [[MCNearbyServiceAdvertiser alloc]initWithPeer:_peerID discoveryInfo:[self getMyInfo] serviceType:@"peer-to-peer"];
        _nearByServiceAdvertiser.delegate = self;
        [_nearByServiceAdvertiser startAdvertisingPeer];
        
    }else{
    
        [_nearByServiceAdvertiser stopAdvertisingPeer];
        _nearByServiceAdvertiser = nil;
    }
}

-(void) invitePeer:(Peer*) peer{

    [_nearByServiceBrowser invitePeer:peer.peerID toSession:_session withContext:nil timeout:0];
}

-(void) acceptInvitation{

    void (^invitationHandler)(BOOL, MCSession *) = [ar_invitationHandler objectAtIndex:0];
    invitationHandler(YES, self.session);
    
}

#pragma MCSession Delegate

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
   
    Peer *peer = [self getPeerByPeerID:peerID];
    
    if (state == MCSessionStateNotConnected) {
        
        [peer setSessionState:NOT_CONNECTED];
        [self.delegate didChangeState:NOT_CONNECTED peerID:peer];
        
    } else if (state == MCSessionStateConnecting) {

        [peer setSessionState:CONNECTING];
        [self.delegate didChangeState:CONNECTING peerID:peer];
        
    } if (state == MCSessionStateConnected) {
        
        [peer setSessionState:CONNECTED];
        [self.delegate didChangeState:CONNECTED peerID:peer];

    }
    
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

- (void)        session:(MCSession *)session
  didReceiveCertificate:(nullable NSArray *)certificate
               fromPeer:(MCPeerID *)peerID
     certificateHandler:(void (^)(BOOL accept))certificateHandler{
    
    certificateHandler(YES);

}


#pragma MCNearbyServicebrowser Delegate

- (void)        browser:(MCNearbyServiceBrowser *)browser
              foundPeer:(MCPeerID *)peerID
      withDiscoveryInfo:(nullable NSDictionary<NSString *, NSString *> *)info{

    
    Peer *peer = [[Peer alloc] initWithIDAndName:peerID sessionState:NOT_CONNECTED uuid:[info valueForKey:@"UNIQUE_ID"]];
    
    [mAr_foundPeer addObject:peer];
    [self.delegate getFoundPeer:peer];
    
}


- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID{

    Peer *peer = [self getPeerByPeerID:peerID];
    
    [mAr_foundPeer removeObject:peer];
    [self.delegate lostPeer:peer];
    
}


#pragma MCNearbyServiceAdvertiser Delegate

- (void)            advertiser:(MCNearbyServiceAdvertiser *)advertiser
  didReceiveInvitationFromPeer:(MCPeerID *)peerID
                   withContext:(nullable NSData *)context
             invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler{
    
    Peer *peer = [self getPeerByPeerID:peerID];
    
    ar_invitationHandler = [NSArray arrayWithObject:[invitationHandler copy]];
    [self.delegate receivedInvitation:peer];
  
}

@end
