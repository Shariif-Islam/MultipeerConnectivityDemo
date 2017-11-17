//
//  Peer.m
//  PeerToPeer
//
//  Created by Shariif Islam on 8/31/16.
//  Copyright © 2016 myth. All rights reserved.
//

#import "Peer.h"

@implementation Peer

-(id) initWithIDAndName:(MCPeerID*)peerID sessionState:(NSString *)sessionState uuid:(NSString *)uuid{
    
    self = [self init];
    
    _peerID = peerID;
    _sessionState = sessionState;
    _uuid = uuid;
    
    return self;
}

@end
