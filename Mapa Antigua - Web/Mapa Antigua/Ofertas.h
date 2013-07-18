//
//  Ofertas.h
//  Aqui en Antigua
//
//  Created by Luis Angel Ramos Gomez on 17/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Idioma.h"
#import "local.h"
#import "AppDelegate.h"
#import "FBShowController.h"

@protocol Ofertasdelegate <NSObject>
-(void)cerrarinfoimagen;
@end

@interface Ofertas : UIViewController<UIScrollViewDelegate,FBShowDelegate,UIActionSheetDelegate>{
    AppDelegate *appDelegate;
    TWTweetComposeViewController *tweet;
    
    UIImageView *imagenselect;
    UIActivityIndicatorView *indicador;
    
    __weak id<Ofertasdelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *buttonPagina;
@property(weak,nonatomic) id<Ofertasdelegate> delegate;
@property (strong, nonatomic) TWTweetComposeViewController *tweet;

@property (nonatomic,retain) NSString *localseleccionado;

@property (nonatomic,retain ) Idioma *selectidioma;
@property (nonatomic,retain) local *auxlocal;

@property (nonatomic,retain) NSOperationQueue *queue;

-(void)cargarinfolocal;
-(void)cambiaridioma:(Idioma *)idiom;

@end
