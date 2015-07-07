# FSExtendedAlertKit

-----

N.B. `FSExtendedAlertKit` is deprecated. Use `UIAlertController`, it's good.

-----

FSExtendedAlertKit provides simple ```UIAlertView``` alternatives for showing progress. There are five primary classes:

## FSBlockButton

```FSBlockButton``` is a simple ```NSObject``` subclass, which provides a wrapper for a button with a title and a callback block

```objc
FSBlockButton *blockButton = [FSBlockButton blockButtonWithTitle:@"A button" block:^ {
    // do something when the button is pressed
}];
```

## FSAlertView

```FSAlertView``` is a wrapper that provides block-based callbacks instead of the standard delegate implementation (based on PSAlertView from the PSFoundation library - https://github.com/steipete/PSFoundation)

```objc
FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"Cancel" block:^ {
    // do something when the cancel button is pressed
}];

FSBlockButton *confirmButton = [FSBlockButton blockButtonWithTitle:@"Confirm" block:^ {
    // do something when the confirm button is pressed
}];

FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"Alert" message:@"Something needs your confirmation." cancelButton:cancelButton otherButtons:confirmButton, nil];

[alert show];
```

## FSActivityIndicatorAlertView

```FSActivityIndicatorAlertView``` shows indeterminate progress by displaying a ```UIActivityIndicatorView``` inside the ```UIAlertView```

```objc
FSActivityIndicatorAlertView *alert = [[FSActivityIndicatorAlertView alloc] initWithTitle:@"Alert" message:@"Something is happening and might take a while."];

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
FSProgressAlertView *alert = [[FSProgressAlertView alloc] initWithTitle:@"Alert" message:@"Something is happening and might take a while."];

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

## FSActionSheet

```FSActionSheet``` is a wrapper that provides block-based callbacks instead of the standard delegate implementation (based on PSActionSheet from the PSFoundation library - https://github.com/steipete/PSFoundation)

```objc
FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:@"Cancel" block:^ {
    // do something when the cancel button is pressed
}];

FSBlockButton *deleteButton = [FSBlockButton blockButtonWithTitle:@"Delete" block:^ {
    // do something when the delete button is pressed
}];

FSBlockButton *editButton = [FSBlockButton blockButtonWithTitle:@"Edit" block:^ {
    // do something when the edit button is pressed
}];

FSActionSheet *actionSheet = [[FSActionSheet alloc] initWithTitle:nil cancelButton:cancelButton destructiveButton:deleteButton otherButtons:editButton, nil];

[actionSheet showInView:self.view];
```
