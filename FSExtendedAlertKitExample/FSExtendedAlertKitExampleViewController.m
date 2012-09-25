//
//  FSViewController.m
//  FSExtendedAlertKitExample
//
//	Copyright (c) 2012, emdentec (Elliot Neal)
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without
//	modification, are permitted provided that the following conditions are met:
//		* Redistributions of source code must retain the above copyright
//		  notice, this list of conditions and the following disclaimer.
//		* Redistributions in binary form must reproduce the above copyright
//		  notice, this list of conditions and the following disclaimer in the
//		  documentation and/or other materials provided with the distribution.
//		* Neither the name of emdentec nor the
//		  names of its contributors may be used to endorse or promote products
//		  derived from this software without specific prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY
//	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Show", @"Another", @"And Another", nil];
    
    [alert show];
}

- (IBAction)showFSAlertButtonPressed:(id)sender {
    
    FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"Dismiss" block:^ {
        NSLog(@"Dismiss button pressed");
    }];
    FSBlockButton *showButton = [FSBlockButton blockButtonWithTitle:@"Show" block:^ {
        NSLog(@"Show button pressed");
    }];
    FSBlockButton *anotherButton = [FSBlockButton blockButtonWithTitle:@"Another" block:^ {
        NSLog(@"Another button pressed");
    }];
    FSBlockButton *andAnotherButton = [FSBlockButton blockButtonWithTitle:@"And Another" block:^ {
        NSLog(@"And Another button pressed");
    }];
    
    FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"Title" message:@"Message" cancelButton:cancelButton otherButtons:showButton, anotherButton, andAnotherButton, nil];
    
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
