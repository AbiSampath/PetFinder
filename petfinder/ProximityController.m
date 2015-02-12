//
//  ProximityController.m
//  petalert
//
//  Created by Abinaya Sampath on 11/15/14.
//  Copyright (c) 2014 Abinaya Sampath. All rights reserved.
//

#import "ProximityController.h"
#import <FYX/FYX.h>
#import <FYX/FYXVisitManager.h>
#import <FYX/FYXVisit.h>
#import <FYX/FYXSightingManager.h>
#import <FYX/FYXTransmitter.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>


@interface ProximityController ()

@property (nonatomic) FYXVisitManager *visitManager;
@property (assign) SystemSoundID alarmSound;


@end

@implementation ProximityController

- (void)viewDidLoad {
    
    UIImage *pic = [UIImage imageNamed: @"puppy.jpg"];
    if (pic != nil) {
        [self.imageView setImage:pic];
        [self.imageView setUserInteractionEnabled:NO];
    }
    
    [super viewDidLoad];
    
    [FYX startService:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)serviceStarted
{
    NSLog(@"Service Started");
    self.visitManager = [FYXVisitManager new];
    self.visitManager.delegate = self;
    NSMutableDictionary *options = [NSMutableDictionary new];
    [options setObject:[NSNumber numberWithInt:-40] forKey:FYXVisitOptionArrivalRSSIKey];
    [options setObject:[NSNumber numberWithInt:-45] forKey:FYXVisitOptionDepartureRSSIKey];
    [self.visitManager startWithOptions:options];
}

- (void)startServiceFailed:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)didArrive:(FYXVisit *)visit;
{
    
    NSLog(@"Found a Gimbal Beacon %@", visit.transmitter.name);
}
- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
    
    self.beaconName.text=visit.transmitter.name;
    self.status.text=@"Yes";
    
    NSLog(@"Beacon is in sighting!!! %@", visit.transmitter.name);
}
- (void)didDepart:(FYXVisit *)visit;

{
    
    NSString *alarmPath = [[NSBundle mainBundle]
                           pathForResource:@"alarm" ofType:@"mp3"];
    NSURL *alarmURL = [NSURL fileURLWithPath:alarmPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)alarmURL, &_alarmSound);
    AudioServicesPlaySystemSound(self.alarmSound);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pet Alert" message:@"Pet is not in proximity" delegate:self cancelButtonTitle:@"Stop" otherButtonTitles:nil];
    [alert show];
    
    NSLog(@"Pet is not in proximity!!! %@", visit.transmitter.name);
    NSLog(@"Time around the beacon %f", visit.dwellTime);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        AudioServicesDisposeSystemSoundID(_alarmSound);
    }
    
}

@end
