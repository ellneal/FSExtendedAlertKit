//
//  FSViewController.m
//  FSExtendedAlertKitExample
//
//  Created by Elliot Neal on 21/08/2012.
//  Copyright (c) 2012 emdentec. All rights reserved.
//

#import "FSExtendedAlertKitExampleViewController.h"


@interface FSExtendedAlertKitExampleViewController () <UIAlertViewDelegate>

@end


@implementation FSExtendedAlertKitExampleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    
    return YES;
}


#pragma mark - Events

- (IBAction)showUIAlertButtonPressed:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    
    [alert addButtonWithTitle:@"Another"];
    [alert addButtonWithTitle:@"And Another"];
    
    [alert show];
    
    NSLog(@"Cancel button index: %d", [alert cancelButtonIndex]);
}

- (IBAction)showFSAlertButtonPressed:(id)sender {
    
    FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"Title" message:@"Message" cancelButtonTitle:@"Dismiss" cancelButtonBlock:^ {
        NSLog(@"Cancel button pressed.");
    }];
    
    [alert addButtonWithTitle:@"Show" block:^ {
        NSLog(@"Show button pressed.");
    }];
    
    [alert setCancelBlock:^ {
        NSLog(@"Cancelled.");
    }];
    [alert setWillPresentBlock:^ {
        NSLog(@"Will present.");
    }];
    [alert setDidPresentBlock:^ {
        NSLog(@"Did present.");
    }];
    [alert setWillDismissBlock:^ {
        NSLog(@"Will dismiss.");
    }];
    [alert setDidDismissBlock:^ {
        NSLog(@"Did dismiss.");
    }];
    
    [alert show];
}

- (IBAction)showFSActivityIndicatorAlertButtonPressed:(id)sender {
    
    FSActivityIndicatorAlertView *alert = [[FSActivityIndicatorAlertView alloc] initWithTitle:@"Title of the alert" message:nil];//@"The message\nThe message\nThe message\nThe message"];
    
    [alert setCancelBlock:^ {
        NSLog(@"Cancelled.");
    }];
    [alert setWillPresentBlock:^ {
        NSLog(@"Will present.");
    }];
    [alert setDidPresentBlock:^ {
        NSLog(@"Did present.");
    }];
    [alert setWillDismissBlock:^ {
        NSLog(@"Will dismiss.");
    }];
    [alert setDidDismissBlock:^ {
        NSLog(@"Did dismiss.");
    }];
    
    [alert show];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [alert dismiss:YES];
    });
}

- (IBAction)showFSProgressAlertViewButtonPressed:(id)sender {
    
    FSProgressAlertView *alert = [[FSProgressAlertView alloc] initWithTitle:@"Title of the alert" message:nil];//@"The message\nThe message\nThe message\nThe message"];
    [alert setCancelBlock:^ {
        NSLog(@"Cancelled.");
    }];
    [alert setWillPresentBlock:^ {
        NSLog(@"Will present.");
    }];
    [alert setDidPresentBlock:^ {
        NSLog(@"Did present.");
    }];
    [alert setWillDismissBlock:^ {
        NSLog(@"Will dismiss.");
    }];
    [alert setDidDismissBlock:^ {
        NSLog(@"Did dismiss.");
    }];
    
    [alert show];
    
    [alert setProgress:.1f animated:YES];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        
        [alert setProgress:.5f animated:YES];
        
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            
            [alert setProgress:.75f animated:YES];
            
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                
                [alert setProgress:1.f animated:YES];
                
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    
                    [alert dismiss:YES];
                });
            });
        });
    });
}


#pragma mark - UIAlertViewDelegate

- (void)alertViewCancel:(UIAlertView *)alertView {
    
    NSLog(@"Cancelled alert");
}

@end
