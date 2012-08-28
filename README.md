# FSExtendedAlertKit

FSExtendedAlertKit provides simple ```UIAlertView``` alternatives for showing progress. There are three primary classes:

## FSAlertView

```FSAlertView``` is a wrapper that provides block-based callbacks instead of the standard delegate implementation (based on PSAlertView from the PSFoundation library - https://github.com/steipete/PSFoundation)

```objc
FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"Alert" message:@"Something needs your confirmation." cancelButtonTitle:@"Dismiss" cancelButtonBlock:^ {
    // do something when the cancel button is pressed
}];

[alert addButtonWithTitle:@"Confirm" block:^ {
    // do something when this button is pressed
}];

[alert show];
```

## FSActivityIndicatorAlertView

```FSActivityIndicatorAlertView``` shows indeterminate progress by displaying a ```UIActivityIndicatorView``` inside the ```UIAlertView```

```objc
FSActivityIndicatorAlertView *alert = [[FSActivityIndicatorAlertView alloc] initWithTitle:@"Alert" @"Something is happening and might take a while."];

[alert show];

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
    
    // do something that takes a while
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        [alert dismiss:YES];
    });
});
```

## FSProgressAlertView

```FSProgressAlertView``` shows determinate progress by displaying a ```UIProgressView``` inside the ```UIAlertView```

```objc
FSProgressAlertView *alert = [[FSProgressAlertView alloc] initWithTitle:@"Alert" @"Something is happening and might take a while."];

[alert show];
    
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
    
    // do something that takes a while
    
    [alert setProgress:0.1f animated:YES];
    ...
    [alert setProgress:0.5f animated:YES];
    ...
    [alert setProgress:0.8f animated:YES];
    ...
    [alert setProgress:1.f animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        
        [alert dismiss:YES];
    });
});
```