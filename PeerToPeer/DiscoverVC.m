//
//  ViewController.m
//  PeerToPeer
//
//  Created by Shariif Islam on 8/30/16.
//  Copyright © 2016 myth. All rights reserved.
//

#import "DiscoverVC.h"
#import "Peer.h"

@interface DiscoverVC ()

@end

NSMutableArray *mar_connectedDevices;
MCManager *mcManager;
UIButton *btn_dis_connect;
UIActivityIndicatorView *indicator;
NSString *_sessionState;

@implementation DiscoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mar_connectedDevices = [[NSMutableArray alloc] init];
    mcManager = [MCManager sharedInstance];
    mcManager.delegate = self;
    
    _sessionState = NOT_CONNECTED;
    
}

-(void) viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)connectOrNot:(id)sender {
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:touchPoint];
    
    [mcManager invitePeer:[mar_connectedDevices objectAtIndex:indexPath.row]];
    
}


-(Peer*) getPeerByPeerID : (MCPeerID*) peerID{
    
    for (Peer *peer in mar_connectedDevices) {
        if (peer.peerID == peerID){
            return peer;
        }
    }
    return nil;
}


// MCManager Delegate
-(void) getFoundPeer:(Peer*)peerID
{
    
    [mar_connectedDevices addObject:peerID];
    
    NSUInteger index = [mar_connectedDevices indexOfObject:peerID];

    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
    [_tableView endUpdates];
    
}

-(void) lostPeer:(Peer*)peer{

    NSUInteger index = [mar_connectedDevices indexOfObject:peer];
    [mar_connectedDevices removeObject:peer];

    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
    [_tableView endUpdates];
}

-(void) receivedInvitation:(Peer*)peer{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:peer.peerID.displayName
                                  message:@"Would like to create a session with you"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* accept = [UIAlertAction actionWithTitle:@"accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [mcManager acceptInvitation];
        [peer setSessionState:CONNECTED];
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:accept];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) didChangeState:(NSString*) sessionState peerID:(Peer*)peer{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSUInteger index = [mar_connectedDevices indexOfObject:peer];
        
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];

    });
    
}

#pragma tableView delegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [mar_connectedDevices count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell select ----");
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"tableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *lb_name = (UILabel *)[tableView viewWithTag:100];
    btn_dis_connect = (UIButton *)[tableView viewWithTag:101];
    indicator = (UIActivityIndicatorView *)[tableView viewWithTag:102];
    
    //make round button
    btn_dis_connect.layer.cornerRadius = 7.5;

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    Peer *peer = [mar_connectedDevices objectAtIndex:indexPath.row];
    
    if ([peer.sessionState isEqualToString:CONNECTED]) {
        
         [indicator stopAnimating];
         indicator.hidden = YES;
        
         btn_dis_connect.hidden = NO;
        [btn_dis_connect setBackgroundColor:[UIColor greenColor]];
        
    } else if ([peer.sessionState isEqualToString:CONNECTING]){
    
        btn_dis_connect.hidden = YES;
        indicator.hidden = NO;
        
        [indicator startAnimating];
        
    } else {
    
        btn_dis_connect.hidden = NO;
        [btn_dis_connect setBackgroundColor:[UIColor redColor]];
        
        [indicator setColor:[UIColor redColor]];
        indicator.hidden = YES;
        
    }

    lb_name.text = [[[mar_connectedDevices objectAtIndex:indexPath.row]peerID] displayName];
    
    return cell;
}




@end
