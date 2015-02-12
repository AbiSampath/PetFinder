//
//  ProximityController.h
//  petalert
//
//  Created by Abinaya Sampath on 11/15/14.
//  Copyright (c) 2014 Abinaya Sampath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProximityController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *beaconName;
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *status;



@end

