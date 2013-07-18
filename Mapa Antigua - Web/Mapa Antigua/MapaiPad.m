//
//  MapaiPad.m
//  Aqui en... Antigua
//
//  Created by Luis Angel Ramos Gomez on 4/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MapaiPad.h"


@interface MapaiPad ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *visitados;
@end


@implementation MapaiPad
@synthesize auxlocal,auxlocacion,selectidioma,locacionesArray,localesArray,
auxcategoria,selecciontodo,auxservicio,auxtipo,auxlogo,auxanuncios,turismo,busqueda,todoturismo;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize imageView,scrollView;
@synthesize titcat,tittip,titserv,visitados,infolocal;

#pragma mark - Managing the detail item

-(void)limpiarimagen{
    UIButton *btn = nil;
    NSArray *Array1 = [self.imageView subviews];
    for (btn in Array1){
        if ([btn isKindOfClass:[UIButton class]]){
            [btn removeFromSuperview];
        }
    }
    
}

-(CGPoint)ubicarcentrox:(float)x ubicarcentroy:(float)y{
    CGPoint punto;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if ((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)))
        {
            punto.x = x-((self.scrollView.frame.size.height)/2);
            punto.y = y-250;
        }else{
            punto.x = x-((self.scrollView.frame.size.width)/2);
            punto.y = y-400;
        }
    }else{
        if ((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)))
        {
            punto.x = x-((self.view.frame.size.height)/2);
            punto.y = y-100;
        }else{
            punto.x = x-((self.view.frame.size.width)/2);
            punto.y = y-150;
        }
    }
    return punto;
}



-(void)abririnfo:(UIButton *)sender{
    //BOOL b = [self insertarnuevovisitado:sender.titleLabel.text];
    UINavigationController *navegacion = nil;
    CGSize size = CGSizeMake(320, 460);
    BOOL band = false;
    if ([selecciontodo isEqualToString:@"Todo"]) {
        for (int i=0; i < todoturismo.count; i++) {
            if ([sender.titleLabel.text isEqualToString:[todoturismo objectAtIndex:i]]) {
                NSLog(@"%@",[todoturismo objectAtIndex:i]);
                band = true;
                break;
            }
        }
    }
    if (self.turismo == 1 || band) {
        infolocal = [[InformacionLocaliPad alloc]initWithNibName:nil bundle:nil];
        [infolocal setLocalseleccionado:sender.titleLabel.text];
        [infolocal setSelectidioma:selectidioma];
        
        navegacion = [[UINavigationController alloc]initWithRootViewController:infolocal];
        
    }else{
        oferta = [[ShowImageiPad alloc]initWithNibName:nil bundle:nil];
        [oferta setLocalseleccionado:sender.titleLabel.text];
        [oferta setSelectidioma:selectidioma];
        navegacion = [[UINavigationController alloc]initWithRootViewController:oferta];
        
    }
    if ([popoverControllerinfo isPopoverVisible]) {
        [popoverControllerinfo dismissPopoverAnimated:YES];
    } else {
        CGRect popRect = CGRectMake(sender.frame.origin.x,
                                        sender.frame.origin.y,
                                        sender.frame.size.width,
                                        sender.frame.size.height);
                        
        popoverControllerinfo = [[UIPopoverController alloc] initWithContentViewController:navegacion];
        [popoverControllerinfo setPopoverContentSize:size];
        [popoverControllerinfo presentPopoverFromRect:popRect
                                                   inView:self.imageView 
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:YES];
    }
}

-(void)ubicarbotonoes{
    int x=0,y=0;
    for (int i=0; i<[locacionesArray count]; i++) {
        locacion *aux = [locacionesArray objectAtIndex:i];
        UIImage *imagen;
        if ([selecciontodo isEqualToString:@"Todo"]) {
            imagen = [UIImage imageNamed:aux.logo];
        }else{
            if (turismo == 1) {
                imagen = [UIImage imageNamed:auxlogo.icono];
            }else{
                if (aux.logo == nil) imagen = [UIImage imageNamed:auxlogo.icono];
                else imagen = [UIImage imageNamed:aux.logo];
            }
            if (busqueda) {
                imagen = [UIImage imageNamed:@"admiracion.jpg"];
            }
        }
        UIButton *btnDetail = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDetail.frame = CGRectMake(aux.coordx,aux.coordy,imagen.size.width,imagen.size.height);
        [btnDetail addTarget:self action:@selector(abririnfo:) forControlEvents:UIControlEventTouchUpInside];
        NSString *s = [NSString stringWithFormat:@"%d",aux.idlocal];
        [btnDetail setTitle:s forState:UIControlStateNormal];
        [btnDetail setImage:imagen forState:UIControlStateNormal];
        [self.imageView addSubview:btnDetail];
        [self.imageView bringSubviewToFront:btnDetail];
        [self.imageView setUserInteractionEnabled:YES];
        x=aux.coordx;
        y=aux.coordy;
    }
    busqueda = false;
    [self.masterPopoverController dismissPopoverAnimated:YES];
    CGPoint punto = [self ubicarcentrox:x ubicarcentroy:y];
    
    [self.scrollView scrollRectToVisible:CGRectMake(punto.x*self.scrollView.zoomScale
                                                    ,punto.y*self.scrollView.zoomScale
                                                    , self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:YES];
    
    if ([locacionesArray count]>1) {
        //[self.scrollView setZoomScale:0.5];
    }
}

-(void)cargarlocaciones{
    [self limpiarimagen];
    [self.navigationController popToRootViewControllerAnimated:YES];
    if(locacionesArray != nil)
    {
        [locacionesArray removeAllObjects];
    } else {
        locacionesArray = [[NSMutableArray alloc]init];
    }
    
    NSMutableArray *adat;
    NSError *error;
    NSData *data;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directorio = [path objectAtIndex:0];
    NSString *file;
    file = [directorio stringByAppendingFormat:@"/lugar.txt"];
    data = [NSData dataWithContentsOfFile:file];
    
    adat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    for (int i=0; i<adat.count; i++){
        NSDictionary *info = [adat objectAtIndex:i];
        if ([selecciontodo isEqualToString:@"Categoria"]) {
            if ([[info objectForKey:@"servicio"]intValue]==auxservicio.idservicio) {
                locacion *aux = [[locacion alloc]init];
                aux.idlocal = [[info objectForKey:@"idlugar"]intValue];
                aux.logo = [info objectForKey:@"logo"];
                aux.coordx = [[info objectForKey:@"posx"]intValue];
                aux.coordy = [[info objectForKey:@"posy"]intValue];
                aux.nombrelocal = [info objectForKey:@"nombre"];
                NSString *is = [aux.logo isEqual:[NSNull null]]?nil:aux.logo;
                if (is ==nil){
                    aux.logo = nil;
                }
                [locacionesArray addObject:aux];
                if (auxservicio.idservicio == 1) turismo = 1;
                else turismo = 0;
            }
        }else if ([selecciontodo isEqualToString:@"Tipo/Categoria"]){
            if ([[info objectForKey:@"categoria"]intValue]==auxcategoria.idcategoria) {
                locacion *aux = [[locacion alloc]init];
                aux.idlocal = [[info objectForKey:@"idlugar"]intValue];
                aux.logo = [info objectForKey:@"logo"];
                aux.coordx = [[info objectForKey:@"posx"]intValue];
                aux.coordy = [[info objectForKey:@"posy"]intValue];
                aux.nombrelocal = [info objectForKey:@"nombre"];
                NSString *is = [aux.logo isEqual:[NSNull null]]?nil:aux.logo;
                if (is ==nil){
                    aux.logo = nil;
                }
                [locacionesArray addObject:aux];
                if (auxcategoria.idservicio == 1) turismo = 1;
                else turismo = 0;
            }
        }else if ([selecciontodo isEqualToString:@"Local"]){
            if ([[info objectForKey:@"idlugar"]intValue]==auxlocal.idlocal) {
                locacion *aux = [[locacion alloc]init];
                aux.idlocal = [[info objectForKey:@"idlugar"]intValue];
                aux.logo = [info objectForKey:@"logo"];
                aux.coordx = [[info objectForKey:@"posx"]intValue];
                aux.coordy = [[info objectForKey:@"posy"]intValue];
                aux.nombrelocal = [info objectForKey:@"nombre"];
                NSString *is = [aux.logo isEqual:[NSNull null]]?nil:aux.logo;
                if (is ==nil){
                    aux.logo = nil;
                }
                [locacionesArray addObject:aux];
                if (auxlocal.idservicio == 1) turismo = 1;
                else turismo = 0;
            }
        }else if ([selecciontodo isEqualToString:@"Anuncio"]){
            if(auxanuncios.turistico == 1) turismo = 1;
            else turismo = 0;
        }else if ([selecciontodo isEqualToString:@"Todo"]){
            locacion *aux = [[locacion alloc]init];
            aux.idlocal = [[info objectForKey:@"idlugar"]intValue];
            aux.logo = [info objectForKey:@"logo"];
            aux.coordx = [[info objectForKey:@"posx"]intValue];
            aux.coordy = [[info objectForKey:@"posy"]intValue];
            aux.nombrelocal = [info objectForKey:@"nombre"];
            NSString *is = [aux.logo isEqual:[NSNull null]]?nil:aux.logo;
            if (is ==nil){
                aux.logo = nil;
            }
            [locacionesArray addObject:aux];
            turismo = 0;
            if (todoturismo != nil) {
                [todoturismo removeAllObjects];
            }else{
                todoturismo = [[NSMutableArray alloc]init];
            }
            NSLog(@"Todo");
        }
        
    }
    
    [self ubicarbotonoes];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))){
        
    }else{
    
    }
}

-(void)cambiaridioma:(Idioma *)idioma{
    selectidioma = idioma;
}


-(void)posiciontoque:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.imageView];
    NSLog(@"X = %f , Y = %f",point.x,point.y);
}

-(void)parque{
    UIButton *btnDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDetail.frame = CGRectMake(6970,3885,200,200);
    [btnDetail addTarget:self action:@selector(abririnfo:) forControlEvents:UIControlEventTouchUpInside];
    [btnDetail setTitle:@"Catedral de San José" forState:UIControlStateNormal];
    UIImage *imagen = [UIImage imageNamed:@"Comida2b.png"];
    [btnDetail setImage:imagen forState:UIControlStateNormal];
    [self.imageView addSubview:btnDetail];
    [self.imageView bringSubviewToFront:btnDetail];
    [self.imageView setUserInteractionEnabled:YES];
}

-(void)establecertitulo{
    [self setTitle:[NSString stringWithFormat:@"%@%@%@",titserv,titcat,tittip]];
}

-(void)iniciocorelocation{
    locationManager=[[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.headingFilter = 1;
    locationManager.delegate=self;
    locationManager.distanceFilter = 1;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
}

-(void)cargarpreestablecidos{
    auxservicio = [[Servicio alloc]init];
    auxlogo = [[imagenlogo alloc]init];
    auxservicio.idservicio = 1;
    auxservicio.servicioesp = @"Turismo";
    auxservicio.servicioing = @"Tourism";
    auxservicio.icono = @"Turismo.png";
    auxlogo.icono = auxservicio.icono;
    selecciontodo = @"Categoria";
    [self cargarlocaciones];
}

-(void)imagenmapa{
    NSLog(@"Downloading...");
    NSString *imagen;
    NSMutableArray *adat;
    NSError *error =nil;
    NSData *data;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directorio = [path objectAtIndex:0];
    NSString *file;
    file = [directorio stringByAppendingFormat:@"/mapa.txt"];
    data = [NSData dataWithContentsOfFile:file];
    
    adat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    for (int i=0; i<adat.count; i++){
        NSDictionary *info = [adat objectAtIndex:i];
        imagen = [info objectForKey:@"nombre"];
    }
    
    NSURL *url = [NSURL URLWithString:imagen];
    NSString *nombrearchivo = url.lastPathComponent;
    
    NSArray *array = [imagen componentsSeparatedByString:@"/"];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *carpeta = [docDir stringByAppendingFormat:@"/%@",[array objectAtIndex:(array.count -2)]];
    NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",carpeta,nombrearchivo];
    if (![fm fileExistsAtPath:carpeta]) {
        [fm createDirectoryAtPath:carpeta withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    if (![fm fileExistsAtPath:fotointerna]) {
        [fm removeItemAtPath:carpeta error:nil];
        [fm createDirectoryAtPath:carpeta withIntermediateDirectories:YES attributes:nil error:NULL];
        NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:imagen]];
        [data3 writeToFile:fotointerna atomically:YES];
        
    }
    NSData *imgData = [NSData dataWithContentsOfFile:fotointerna];
    
    self.imageView.image = [[UIImage alloc]initWithData:imgData];
}

#pragma mark - View lifecycle

-(void)configuraciones{
    turismo = 0;
    busqueda = false;
    //self.title = @"Map";
    //self.navigationController.navigationBarHidden = YES;
    //[self.navigationController.navigationBar setAlpha:0.8];
    self.navigationController.navigationBar.translucent = YES;
    [self.imageView setBackgroundColor:[UIColor blackColor]];
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    //[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0xB3/255.0 green:0xB3/255.0 blue:0xB3/255.0 alpha:1]];
    /**UIImageView *viewimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"I_COMIDA60X60.gif"]];
    self.navigationItem.titleView = viewimage;*/
    self.selectidioma.idioma=0;
    //UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(posiciontoque:)];
    //tapgesture.numberOfTapsRequired = 1;
    //[self.scrollView addGestureRecognizer:tapgesture];
    
    brujula = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 75, 75)];
    [brujula setImage:[UIImage imageNamed:imagenbrujula]];
    [self.view addSubview:brujula];
    [self.view bringSubviewToFront:brujula];
    brujula.transform = CGAffineTransformMakeRotation(90 * M_PI / 180.0f);
    
    titserv = @"";
    tittip = @"";
    titcat = @"";
    
    [self cargarpreestablecidos];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Mapa_Sample.jpg"];  
    //self.imageView.image = [UIImage imageWithContentsOfFile:fullpath]; 
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    /**
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(posiciontoque:)];
    tap.numberOfTapsRequired =1;
    [self.imageView addGestureRecognizer:tap];
    [self.imageView setUserInteractionEnabled:YES];
    */
    //self.view.frame = self.scrollView.frame;
    [self imagenmapa];
    [self configuraciones];
    [self iniciocorelocation];
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    CGPoint punto=[self ubicarcentrox:((self.imageView.image.size.width)/2) ubicarcentroy:((self.imageView.image.size.height)/2)];
    [self.scrollView scrollRectToVisible:CGRectMake(punto.x,punto.y, self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:YES];
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation 
{ 
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    barButtonItem.title = NSLocalizedString(@"Menu", @"Menu");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    // Convertimos a Radianes el angulo anterior y el nuevo.
    
    float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
    
    float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
    
    
    // Creamos una animación.
    CABasicAnimation *theAnimation;
    
    // Será de tipo rotación
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    // Establecemos los valores del giro.
    theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
    
    theAnimation.toValue=[NSNumber numberWithFloat:newRad];
    
    // Podemos poner una duración, pero puede resultar retrasado si ponemos tiempo.
    theAnimation.duration = 0.0;
    
    
    // Le aplicamos la animación a la imagen de la brújula.
    [brujula.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    
    brujula.transform = CGAffineTransformMakeRotation(newRad);
}


@end
