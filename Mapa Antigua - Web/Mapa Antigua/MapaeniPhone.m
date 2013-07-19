//
//  MapaeniPhone.m
//  Aqui en... Antigua
//
//  Created by Luis Angel Ramos Gomez on 5/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MapaeniPhone.h"

@interface MapaeniPhone ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *visitados;
@end


@implementation MapaeniPhone
@synthesize imageView,scrollView;

@synthesize auxlocal,auxlocacion,selectidioma,locacionesArray,localesArray,
auxcategoria,selecciontodo,auxservicio,auxtipo,auxlogo,auxanuncios,turismo,delegate,busqueda,todoturismo;
@synthesize titcat,titserv,tittip;
@synthesize puntoxy,visitados;

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

-(BOOL)insertarnuevovisitado:(NSString *)sender{
    NSString *t = sender;
    BOOL b = false;
    for (int i = 0; i < visitados.count; i++) {
        if ([[visitados objectAtIndex:i]isEqual:t]) {
            b = true;
            break;
        }
    }
    if (!b) {
        [visitados addObject:t];
        NSString *s = [NSString stringWithFormat:@""];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *directorio = [path objectAtIndex:0];
        NSString *file;
        file = [directorio stringByAppendingFormat:@"/visitados.txt"];
        for (int i=0; i<visitados.count; i++) {
            s = [s stringByAppendingFormat:@"%@\n",[visitados objectAtIndex:i]];
        }
        [s writeToFile:file atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
    return b;
}

-(void)abririnfo:(UIButton *)sender{
    BOOL b = [self insertarnuevovisitado:sender.titleLabel.text];
    //self.imageView.image = nil;
    [self.delegate abrioinfo];
    BOOL band = false;
    if ([selecciontodo isEqualToString:@"Todo"]) {
        for (int i=0; i < todoturismo.count; i++) {
            if ([sender.titleLabel.text isEqualToString:[todoturismo objectAtIndex:i]]) {
                band = true;
                break;
            }
        }
    }
    if (self.turismo == 1 || band) {
        infolocal = [[Informacionlocal alloc]initWithNibName:nil bundle:nil];
        [infolocal setLocalseleccionado:sender.titleLabel.text];
        [infolocal setSelectidioma:selectidioma];
        [infolocal setDelegate:self];
        [infolocal setVisitado:b];
        [self.navigationController pushViewController:infolocal animated:YES];
    }else{
        oferta = [[Ofertas alloc]initWithNibName:nil bundle:nil];
        [oferta setLocalseleccionado:sender.titleLabel.text];
        [oferta setSelectidioma:selectidioma];
        [oferta setDelegate:self];
        [self.navigationController pushViewController:oferta animated:YES];
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
                imagen = [UIImage imageNamed:@"Turismo.jpg"];
            }
        };
        UIButton *btnDetail = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDetail.frame = CGRectMake(aux.coordx,aux.coordy,imagen.size.width,imagen.size.height);
        //btnDetail.frame = CGRectMake(aux.coordx,aux.coordy,70,70);
        [btnDetail addTarget:self action:@selector(abririnfo:) forControlEvents:UIControlEventTouchUpInside];
        NSString *t = [NSString stringWithFormat:@"%d",aux.idlocal];
        [btnDetail setTitle:t forState:UIControlStateNormal];
        [btnDetail setImage:imagen forState:UIControlStateNormal];
        [self.imageView addSubview:btnDetail];
        [self.imageView bringSubviewToFront:btnDetail];
        [self.imageView setUserInteractionEnabled:YES];
        x=aux.coordx;
        y=aux.coordy;
    }
    busqueda = false;
    puntoxy = [self ubicarcentrox:x ubicarcentroy:y];
    [self.scrollView scrollRectToVisible:CGRectMake(puntoxy.x*0.5,puntoxy.y*0.5, self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:YES];
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
    
    if (todoturismo != nil) {
        [todoturismo removeAllObjects];
    }else{
        todoturismo = [[NSMutableArray alloc]init];
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
            if ([[info objectForKey:@"servicio"]intValue]==1) {
                NSString *t = [NSString stringWithFormat:@"%d",aux.idlocal];
                [todoturismo addObject:t];
                NSLog(@"Estamos es turismo");
            }
        }
        
    }
    
    [self ubicarbotonoes];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))){
        //[brujula setFrame:CGRectMake(0, 10, 50, 50)];
        //NSLog(@"Landscape");
    }else{
        //[brujula setFrame:CGRectMake(0, 50, 50, 50)];
    }
}

-(void)posiciontoque:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.scrollView];
    NSLog(@"X = %f , Y = %f",point.x,point.y);
}

-(void)parque{
    UIButton *btnDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDetail.frame = CGRectMake(500,500,100,100);
    [btnDetail addTarget:self action:@selector(abririnfo:) forControlEvents:UIControlEventTouchUpInside];
    [btnDetail setTitle:@"Parque Central" forState:UIControlStateNormal];
    UIImage *imagen = [UIImage imageNamed:@"COMIDA100x100.gif"];
    [btnDetail setImage:imagen forState:UIControlStateNormal];
    [self.imageView addSubview:btnDetail];
    [self.imageView bringSubviewToFront:btnDetail];
    [self.imageView setUserInteractionEnabled:YES];
}

-(void)cambiaridioma:(Idioma *)idioma{
    selectidioma = idioma;
    if (infolocal != nil) {
        [infolocal cambiaridioma:idioma];
    }
}

-(void)establecertitulo{
    [self setTitle:[NSString stringWithFormat:@"%@%@%@",titserv,titcat,tittip]];
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

-(void)cargarvisitados{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directorio = [path objectAtIndex:0];
    NSString *file;
    file = [directorio stringByAppendingFormat:@"/visitados.txt"];
    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    if (visitados != nil) {
        [visitados removeAllObjects];
    }
    visitados = [[NSMutableArray alloc]init];
    NSArray *array = [content componentsSeparatedByString:@"\n"];
    for (int i = 0; i < (array.count-1); i++) {
        [visitados addObject:[array objectAtIndex:i]];
    }
}

#pragma mark - View lifecycle

-(void)configuraciones{
    [self cargarvisitados];
    turismo = 1;
    busqueda = false;
    titcat = titserv = tittip = @"";
    self.title = @"";
    //[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.imageView setBackgroundColor:[UIColor blackColor]];
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setAlpha:0.5];
    //[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0xB3/255.0 green:0xB3/255.0 blue:0xB3/255.0 alpha:1]];
    //UIImageView *viewimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"I_COMIDA60X60.gif"]];
    //self.navigationItem.titleView = viewimage;
    self.selectidioma.idioma=0;
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(posiciontoque:)];
    tapgesture.numberOfTapsRequired = 1;
    //[self.scrollView addGestureRecognizer:tapgesture];
    
    puntoxy = [self ubicarcentrox:((self.imageView.image.size.width)/2) ubicarcentroy:((self.imageView.image.size.height)/2)];
    
    [self cargarpreestablecidos];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	self.scrollView.delegate = self;
    self.scrollView.contentSize = self.imageView.image.size;
    self.scrollView.frame = CGRectMake(0, 0, 320, 460);
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    [self imagenmapa];
    [self configuraciones];
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
    [self setImageView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.scrollView scrollRectToVisible:CGRectMake(1416*0.5,1040*0.5, self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:YES];
    [self.scrollView setZoomScale:0.5f];
    //[self parque];
    //[self imagenmapa];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self.scrollView scrollRectToVisible:CGRectMake(1416*0.5,1040*0.4, self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) detectOrientation {
    
}

-(void)cerrarinfo{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setAlpha:0.5];
    infolocal = nil;
    [self.delegate cerroinfo];
}

-(void)cerrarinfoimagen{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setAlpha:0.5];
    infolocal = nil;
    [self.delegate cerroinfo];
}

@end
