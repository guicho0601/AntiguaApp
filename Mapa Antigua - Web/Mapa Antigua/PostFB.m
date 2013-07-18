//
//  PostFB.m
//  Antigua Wow!
//
//  Created by Rh_M on 16/07/13.
//
//

#import "PostFB.h"

@implementation PostFB

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

-(void)postwall:(int)idlocal nombre:(NSString*)name{
    NSString *i = [NSString stringWithFormat:@"%d",idlocal];
    NSString *url = [NSString stringWithFormat:@"http://iriarchitect.com/guowapp/iconosfb/foto%@.jpg",i];
    NSString *mensaje = [NSString stringWithFormat:@"Guow! Check out this place! Just find it using GuowAntigua on the "];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) mensaje = [mensaje stringByAppendingFormat:@"iPad! "];
    else mensaje = [mensaje stringByAppendingFormat:@"iPhone! "];
    
    mensaje = [mensaje stringByAppendingFormat:@"Guatemala is awesome."];
    
    // Put together the dialog parameters
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"Guow Antigua", @"name",
     name, @"caption",
     mensaje, @"description",
     @"http://guowmaps.com", @"link",
     url, @"picture",
     nil];
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *msg = [NSString stringWithFormat:
                                      @"Posted place in your wall"];
                     NSLog(@"%@", msg);
                     // Show the result in an alert
                     [[[UIAlertView alloc] initWithTitle:@"Result"
                                                 message:msg
                                                delegate:nil
                                       cancelButtonTitle:@"OK!"
                                       otherButtonTitles:nil]
                      show];
                 }
             }
         }
     }];
}

@end
