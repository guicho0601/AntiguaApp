//
//  SplitViewControlleriPad.m
//  Aqui en... Antigua
//
//  Created by Luis Angel Ramos Gomez on 4/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SplitViewControlleriPad.h"

//#define flechaizquierda  @"Back_20x20.png"
#define flechaderecha @"f2.png"
#define tuerca @"tu2.png"
#define casita @"Home_20x20.png"

@implementation SplitViewControlleriPad{
    UIView *tempview;
    UIImageView *viimg;
}
@synthesize botoninfo;
@synthesize separador,anuncios;
@synthesize master,masternavigator,detail,detailnavigator,auxidioma,restaurante;
@synthesize titcat,titserv,tittip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)seleccionaridioma:(UIBarButtonItem *)sender{
    NSString *titulo,*mensaje,*cancelar;
    if (auxidioma.idioma == 0) {
        titulo = @"Language";
        mensaje = @"Select the language of your choice";
        cancelar = @"Cancel";
    }else{
        titulo = @"Idioma";
        mensaje = @"Seleccion el idioma de su preferencia";
        cancelar = @"Cancelar";
    }
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:titulo 
                                                      message:mensaje 
                                                     delegate:self 
                                            cancelButtonTitle:cancelar 
                                            otherButtonTitles:@"English", @"Español", nil];
    [message show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	
	if([title isEqualToString:@"English"])
	{
		auxidioma.idioma = 0;
	}
	else if([title isEqualToString:@"Español"])
	{
		auxidioma.idioma = 1;
	}
    [(ListaServiciosiPad *) [masternavigator.viewControllers objectAtIndex:0] cambiaridioma:auxidioma];
    int a = [masternavigator.viewControllers count];
    if (buscar == nil) {
        if (a>1) {
            [(CategoriasiPad *) [masternavigator.viewControllers objectAtIndex:1]cambiaridioma:auxidioma];
            if (a>2) {
                restaurante = [(CategoriasiPad *) [masternavigator.viewControllers objectAtIndex:1] auxrestaurante];
                if (restaurante.comida == 0) {
                    [(ListalocalesiPad *) [masternavigator.viewControllers objectAtIndex:2]cambiaridioma:auxidioma];
                }else{
                    [(ListatiposiPad *) [masternavigator.viewControllers objectAtIndex:2]cambiaridioma:auxidioma];
                }
                if (a>3) {
                    [(ListalocalesiPad *) [masternavigator.viewControllers objectAtIndex:3]cambiaridioma:auxidioma];
                }
            }
        }
    }else{
        [buscar cambiodeidioma:auxidioma];
    }
    [(MapaiPad *) [detailnavigator.viewControllers objectAtIndex:0]cambiaridioma:auxidioma];
}


#pragma mark - View lifecycle

-(void)ocultarmasterswipe:(UISwipeGestureRecognizer *)sender{
    CGRect anunrect,seprect,detrect,masrect,detailrect;
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
            seprect = CGRectMake(0, 0, 12, 1004);
            anunrect = CGRectMake(0, 854, 0,150);
            masrect = CGRectMake(0, 0, 0, 854);
            detrect = CGRectMake(12, 0, 756, 1004);
            detailrect = CGRectMake(0, 0, 756, 1004);
    }else{
            seprect = CGRectMake(0, 0, 12, 748);
            anunrect = CGRectMake(0, 598, 0, 150);
            masrect = CGRectMake(0, 0, 0, 598);
            detrect = CGRectMake(12, 0, 1012, 748);
            detailrect = CGRectMake(0, 0, 1012, 748);
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    if (!hidemaster) {
        [master setFrame:masrect];
        [anuncios setFrame:anunrect];
        [separador setFrame:seprect];
        [detail setFrame:detrect];
        [detailnavigator.view setFrame:detailrect];
        hidemaster = true;
        [detailViewController.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:flechaderecha]];
    }
    [UIView commitAnimations];
}

-(void)mostrarswipe:(UISwipeGestureRecognizer *)sender{
    CGRect anunrect,seprect,detrect,masrect,detailrect;
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        masrect = CGRectMake(0, 0, 320, 879);
        anunrect = CGRectMake(0, 879, 320, 125);
        seprect = CGRectMake(320, 0, 7, 1004);
        detrect = CGRectMake(327, 0, 441, 1004);
        detailrect = CGRectMake(0, 0, 441, 1004);
    }else{
        masrect = CGRectMake(0, 0, 320, 623);
        anunrect = CGRectMake(0, 623, 320, 125);
        seprect = CGRectMake(320, 0, 7, 748);
        detrect = CGRectMake(327, 0, 697, 748);
        detailrect = CGRectMake(0, 0, 697, 748);
    }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    if (hidemaster) {
        [master setFrame:masrect];
        [anuncios setFrame:anunrect];
        [separador setFrame:seprect];
        [detail setFrame:detrect];
        [detailnavigator.view setFrame:detailrect];
        [detailViewController.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:flechaizquierda]];
        hidemaster = false;
    }
    [UIView commitAnimations];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
   if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
       if (!hidemaster) {   
           [master setFrame:CGRectMake(0, 0, 320, 879)];
           [anuncios setFrame:CGRectMake(0, 879, 320, 125)];
           [separador setFrame:CGRectMake(320, 0, 7, 1004)];
           [detail setFrame:CGRectMake(327, 0, 441, 1004)];
           [detailnavigator.view setFrame:CGRectMake(0, 0, 441, 1004)];
       }else{
           [master setFrame:CGRectMake(0, 0, 0, 854)];
           [anuncios setFrame:CGRectMake(0, 854, 0, 150)];
           [separador setFrame:CGRectMake(0, 0, 12, 1004)];
           [detail setFrame:CGRectMake(12, 0, 756, 1004)];
           [detailnavigator.view setFrame:CGRectMake(0, 0, 756, 1004)];
       }
   }else{
       if (!hidemaster) {
           [master setFrame:CGRectMake(0, 0, 320, 623)];
           [anuncios setFrame:CGRectMake(0, 623, 320, 125)];
           [separador setFrame:CGRectMake(320, 0, 7, 748)];
           [detail setFrame:CGRectMake(327, 0, 697, 748)];
           [detailnavigator.view setFrame:CGRectMake(0, 0, 697, 748)];
       }else{
           [master setFrame:CGRectMake(0, 0, 0, 598)];
           [anuncios setFrame:CGRectMake(0, 854, 0, 150)];
           [separador setFrame:CGRectMake(0, 0, 12, 748)];
           [detail setFrame:CGRectMake(12, 0, 2012, 748)];
           [detailnavigator.view setFrame:CGRectMake(0, 0, 2012, 748)];
       }
   }
}

-(void)ocultarmaster:(UIBarButtonItem *)sender{
    CGRect anunrect,seprect,detrect,masrect,detailrect;
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        if (!hidemaster) {
            seprect = CGRectMake(0, 0, 12, 1004);
            anunrect = CGRectMake(0, 854, 0,150);
            masrect = CGRectMake(0, 0, 0, 854);
            detrect = CGRectMake(12, 0, 756, 1004);
            detailrect = CGRectMake(0, 0, 756, 1004);
        }else{
            masrect = CGRectMake(0, 0, 320, 879);
            anunrect = CGRectMake(0, 879, 320, 125);
            seprect = CGRectMake(320, 0, 7, 1004);
            detrect = CGRectMake(327, 0, 441, 1004);
            detailrect = CGRectMake(0, 0, 441, 1004);
        }
    }else{
        if (!hidemaster) {
            seprect = CGRectMake(0, 0, 12, 748);
            anunrect = CGRectMake(0, 598, 0, 150);
            masrect = CGRectMake(0, 0, 0, 598);
            detrect = CGRectMake(12, 0, 1012, 748);
            detailrect = CGRectMake(0, 0, 1012, 748);
        }else{
            masrect = CGRectMake(0, 0, 320, 623);
            anunrect = CGRectMake(0, 623, 320, 125);
            seprect = CGRectMake(320, 0, 7, 748);
            detrect = CGRectMake(327, 0, 697, 748);
            detailrect = CGRectMake(0, 0, 697, 748);
        }
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    if (!hidemaster) {
        [master setFrame:masrect];
        [anuncios setFrame:anunrect];
        [separador setFrame:seprect];
        [detail setFrame:detrect];
        [detailnavigator.view setFrame:detailrect];
        [detailViewController.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:flechaderecha]];
        hidemaster = true;
    }else{
        [master setFrame:masrect];
        [anuncios setFrame:anunrect];
        [separador setFrame:seprect];
        [detail setFrame:detrect];
        [detailnavigator.view setFrame:detailrect];
        [detailViewController.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:flechaizquierda]];
        hidemaster = false;
    }
    [UIView commitAnimations];
}

-(NSString *)imagentutorial{
    NSString *img;
    if (auxidioma.idioma == 0)img = @"in2.png";
    else img = @"es2.png";
    return img;
}

-(void)iniciartempview{
    
    
    viimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[self imagentutorial]]];
    float locx;// = (self.view.bounds.size.width - viimg.image.size.width )/2;
    locx = ([[UIScreen mainScreen]bounds].size.width/2)-(viimg.image.size.width/2);
    tempview = [[UIView alloc]init];
    [tempview setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin ];
    [tempview addSubview:viimg];
    [tempview setFrame:CGRectMake(locx, self.view.bounds.size.height, viimg.image.size.width, viimg.image.size.height)];
    [tempview setBackgroundColor:[UIColor blackColor]];
    [tempview setAlpha:0.65];
    [self.view addSubview:tempview];
    
    UISwipeGestureRecognizer *swipegesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(ocultartutorial)];
    [swipegesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [tempview addGestureRecognizer:swipegesture];
    [tempview setUserInteractionEnabled:YES];
}

-(void)mostrandotempview{
    [viimg setImage:[UIImage imageNamed:[self imagentutorial]]];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    float locx = (self.view.bounds.size.width - viimg.image.size.width )/2;
    [tempview setFrame:CGRectMake(locx, self.view.bounds.size.height - (viimg.image.size.height+10),viimg.image.size.width,viimg.image.size.height)];
    [UIView commitAnimations];
}

-(void)ocultandotempview{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    float locx = (self.view.bounds.size.width - viimg.image.size.width )/2;
    //[tempview setFrame:CGRectMake(locx, [[UIScreen mainScreen]bounds].size.height ,viimg.image.size.width ,viimg.image.size.height)];
    [tempview setFrame:CGRectMake(locx, [[UIScreen mainScreen]bounds].size.height ,tempview.frame.size.width ,0)];
    [UIView commitAnimations];
}

-(void)ocultartutorial{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    float locx = (self.view.bounds.size.width - viimg.image.size.width )/2;
    //    [tempview setFrame:CGRectMake(locx, [[UIScreen mainScreen]bounds].size.height ,viimg.image.size.width ,viimg.image.size.height)];
    [tempview setFrame:CGRectMake(locx, [[UIScreen mainScreen]bounds].size.height ,tempview.frame.size.width  ,0)];
    [UIView commitAnimations];
}

-(void)configuraciones{
    @autoreleasepool {
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int selleng = [defaults integerForKey:@"lenguaje"];
    
    CGRect rect;
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        rect = CGRectMake(0, 0, 441, 1004);
        //NSLog(@"Portrait");
    }else{
        rect = CGRectMake(0, 0, 697, 768);
        //NSLog(@"Landscape");
    }
    UISwipeGestureRecognizer *gestureswipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(ocultarmasterswipe:)];
    [gestureswipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    UISwipeGestureRecognizer *gestureopen = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(mostrarswipe:)];
    [gestureopen setDirection:UISwipeGestureRecognizerDirectionRight];
    UISwipeGestureRecognizer *gestureclose = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(ocultarmasterswipe:)];
    [gestureclose setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    servicios = [[ListaServiciosiPad alloc]initWithStyle:UITableViewStylePlain];
    detailViewController = [[MapaiPad alloc]initWithNibName:nil bundle:nil];
    
    [servicios setDelegate:self];
    [servicios.view setFrame:CGRectMake(0, 0, 320, 854)];
    [servicios setDetailViewController:detailViewController];
    masternavigator = [[UINavigationController alloc]initWithRootViewController:servicios];
    [masternavigator.view setFrame:CGRectMake(0, 0, 320, 879)];
    [masternavigator.navigationBar setTintColor:[UIColor blackColor]];
    //[masternavigator.navigationBar setAlpha:0.5];
    [master setFrame:CGRectMake(0, 0, 320, 879)];
    [master setBackgroundColor:[UIColor clearColor]];
    [master addSubview:masternavigator.view];
    
    [anuncios setFrame:CGRectMake(0, 879, 320, 125)];
    anun = [[Anunciantes alloc]initWithNibName:nil bundle:nil];
    [anun setDetailViewController:detailViewController];
    [anun setHeihtall:125];
    [anun setWidhtall:320];
    [anun.view setFrame:CGRectMake(0, 0, 320, 125)];
    [anuncios addSubview:anun.view];
    
    [detailViewController.view setFrame:rect];
    detailnavigator = [[UINavigationController alloc]initWithRootViewController:detailViewController];
    hidebutton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:flechaizquierda] style:UIBarButtonItemStylePlain target:self action:@selector(ocultarmaster:)];
    UIBarButtonItem *botonidioma = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:tuerca] style:UIBarButtonItemStylePlain target:self action:@selector(seleccionaridioma:)];
    detailViewController.navigationItem.leftBarButtonItem = hidebutton;
    detailViewController.navigationItem.rightBarButtonItem = botonidioma;
    [detailnavigator.view setFrame:CGRectMake(0, 0, 441, 1004)];
    [detailnavigator.navigationBar setTintColor:[UIColor blackColor]];
    [detailnavigator.navigationBar setTranslucent:YES];
    [detailnavigator.navigationBar setAlpha:0.5];
    [detail setFrame:CGRectMake(327, 0, 441, 1004)];
    [detail addSubview:detailnavigator.view];
    
    [separador setFrame:CGRectMake(320, 0, 7, 1004)];
    
    [masternavigator.view addGestureRecognizer:gestureswipe];
    [separador addGestureRecognizer:gestureclose];
    [separador addGestureRecognizer:gestureopen];
    
    hidemaster = false;
    //[anuncios setHidden:YES];
    
    auxidioma = [[Idioma alloc]init];
    auxidioma.idioma = selleng;
    [servicios setSelectidioma:auxidioma];
    [detailViewController setSelectidioma:auxidioma];
    }
    [self iniciartempview];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configuraciones];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    }

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)){
        [master setFrame:CGRectMake(0, 0, 320, 623)];
        [anuncios setFrame:CGRectMake(0, 623, 320, 125)];
        [separador setFrame:CGRectMake(320, 0, 7, 748)];
        [detail setFrame:CGRectMake(327, 0, 697, 748)];
        [detailnavigator.view setFrame:CGRectMake(0, 0, 697, 748)];
    }
    [self mostrandotempview];
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(ocultandotempview)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)viewDidUnload
{
    [self setBotoninfo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)avisosearchservicio:(Search *)aux{
    buscar = aux;
}

- (IBAction)abririnfogeneral:(id)sender {
    Info_horizontal *info = [[Info_horizontal alloc]init];
    info.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [info setDelegate:self];
    [self presentModalViewController:info animated:YES];
}

-(void)abrirsitiooficial{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://guowmaps.com"]];
}

@end
