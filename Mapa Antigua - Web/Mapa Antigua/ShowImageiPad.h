//
//  ShowImageiPad.h
//  Aqui en Antigua
//
//  Created by Luis Angel Ramos Gomez on 18/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Idioma.h"
#import "local.h"
#import "AppDelegate.h"
#import "FBShowController.h"

@protocol ShowImageiPaddelegate <NSObject>
@optional
-(void)cerrarshow;
@end

@interface ShowImageiPad : UIViewController<UIScrollViewDelegate,FBShowDelegate>{
    AppDelegate *appDelegate;
    TWTweetComposeViewController *tweet;
    
    UIImageView *imagenselect;
    UIActivityIndicatorView *indicador;
    
   // __weak id<Ofertasdelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *buttonPagina;
//@property(weak,nonatomic) id<Ofertasdelegate> delegate;
@property (nonatomic) CGSize sizepop;
@property (strong, nonatomic) TWTweetComposeViewController *tweet;

@property (nonatomic,retain) NSString *localseleccionado;

@property (nonatomic,retain ) Idioma *selectidioma;
@property (nonatomic,retain) local *auxlocal;

@property (nonatomic,retain) NSOperationQueue *queue;

-(void)cargarinfolocal;
-(void)cambiaridioma:(Idioma *)idiom;
@end
