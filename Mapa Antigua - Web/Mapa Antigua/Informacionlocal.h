//
//  Informacionlocal.h
//  Aqui en... Antigua
//
//  Created by Luis Angel Ramos Gomez on 15/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Idioma.h"
#import "local.h"
#import "AppDelegate.h"
#import "Turismo.h"
#import "ShowImage.h"
#import "FBShowController.h"

@protocol Infolocaldelegate <NSObject>
-(void)cerrarinfo;
@end

@interface Informacionlocal : UIViewController<UIActionSheetDelegate,UIScrollViewDelegate,FBShowDelegate,UIPopoverControllerDelegate>{
    AppDelegate *appDelegate;
    TWTweetComposeViewController *tweet;
    
    UIImageView *imagenselect;
    NSTimer *autoTimer;
    
    
    BOOL pageControlBeingUsed;
    
    __weak id<Infolocaldelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UILabel *labelTitulo;
@property (strong, nonatomic) IBOutlet UITextView *descripcionText;
@property (strong, nonatomic) IBOutlet UIButton *paginawebButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIScrollView *secondScroll;
@property (strong, nonatomic) IBOutlet UIImageView *imagen1;
@property (strong, nonatomic) IBOutlet UIImageView *imagen2;
@property (strong, nonatomic) IBOutlet UIImageView *imagen3;
@property (strong, nonatomic) IBOutlet UIImageView *imagen4;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollwithimage;
@property (strong, nonatomic) IBOutlet UIButton *sharebutton;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) TWTweetComposeViewController *tweet;
@property (strong, nonatomic) UITextView *messageFB;

@property (nonatomic,retain) NSString *localseleccionado;

@property (nonatomic,retain ) Idioma *selectidioma;
@property (nonatomic,retain) local *auxlocal;
@property (nonatomic,retain) Turismo *turista;

@property(weak,nonatomic) id<Infolocaldelegate> delegate;

-(void)cargarinfolocal;
-(void)cambiaridioma:(Idioma *)idiom;

@end