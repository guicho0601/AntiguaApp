//
//  ShowImage.m
//  Aqui en Antigua
//
//  Created by Luis Angel Ramos Gomez on 18/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ShowImage.h"

@implementation ShowImage
@synthesize imageView;
@synthesize scrollView;
@synthesize nombreimagen,sizepop,delegate;

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

-(void)ajustarimagen{
    [scrollView setZoomScale:1.0 animated:YES];
    CGSize tam = imageView.image.size;
    float ancho,alto,px,py;
    if((UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))){
        CGSize completo = self.view.bounds.size;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            completo = CGSizeMake(320, 480);
        }
        if (tam.width > completo.width) {
            float cd = tam.width/completo.width;
            ancho = completo.width;
            alto = tam.height/cd;
            px = 0;
            py = ((completo.height - alto)/2)-44;
        }else{
            ancho = tam.width;
            alto = tam.height;
            px = (completo.width - ancho)/2;
            py = (completo.height - alto)/2;
        }
        [scrollView setFrame:CGRectMake(0, 0, completo.width, completo.height)];
        [scrollView setContentSize:completo];
        sizepop = CGSizeMake(320, 460);
    }else{
        CGSize completo = self.view.bounds.size;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            completo = CGSizeMake(480, 300);
        }
        if (tam.height > completo.height) {
            float cd = tam.height / completo.height;
            ancho = tam.width/cd;
            alto = completo.height;
            px = (completo.width - ancho)/2;
            py = 0;
        }else{
            ancho = tam.width;
            alto = tam.height;
            px = (completo.width - ancho)/2;
            py = (completo.height - alto)/2;
        }
        [scrollView setFrame:CGRectMake(0, 0, completo.width, completo.height)];
        [scrollView setContentSize:completo];
        sizepop = CGSizeMake(480,300);
    }
    [imageView setFrame:CGRectMake(px, py, ancho, alto)];
}

-(void)tamaniopopover{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))){
            self.contentSizeForViewInPopover = CGSizeMake(480,300);
        } else{
            self.contentSizeForViewInPopover = CGSizeMake(320, 460);
        }
    }
}

-(void)cargarimagen{
    NSURL *url = [NSURL URLWithString:nombreimagen];
    NSString *nombrearchivo = url.lastPathComponent;
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",docDir,nombrearchivo];
    if (![fm fileExistsAtPath:fotointerna]) {
        NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:nombreimagen]];
        [data3 writeToFile:fotointerna atomically:YES];
    }
    NSData *imgData = [NSData dataWithContentsOfFile:fotointerna];
    UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
    [imageView setImage:thumbNail];
    [self ajustarimagen];
    [self tamaniopopover];
}

-(void)regresomapa:(UIBarButtonItem*)sender{
    [self.delegate cerrarshow];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configuraciones{
    [scrollView setDelegate:self];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *botonatras = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:flechaizquierda] style:UIBarButtonItemStylePlain target:self action:@selector(regresomapa:)];
    self.navigationItem.leftBarButtonItem = botonatras;
}

-(void) detectOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))){
            self.contentSizeForViewInPopover = CGSizeMake(480,300);
        } else{
            self.contentSizeForViewInPopover = CGSizeMake(320, 460);
        }
    }
    [self ajustarimagen];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [self configuraciones];
    [self cargarimagen];
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //[self cargarimagen];
        [self ajustarimagen];
        self.contentSizeForViewInPopover = sizepop;
    }
    [super viewDidAppear:animated];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
