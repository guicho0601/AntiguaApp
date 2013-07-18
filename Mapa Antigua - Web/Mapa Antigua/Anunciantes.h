//
//  Anunciantes.h
//  Aqui en Antigua
//
//  Created by Luis Angel Ramos Gomez on 8/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Anuncios.h"
#import "MapaiPad.h"
#import "ListalocalesiPad.h"

@interface Anunciantes : UIViewController<UIScrollViewDelegate>{
    UIScrollView* scrollView;
	UIPageControl* pageControl;
    UIActivityIndicatorView *indicador;
	
	BOOL pageControlBeingUsed;
    
    NSThread *thread;
    
    float medio;
    
    BOOL cambioauto;
    
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *anunciosarray;

@property (strong, nonatomic) MapaiPad *detailViewController;

@property (nonatomic,retain) NSOperationQueue *queue;

@property (nonatomic) int widhtall;
@property (nonatomic) int heihtall;

- (IBAction)changePage;

-(void)iniciaranuncios;
- (void)cargaranuncios;

@end
