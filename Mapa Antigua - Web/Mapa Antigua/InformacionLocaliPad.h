//
//  InformacionLocaliPad.h
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
#import "Turismo.h"
#import "ShowImage.h"
#import "PostFB.h"

@interface InformacionLocaliPad : UIViewController<UIActionSheetDelegate,UIScrollViewDelegate,ShowImageDelegate>{
    AppDelegate *appDelegate;
    TWTweetComposeViewController *tweet;
    UIActivityIndicatorView *indicador;
    
    UIImageView *imagenselect;
    NSTimer *autoTimer;
    
    BOOL pageControlBeingUsed;
}

@property (strong, nonatomic) IBOutlet UILabel *labelTitulo;
@property (strong, nonatomic) IBOutlet UITextView *descripcionText;
@property (strong, nonatomic) IBOutlet UIButton *paginawebButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIScrollView *secondScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollwithimage;
@property (strong, nonatomic) IBOutlet UIButton *sharebutton;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) TWTweetComposeViewController *tweet;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicador;

@property (nonatomic,retain) NSString *localseleccionado;

@property (nonatomic,retain ) Idioma *selectidioma;
@property (nonatomic,retain) local *auxlocal;
@property (nonatomic,retain) Turismo *turista;
@property (nonatomic,retain) NSOperationQueue *queue;

-(void)cargarinfolocal;
-(void)cambiaridioma:(Idioma *)idiom;

@end