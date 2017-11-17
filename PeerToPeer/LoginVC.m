//
//  LoginVC.m
//  PeerToPeer
//
//  Created by Shariif Islam on 8/30/16.
//  Copyright © 2016 myth. All rights reserved.
//

#import "LoginVC.h"
#import "MCManager.h"
#import "DiscoverVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)startAction:(id)sender {
    
    if (![_tf_name.text isEqualToString:@""]) {
        MCManager *mcManager = [MCManager sharedInstance];
        [mcManager setupPeerAndSessionWithDisplayName:_tf_name.text];
        [mcManager setupMCBrowser];
        [mcManager advertiseSelf:YES];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DiscoverVC *vc = [sb instantiateViewControllerWithIdentifier:@"discovervc"];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }

}
@end
