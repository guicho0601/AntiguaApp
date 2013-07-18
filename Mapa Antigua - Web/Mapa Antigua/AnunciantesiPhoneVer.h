//
//  AnunciantesiPhoneVer.h
//  Aqui en Antigua
//
//  Created by Luis Angel Ramos Gomez on 13/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MapaeniPhone.h"
#import "Anuncios.h"
#import "ListalocalesiPhone.h"

@protocol Anuncioverdelegate <NSObject>
@optional 
-(void)cerrarmenuver;
@end

@interface AnunciantesiPhoneVer : UIViewController <UIScrollViewDelegate>{
    UIScrollView* scrollView;
    UIPageControl* pageControl;
    UIActivityIndicatorView *indicador;

    BOOL pageControlBeingUsed;

    NSThread *thread;

    float medio;

    BOOL cambioauto;

    AppDelegate *appDelegate;
    
    __weak id<Anuncioverdelegate> delegate;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *anunciosarray;

@property (strong, nonatomic) MapaeniPhone *detailViewController;

@property (nonatomic) int widhtall;
@property (nonatomic) int heihtall;

@property(weak,nonatomic) id<Anuncioverdelegate> delegate;

@property (nonatomic,retain) NSOperationQueue *queue;

- (IBAction)changePage;

-(void)iniciaranuncios;
- (void)cargaranuncios;

@end
