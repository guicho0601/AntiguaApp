//
//  AppDelegate.m
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define page @"http://iriarchitect.com/guowmaps/paginasguowapp/"

NSString *const FBSessionStateChangedNotification =
@"com.facebook.samples.FeedDialogHowTo:FBSessionStateChangedNotification";

@implementation AppDelegate

@synthesize window = _window;
@synthesize databaseName,databasePath;

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                //NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

/*
 *
 */
- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

-(Boolean)conexion{
    Boolean test=false;
    NSString *url = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://iriarchitect.com"] encoding:NSStringEncodingConversionExternalRepresentation error:nil];
    if (url != NULL) test=true;
    return test;
}

-(void)phptexto{
    NSFileManager *mgfile = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directorio = [path objectAtIndex:0];
    NSString *file;
    
    NSString *url = [NSString stringWithFormat:@"%@servicio.php",page];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *s = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    file = [directorio stringByAppendingFormat:@"/servicio.txt"];
    if (![mgfile fileExistsAtPath:file]) {
        [mgfile createFileAtPath:file contents:nil attributes:nil];
        
    }
    [s writeToFile:file atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    url = [NSString stringWithFormat:@"%@categoria.php",page];
    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    s = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    file = [directorio stringByAppendingFormat:@"/categoria.txt"];
    if (![mgfile fileExistsAtPath:file]) {
        [mgfile createFileAtPath:file contents:nil attributes:nil];
    }
    [s writeToFile:file atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    url = [NSString stringWithFormat:@"%@lugar.php",page];
    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    s = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    file = [directorio stringByAppendingFormat:@"/lugar.txt"];
    if (![mgfile fileExistsAtPath:file]) {
        [mgfile createFileAtPath:file contents:nil attributes:nil];
    }
    [s writeToFile:file atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    url = [NSString stringWithFormat:@"%@img_lugar.php",page];
    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    s = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    file = [directorio stringByAppendingFormat:@"/img_lugar.txt"];
    if (![mgfile fileExistsAtPath:file]) {
        [mgfile createFileAtPath:file contents:nil attributes:nil];
    }
    [s writeToFile:file atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    url = [NSString stringWithFormat:@"%@mapa.php",page];
    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    s = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    file = [directorio stringByAppendingFormat:@"/mapa.txt"];
    if (![mgfile fileExistsAtPath:file]) {
        [mgfile createFileAtPath:file contents:nil attributes:nil];
    }
    [s writeToFile:file atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    file = [directorio stringByAppendingFormat:@"/visitados.txt"];
    if (![mgfile fileExistsAtPath:file]) {
        [mgfile createFileAtPath:file contents:nil attributes:nil];
    }    
}

-(BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                return YES;
            }
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    return YES;
                }
            }
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BOOL conect = [self hasConnectivity];
    if (!conect) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No WIFI available!", @"AlertView")
            message:NSLocalizedString(@"You have no wifi connection available. Please connect to a WIFI network. The application will not work correctly", @"AlertView")
            delegate:self
            cancelButtonTitle:NSLocalizedString(@"Ok", @"AlertView")
            otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        
    }
    BOOL b = [self conexion];
    if (b) {
        [self phptexto];
    }
    Descargar_imagenes *di = [[Descargar_imagenes alloc]init];
    [di iniciar_descarga];
    // Set the application defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"0"
                                                            forKey:@"lenguaje"];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:3];
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        /**UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;*/
        
        
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Regresando");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [FBSession.activeSession close];
}

@end
