# FSExtendedAlertKit

FSExtendedAlertKit provides simple ```UIAlertView``` alternatives for showing progress. There are three primary classes:

```FSAlertView``` is a wrapper that provides block-based callbacks instead of the standard delegate implementation (based on PSAlertView from the PSFoundation library - https://github.com/steipete/PSFoundation)

```FSActivityIndicatorAlertView``` shows indeterminate progress by displaying a ```UIActivityIndicatorView``` inside the ```UIAlertView```

```FSProgressAlertView``` shows determinate progress by displaying a ```UIProgressView``` inside the ```UIAlertView```