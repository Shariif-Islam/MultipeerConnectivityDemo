//
//  MyInfo.m
//  PeerToPeer
//
//  Created by Shariif Islam on 8/31/16.
//  Copyright © 2016 myth. All rights reserved.
//

#import "MyInfo.h"


static MyInfo* _sharedInstance;

@implementation MyInfo


-(MyInfo*) sharedInstance{

    if (_sharedInstance == nil) {
        _sharedInstance = [[MyInfo alloc] init];
    }
    
    return _sharedInstance;
}


@end
