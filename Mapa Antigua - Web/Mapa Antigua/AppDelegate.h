//
//  AppDelegate.h
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Descargar_imagenes.h"
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *databaseName;
    NSString *databasePath;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSString *databaseName;
@property (nonatomic, retain) NSString *databasePath;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;

@end
