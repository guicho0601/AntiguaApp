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
@end


@implementation MapaeniPhone
@synthesize imageView,scrollView;

@synthesize auxlocal,auxlocacion,selectidioma,locacionesArray,localesArray,
auxcategoria,selecciontodo,auxservicio,auxtipo,auxlogo,auxanuncios,turismo,delegate,busqueda,todoturismo;
@synthesize titcat,titserv,tittip;
@synthesize puntoxy;

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
    [self.delegate abrioinfo];
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
        infolocal = [[Informacionlocal alloc]initWithNibName:nil bundle:nil];
        [infolocal setLocalseleccionado:sender.titleLabel.text];
        [infolocal setSelectidioma:selectidioma];
        [infolocal setDelegate:self];
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
    int x,y;
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
        //btnDetail.frame = CGRectMake(aux.coordx,aux.coordy,70,70);
        [btnDetail addTarget:self action:@selector(abririnfo:) forControlEvents:UIControlEventTouchUpInside];
        [btnDetail setTitle:aux.nombrelocal forState:UIControlStateNormal];
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

-(NSString *)tipodebusqueda{
    NSString *query;
    if ([selecciontodo isEqualToString:@"Categoria"]) {
        query = [NSString stringWithFormat:@"select locacion.coordx, locacion.coordy, local.nombre ,local.logo from locacion,local,servicio where servicio.idservicio=local.idservicio and locacion.idlocal=local.idlocal and servicio.idservicio=%d",auxservicio.idservicio];
        if (auxservicio.idservicio == 4) turismo = 1;
        else turismo = 0;
    }else if ([selecciontodo isEqualToString:@"Tipo/Categoria"]){
        query = [NSString stringWithFormat:@"select locacion.coordx, locacion.coordy, local.nombre, local.logo from locacion,local,categoria where locacion.idlocal=local.idlocal and local.idcategoria=categoria.idcategoria and categoria.idcategoria = %d",auxcategoria.idcategoria];
        if (auxcategoria.idservicio == 4) turismo = 1;
        else turismo = 0;
    }else if ([selecciontodo isEqualToString:@"Tipo"]){
        query = [NSString stringWithFormat:@"select locacion.coordx, locacion.coordy, local.nombre, local.logo from locacion,local,clasificacion where locacion.idlocal=local.idlocal and clasificacion.idlocal=local.idlocal and clasificacion.idtipo=%d",auxtipo.idtipo];
    }else if ([selecciontodo isEqualToString:@"Local"]){
        query = [NSString stringWithFormat:@"select locacion.coordx, locacion.coordy, local.nombre, local.logo from locacion,local where locacion.idlocal=local.idlocal and local.idlocal=%d",auxlocal.idlocal];
        if (auxlocal.idservicio == 4) turismo = 1;
        else turismo = 0;
    }else if ([selecciontodo isEqualToString:@"Anuncio"]){
        query = [NSString stringWithFormat:@"select locacion.coordx, locacion.coordy, local.nombre, local.logo from locacion,local where locacion.idlocal=local.idlocal and local.nombre='%@'",auxanuncios.local];
        if(auxanuncios.turistico == 1) turismo = 1;
        else turismo = 0;
    }else if ([selecciontodo isEqualToString:@"Todo"]){
        query = [NSString stringWithFormat:@"select locacion.coordx, locacion.coordy, local.nombre, local.logo, local.idservicio from locacion,local where locacion.idlocal=local.idlocal"];
        turismo = 0;
        if (todoturismo != nil) {
            [todoturismo removeAllObjects];
        }else{
            todoturismo = [[NSMutableArray alloc]init];
        }
    }
    return query;
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
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    if(sqlite3_open([appDelegate.databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *sqlStatement=[self tipodebusqueda];
        
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSString *logo,*servicio;
                NSString *coordx = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *coordy = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *nombre = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                if (sqlite3_column_type(compiledStatement, 3)!=SQLITE_NULL) {
                    logo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                if ([selecciontodo isEqualToString:@"Todo"]) {
                    servicio = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                    if ([servicio isEqualToString:@"4"]){
                        logo = @"Turismo.png";
                        [todoturismo addObject:nombre];
                    }
                }
                locacion *localidades = [[locacion alloc]init];
                localidades.coordx=[coordx intValue];
                localidades.coordy=[coordy intValue];
                localidades.nombrelocal=nombre;
                localidades.logo = logo;
                [locacionesArray addObject:localidades];
            }
        } else {
            NSLog(@"No query");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
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
    auxservicio.idservicio = 4;
    auxservicio.servicioesp = @"Turismo";
    auxservicio.servicioing = @"Tourism";
    auxservicio.icono = @"Turismo.png";
    auxlogo.icono = auxservicio.icono;
    selecciontodo = @"Categoria";
    [self cargarlocaciones];
}

#pragma mark - View lifecycle

-(void)configuraciones{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	self.scrollView.delegate = self;
    self.scrollView.contentSize = self.imageView.image.size;
    self.scrollView.frame = CGRectMake(0, 0, 320, 460);
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
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
    [self.scrollView scrollRectToVisible:CGRectMake(puntoxy.x*0.5,puntoxy.y*0.5, self.scrollView.frame.size.width,self.scrollView.frame.size.height) animated:YES];
    [self.scrollView setZoomScale:0.5f];
    
    [super viewWillAppear:YES];
    //[self parque];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
