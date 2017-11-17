//
//  ViewController.h
//  PeerToPeer
//
//  Created by Shariif Islam on 8/30/16.
//  Copyright © 2016 myth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCManager.h"

@interface DiscoverVC : UIViewController <UITableViewDelegate,UITableViewDataSource,MCManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)connectOrNot:(id)sender;

@end

