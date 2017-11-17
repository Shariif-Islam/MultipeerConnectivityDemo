//
//  LoginVC.h
//  PeerToPeer
//
//  Created by Shariif Islam on 8/30/16.
//  Copyright © 2016 myth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tf_name;
@property (weak, nonatomic) IBOutlet UIButton *btn_start;
- (IBAction)startAction:(id)sender;

@end
