//
//  Informacionlocal.m
//  Aqui en... Antigua
//
//  Created by Luis Angel Ramos Gomez on 15/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define tiempo 4

#import "Informacionlocal.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>



@implementation Informacionlocal{
    NSMutableArray *imagenesarray;
    UIImage *imagepost;
    UIBarButtonItem *facebookButton;
    
}
@synthesize indicador;
@synthesize labelTitulo;
@synthesize descripcionText;
@synthesize paginawebButton;
@synthesize scroll;
@synthesize secondScroll;
@synthesize imagen1;
@synthesize imagen2;
@synthesize imagen3;
@synthesize imagen4;
@synthesize scrollwithimage;
@synthesize sharebutton;
@synthesize pageControl;
@synthesize selectidioma,auxlocal,localseleccionado,delegate,tweet,turista,messageFB,queue,visitado;

-(void)cargarinfolocal{
    if (imagenesarray != nil) {
        [imagenesarray removeAllObjects];
    }
    imagenesarray = [[NSMutableArray alloc]init];
    
    NSMutableArray *adat;
    NSError *error =nil;
    NSData *data;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directorio = [path objectAtIndex:0];
    NSString *file;
    file = [directorio stringByAppendingFormat:@"/lugar.txt"];
    data = [NSData dataWithContentsOfFile:file];
    
    adat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    for (int i=0; i<adat.count; i++){
        NSDictionary *info = [adat objectAtIndex:i];
        if ([[info objectForKey:@"idlugar"]intValue]== [localseleccionado intValue]) {
            auxlocal.idlocal = [[info objectForKey:@"idlugar"]intValue];
            auxlocal.nombre = [info objectForKey:@"nombre"];
            auxlocal.descripcionesp = [info objectForKey:@"desesp"];
            auxlocal.descripcioning = [info objectForKey:@"desing"];
            auxlocal.paginaweb = [info objectForKey:@"web"];
            auxlocal.imagen = [info objectForKey:@"imgesp"];
            if (auxlocal.imagen != nil) {
                [imagenesarray addObject:auxlocal.imagen];
            }
        }
    }
    
    file = [directorio stringByAppendingFormat:@"/img_lugar.txt"];
    data = [NSData dataWithContentsOfFile:file];
    adat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    for (int i=0; i<adat.count; i++){
        NSDictionary *info = [adat objectAtIndex:i];
        if ([[info objectForKey:@"lugar"]intValue] == auxlocal.idlocal) {
            Turismo *aux = [[Turismo alloc]init];
            aux.idlocal = [[info objectForKey:@"lugar"]intValue];
            aux.idimage = [[info objectForKey:@"idimagen"]intValue];
            aux.imagen = [info objectForKey:@"imagen"];
            [imagenesarray addObject:aux.imagen];
        }
    }
}

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

-(void)postontwitter:(UIBarButtonItem *)sender{
    NSURL *url = [[NSURL alloc] initWithString:@"twitter.com"];
    [tweet setInitialText:@""];
    
    NSURL *url2 = [NSURL URLWithString:[imagenesarray objectAtIndex:0]];
    NSString *nombrearchivo = url2.lastPathComponent;
    NSLog(@"%@",[imagenesarray objectAtIndex:0]);
    NSArray *array = [[imagenesarray objectAtIndex:0] componentsSeparatedByString:@"/"];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *carpeta = [docDir stringByAppendingFormat:@"/%@",[array objectAtIndex:(array.count -2)]];
    NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",carpeta,nombrearchivo];
    NSData *imgData = [NSData dataWithContentsOfFile:fotointerna];
    
    UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
    [tweet addImage:thumbNail];
    [tweet addURL:url];
    [self presentModalViewController:tweet animated:YES];
}

-(void)prepararpostFacebook{
    PostFB *ps = [[PostFB alloc]init];
    [ps postwall:auxlocal.idlocal nombre:auxlocal.nombre];
}

-(void)cerrarFB{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
}


-(void)abririmagen:(UITapGestureRecognizer *)sender{
    CGPoint punto = [sender locationInView:self.scrollwithimage];
    int abc = 0;
    NSString *imagen;
    CGSize completo = self.view.bounds.size;
    float medio = completo.width / 2;
    for (int i=0; i<imagenesarray.count; i++) {
        float a = medio * i;
        float b = a + medio;
        if (punto.x > a && punto.x < b) {
            abc = i;
            break;
        }
    }
    imagen = [imagenesarray objectAtIndex:abc];
    
    [autoTimer invalidate];
    autoTimer =nil;
    
    ShowImage *show = [[ShowImage alloc]init];
    [show setNombreimagen:imagen];
    [autoTimer invalidate];
    autoTimer = nil;
    [self.navigationController pushViewController:show animated:YES];
}

-(void)establecerdatos{
    [descripcionText setBackgroundColor: [UIColor blackColor]];
    [descripcionText setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    labelTitulo.text=auxlocal.nombre;
    if (selectidioma.idioma==0) {
        descripcionText.text=auxlocal.descripcioning;
        [paginawebButton setTitle:@"Get more info..." forState:UIControlStateNormal];
    }else{
        descripcionText.text=auxlocal.descripcionesp;
        [paginawebButton setTitle:@"Mas informacion..." forState:UIControlStateNormal];
    }
    descripcionText.scrollEnabled = YES;
}

-(void)iniciaslide{
    autoTimer = [NSTimer scheduledTimerWithTimeInterval:(tiempo)
                                                 target:self
                                               selector:@selector(cambioautomatico)
                                               userInfo:nil
                                                repeats:YES];
}

-(void)limpiarimagen{
    UIImageView *btn = nil;
    NSArray *Array1 = [self.scrollwithimage subviews];
    for (btn in Array1){
        if ([btn isKindOfClass:[UIImageView class]]){
            [btn removeFromSuperview];
        }
    }
    
}

-(BOOL)isJPEGValid:(NSData *)jpeg{
    if ([jpeg length] < 4 ) return NO;
    const char *bytes = (const char *)[jpeg bytes];
    if (bytes[0] != 0xFF || bytes[1] != 0xD8)  return NO;
    if (bytes[[jpeg length] - 2]!=0xFF || bytes[[jpeg length]-1]!= 0xD9 )return NO;
    return YES;
}

-(void)descargarimagen:(NSString *)url carpeta:(NSString *)car foto:(NSString *)fo{
    NSLog(@"Descargando...");
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:car]) {
        [fm createDirectoryAtPath:car withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    if (![fm fileExistsAtPath:fo]) {
        NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [data3 writeToFile:fo atomically:YES];
        
    }
}

-(void)establecerimagenes{
    [self limpiarimagen];
    CGSize completo = self.view.bounds.size;
    float medio = completo.width/2;
    for (int i=0; i<[imagenesarray count]; i++) {
        CGRect frame;
        frame.origin.x = medio * i;
        frame.origin.y = 0;
        frame.size.width = medio;
        frame.size.height = 120;
        
        UIImageView *subimage = [[UIImageView alloc]initWithFrame:frame];
        NSURL *url = [NSURL URLWithString:[imagenesarray objectAtIndex:i]];
        NSString *nombrearchivo = url.lastPathComponent;
        url = nil;
        NSArray *array = [[imagenesarray objectAtIndex:i] componentsSeparatedByString:@"/"];
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *carpeta = [docDir stringByAppendingFormat:@"/%@",[array objectAtIndex:(array.count -2)]];
        
        NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",carpeta,nombrearchivo];
        
        if (!visitado) {
            [self descargarimagen:[imagenesarray objectAtIndex:i] carpeta:carpeta foto:fotointerna];
        }
        NSData *imgData = [NSData dataWithContentsOfFile:fotointerna];
        
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        [subimage setImage:thumbNail];
        if (i == 0) {
            imagepost = thumbNail;
        }
        [self.scrollwithimage addSubview:subimage];
        if (i == 3 ) {
            break;
        }
        
    }
    [self.indicador stopAnimating];
    [self.indicador setHidden:YES];
}

-(void)posicionarobjetos{
    CGSize completo = self.view.bounds.size;
    [self.scroll setFrame:CGRectMake(0, 0, completo.width, completo.height)];
    [self.labelTitulo setFrame:CGRectMake(0, 0, completo.width, self.labelTitulo.frame.size.height)];
    [self.descripcionText setFrame:CGRectMake(0, 25, completo.width, self.descripcionText.frame.size.height)];
    [self.scrollwithimage setFrame:CGRectMake(0, 230,completo.width,120)];
    [self.paginawebButton setFrame:CGRectMake(0, 355, completo.width, self.paginawebButton.frame.size.height)];
    
    self.scrollwithimage.contentSize = CGSizeMake(completo.width * 2, 120);
    //[self.indicador bringSubviewToFront:self.paginawebButton];
    //[self.paginawebButton bringSubviewToFront:self.indicador];
    [self.indicador startAnimating];
    self.queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(establecerimagenes)
                                                                              object:nil];
    
    [self.queue addOperation:operation];
    //[self.queue addObserver:self forKeyPath:@"operation" options:0 context:NULL];
    
    [self.scroll addSubview:self.labelTitulo];
    [self.scroll addSubview:self.descripcionText];
    [self.scroll addSubview:self.scrollwithimage];
    [self.scroll addSubview:self.paginawebButton];
    [self.view addSubview:self.scroll];
}

-(void)configurartweet{
    tweet = [[TWTweetComposeViewController alloc] init];
    
    TWTweetComposeViewControllerCompletionHandler completionHandler =
    ^(TWTweetComposeViewControllerResult result) {
        
        switch (result){
            case TWTweetComposeViewControllerResultCancelled:
                NSLog(@"Cancelado");
                break;
            case TWTweetComposeViewControllerResultDone:
                NSLog(@"Enviado");
                break;
            default:
                NSLog(@"Por defecto");
                break;
        }
        [self dismissModalViewControllerAnimated:YES];
    };
    [tweet setCompletionHandler:completionHandler];
}

-(void)regresomapa:(UIBarButtonItem *)sender{
    [self.delegate cerrarinfo];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configuracionbotonback{
    int a = self.view.bounds.size.width;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *botonatras = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:flechaizquierda] style:UIBarButtonItemStylePlain target:self action:@selector(regresomapa:)];
    self.navigationItem.leftBarButtonItem = botonatras;
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, a, 44)];
}

-(void)cambiolenguaje:(UIBarButtonItem *)sender{
    NSString *mensaje,*cancelar;
    if (selectidioma.idioma == 0) {
        //titulo = @"Language";
        mensaje = @"Select the language of your choice";
        cancelar = @"Cancel";
    }else{
        //titulo = @"Idioma";
        mensaje = @"Seleccion el idioma de su preferencia";
        cancelar = @"Cancelar";
    }
    
    UIActionSheet *language = [[UIActionSheet alloc]initWithTitle:mensaje delegate:self cancelButtonTitle:cancelar destructiveButtonTitle:nil otherButtonTitles:@"English",@"Español", nil];
    [language setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [language showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex	{
    NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([choice isEqualToString:@"English"]) {
        selectidioma.idioma = 0;
    } else if ([choice isEqualToString:@"Español"]){
        selectidioma.idioma = 1;
    }
    [self establecerdatos];
}

-(void)conftoolbar{
    
    UIImage *image = [UIImage imageNamed:facebookimg];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage: [image stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
    button.frame= CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    [button addTarget:self action:@selector(prepararpostFacebook)    forControlEvents:UIControlEventTouchUpInside];
    //[button addTarget:self action:@selector(fbconsdk)    forControlEvents:UIControlEventTouchUpInside];
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height) ];
    [v addSubview:button];
    facebookButton= [[UIBarButtonItem alloc] initWithCustomView:v];
    
    UIImage *images = [UIImage imageNamed:twitterimg];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundImage:[images stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
    button2.frame = CGRectMake(0, 0,images.size.width, images.size.height);
    [button2 addTarget:self action:@selector(postontwitter:) forControlEvents:UIControlEventTouchUpInside];
    UIView *v2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, images.size.width, images.size.height)];
    [v2 addSubview:button2];
    UIBarButtonItem *twitterButton = [[UIBarButtonItem alloc]initWithCustomView:v2];
    
    UIImage *image3 = [UIImage imageNamed:imagentuercabarra];
    UIButton *boton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [boton3 setBackgroundImage:[image3 stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
    boton3.frame = CGRectMake(0, 0, image3.size.width, image3.size.height);
    [boton3 addTarget:self action:@selector(cambiolenguaje:) forControlEvents:UIControlEventTouchUpInside];
    UIView *v3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, image3.size.width, image3.size.height)];
    [v3 addSubview:boton3];
    UIBarButtonItem *confButton = [[UIBarButtonItem alloc]initWithCustomView:v3];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:twitterButton,facebookButton,confButton, nil];
    
    [self.navigationController.navigationBar setAlpha:10];
    [self.navigationController.navigationBar setTranslucent:NO];
}

-(void)configuraciones{
    pageControlBeingUsed = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(abririmagen:)];
    tap.numberOfTapsRequired = 1;
    [self.scrollwithimage addGestureRecognizer:tap];
    [self.pageControl setHidden:YES];
    
    self.scrollwithimage.delegate = self;
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 2;
    
    auxlocal = [[local alloc]init];
    [self cargarinfolocal];
    [self establecerdatos];
    [self conftoolbar];
    [self configurartweet];
    [self posicionarobjetos];
    [self iniciaslide];
}

-(void)cambio{
    UIDevice *my = [UIDevice currentDevice];
    [my beginGeneratingDeviceOrientationNotifications];
    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:),UIInterfaceOrientationPortrait);
    [my endGeneratingDeviceOrientationNotifications];
    if ([my isGeneratingDeviceOrientationNotifications]) {
        [my endGeneratingDeviceOrientationNotifications];
        NSLog(@"Correcto");
    }else{
        NSLog(@"Error");
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [self configuraciones];
}

-(void)cambiaridioma:(Idioma *)idiom{
    selectidioma = idiom;
    auxlocal = [[local alloc]init];
    [self cargarinfolocal];
    [self establecerdatos];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setContentSizeForViewInPopover:CGSizeMake(320, 470)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self configuracionbotonback];
    }
    //[self configuraciones];
    //[self posicionarobjetos];
    [self iniciaslide];
    [self cambio];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self setContentSizeForViewInPopover:CGSizeMake(320, 470)];
    
}


- (void)viewDidUnload
{
    [self setLabelTitulo:nil];
    [self setDescripcionText:nil];
    [self setPaginawebButton:nil];
    [self setAuxlocal:nil];
    [self setScroll:nil];
    [self setScrollwithimage:nil];
    [self setImagen1:nil];
    [self setImagen2:nil];
    [self setImagen3:nil];
    [self setImagen4:nil];
    [self setImagen1:nil];
    [self setImagen1:nil];
    [self setImagen2:nil];
    [self setImagen3:nil];
    [self setImagen4:nil];
    [self setScrollwithimage:nil];
    [self setSharebutton:nil];
    [self setPageControl:nil];
    [self setSecondScroll:nil];
    [self setIndicador:nil];
    [self setLabelTitulo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollwithimage.frame.size.width;
		int page = floor((self.scrollwithimage.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return NO;
    if (interfaceOrientation == UIInterfaceOrientationPortrait){
        return YES;
    }else{
        return NO;
    }
    //return UIInterfaceOrientationPortrait;
}


- (IBAction)abrirurl:(id)sender {
    NSString *url = auxlocal.paginaweb;
    
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}

- (IBAction)changePage {
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollwithimage.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollwithimage.frame.size;
	[self.scrollwithimage scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
}

-(void)cambioautomatico{
    int a= self.pageControl.currentPage;
    if ((self.pageControl.numberOfPages-1) == a) {
        a = 0;
    }else{
        a += 1;
    }
    self.pageControl.currentPage = a;
    [self changePage];
}

@end
