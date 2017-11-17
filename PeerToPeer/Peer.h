//
//  Peer.h
//  PeerToPeer
//
//  Created by Shariif Islam on 8/31/16.
//  Copyright © 2016 myth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface Peer : NSObject

@property (nonatomic,strong) MCPeerID *peerID;
@property (nonatomic,strong) NSString *sessionState;
@property (nonatomic,strong) NSString *uuid;


-(id) initWithIDAndName:(MCPeerID*)peerID sessionState:(NSString*)sessionState uuid:(NSString*)uuid;

@end
