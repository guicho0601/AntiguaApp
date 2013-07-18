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
#import <Socialize/Socialize.h>

@implementation Informacionlocal{
    NSMutableArray *imagenesarray;
    UIImage *imagepost;
    UIBarButtonItem *facebookButton;
}
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
@synthesize selectidioma,auxlocal,localseleccionado,delegate,tweet,turista,messageFB;

-(void)cargarinfolocal{
    if (imagenesarray != nil) {
        [imagenesarray removeAllObjects];
    }
    imagenesarray = [[NSMutableArray alloc]init];
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    if(sqlite3_open([appDelegate.databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString *sqlStatement=[NSString stringWithFormat:@"select * from local where nombre = '%@'",localseleccionado];
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSString *idlocal,*nombre,*descripcionesp,*descripcioning,*paginaweb,*imagen;
                if (sqlite3_column_type(compiledStatement, 0)!=SQLITE_NULL) {
                    idlocal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                }
                if (sqlite3_column_type(compiledStatement, 1)!=SQLITE_NULL) {
                    nombre = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                }
                if (sqlite3_column_type(compiledStatement, 2)!=SQLITE_NULL) {
                    descripcionesp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                if (sqlite3_column_type(compiledStatement, 3)!=SQLITE_NULL) {
                    descripcioning = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                if (sqlite3_column_type(compiledStatement, 4)!= SQLITE_NULL) {
                    paginaweb = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                }
                NSString *idservicio = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                NSString *idcategoria = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                if (sqlite3_column_type(compiledStatement, 7)!=SQLITE_NULL) {
                    imagen = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                }
                auxlocal.idlocal = [idlocal intValue];
                auxlocal.nombre = nombre;
                auxlocal.descripcionesp = descripcionesp;
                auxlocal.descripcioning = descripcioning;
                auxlocal.paginaweb = paginaweb;
                auxlocal.idcategoria = [idcategoria intValue];
                auxlocal.idservicio = [idservicio intValue];
                auxlocal.imagen = imagen;
                if (imagen != nil) {
                    [imagenesarray addObject:auxlocal.imagen];
                }
            }
        } else {
            NSLog(@"Query NO");
        }
        
        sqlStatement = [NSString stringWithFormat:@"select * from turismo where idlocal = %d",auxlocal.idlocal];
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSString *idlocal,*idimagen,*image;
                if (sqlite3_column_type(compiledStatement, 0)!=SQLITE_NULL) {
                    idlocal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                }
                if (sqlite3_column_type(compiledStatement, 1)!=SQLITE_NULL) {
                   idimagen = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                }
                if (sqlite3_column_type(compiledStatement, 2)!=SQLITE_NULL) {
                    image = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                Turismo *aux = [[Turismo alloc]init];
                aux.idlocal = [idlocal intValue];
                aux.idimage = [idimagen intValue];
                aux.imagen = image;
                [imagenesarray addObject:aux.imagen];
            }
        }else{
            NSLog(@"Query NO");
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
    }
    // Cierro la base de datos
    sqlite3_close(database);

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
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",docDir,nombrearchivo];
    if (![fm fileExistsAtPath:fotointerna]) {
        NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:[imagenesarray objectAtIndex:0]]];
        [data3 writeToFile:fotointerna atomically:YES];
    }
    NSData *imgData = [NSData dataWithContentsOfFile:fotointerna];
    UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
    [tweet addImage:thumbNail];
    [tweet addURL:url];
    [self presentModalViewController:tweet animated:YES];
}

-(void)prepararpostFacebook{
    FBShowController *fb = [[FBShowController alloc]initWithNibName:nil bundle:nil];
    [fb setUrlimage:[imagenesarray objectAtIndex:0]];
    [fb setDelegate:self];
    [self.navigationController pushViewController:fb animated:YES];
}

-(void)cerrarFB{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
}

-(void)sendFB:(NSString *)mensaje{
    
    NSURL *url2 = [NSURL URLWithString:[imagenesarray objectAtIndex:0]];
    NSString *nombrearchivo = url2.lastPathComponent;
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",docDir,nombrearchivo];
    if (![fm fileExistsAtPath:fotointerna]) {
        NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:[imagenesarray objectAtIndex:0]]];
        [data3 writeToFile:fotointerna atomically:YES];
    }
    NSData *imgData = [NSData dataWithContentsOfFile:fotointerna];
    UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
     NSData *logoData = UIImagePNGRepresentation(thumbNail);
     
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:mensaje forKey:@"message"];
     [params setObject:logoData forKey:@"source"];
     [params setObject:@"Aqui en Antigua!" forKey:@"caption"];
     
     [SZFacebookUtils postWithGraphPath:@"me/photos" params:params success:^(id info) {
     NSLog(@"Created post: %@", info);
     } failure:^(NSError *error) {
     NSLog(@"Failed to post: %@", [error localizedDescription]);
     }];
    
    NSString *mensaje2;
    if (selectidioma.idioma == 0) {
        mensaje2 = @"You've share this place on your wall";
    }else{
        mensaje2 = @"Compartiste este lugar en tu muro";
    }
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Facebook" 
                                                      message:mensaje2
                                                     delegate:self 
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];
    [message show];
}

-(void)abririmagen:(UITapGestureRecognizer *)sender{
    CGPoint punto = [sender locationInView:self.scrollwithimage];
    int abc;
    NSString *imagen;
    if((UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))){
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
        
    }else{
        CGSize completo = self.view.bounds.size;
        float medio = completo.width / 2;
        for (int i =0; i<imagenesarray.count; i++) {
            float a,b,c,d;
            if (i>1) {
                a = medio;
                b = completo.width;
            }else{
                a = 0;
                b = medio;
            }
            if (fmod(i,2) != 0){
                c = 100;
                d = 200;
            }else{
                c = 0;
                d = 100;
            }
            if ((punto.x > a && punto.x < b)&&(punto.y > c && punto.y < d)) {
                abc = i;
                break;
            }
        }
    }
    imagen = [imagenesarray objectAtIndex:abc];
    
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

-(void)establecerimagenes:(CGSize)size orientacion:(BOOL)orient{
    [self limpiarimagen];
    if (orient) {
        float medio = size.width/2;
        for (int i=0; i<[imagenesarray count]; i++) {
            CGRect frame;
            frame.origin.x = medio * i;
            frame.origin.y = 0;
            frame.size.width = medio;
            frame.size.height = 120;
            
            UIImageView *subimage = [[UIImageView alloc]initWithFrame:frame];
            NSURL *url = [NSURL URLWithString:[imagenesarray objectAtIndex:i]];
            NSString *nombrearchivo = url.lastPathComponent;
            
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSFileManager *fm = [NSFileManager defaultManager];
            NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",docDir,nombrearchivo];
            if (![fm fileExistsAtPath:fotointerna]) {
                NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:[imagenesarray objectAtIndex:i]]];
                [data3 writeToFile:fotointerna atomically:YES];
            }
            NSData *imgData = [NSData dataWithContentsOfFile:fotointerna];
            UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
            [subimage setImage:thumbNail];
            if (i == 0) {
                imagepost = thumbNail;
            }
            [self.scrollwithimage addSubview:subimage];
        }
    }else{
        float medio = size.width/2;
        for (int i=0; i<[imagenesarray count]; i++) {
            CGRect frame;
            if (i>1) {
                frame.origin.x = medio;
            }else{
                frame.origin.x = 0;
            }
            if (fmod(i,2) != 0){
                frame.origin.y = 100;
            }else{
                frame.origin.y = 0;
            }
            //frame.size.width = medio;
            frame.size.width = 180;
            frame.size.height = 100;
            
            UIImageView *subimage = [[UIImageView alloc]initWithFrame:frame];
            NSURL *url = [NSURL URLWithString:[imagenesarray objectAtIndex:i]];
            NSString *nombrearchivo = url.lastPathComponent;
            
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSFileManager *fm = [NSFileManager defaultManager];
            NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",docDir,nombrearchivo];
            if (![fm fileExistsAtPath:fotointerna]) {
                NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:[imagenesarray objectAtIndex:i]]];
                [data3 writeToFile:fotointerna atomically:YES];
            }
            NSData *imgData = [NSData dataWithContentsOfFile:fotointerna];
            UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
            [subimage setImage:thumbNail];
            if (i == 0) {
                imagepost = thumbNail;
            }
            [self.scrollwithimage addSubview:subimage];
        }
    }
}

-(void)posicionarobjetos{
    BOOL orient;
    if((UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))){
        CGSize completo = self.view.bounds.size;
        [self.scroll setFrame:CGRectMake(0, 0, completo.width, completo.height)];
        [self.labelTitulo setFrame:CGRectMake(0, 0, completo.width, self.labelTitulo.frame.size.height)];
        [self.descripcionText setFrame:CGRectMake(0, 25, completo.width, self.descripcionText.frame.size.height)];
        [self.scrollwithimage setFrame:CGRectMake(0, 230,completo.width,120)];
        [self.paginawebButton setFrame:CGRectMake(0, 355, completo.width, self.paginawebButton.frame.size.height)];
        
        self.scrollwithimage.contentSize = CGSizeMake(completo.width * 2, 120);
        orient = TRUE;
        [self establecerimagenes:completo orientacion:orient];
        
        [self.scroll addSubview:self.labelTitulo];
        [self.scroll addSubview:self.descripcionText];
        [self.scroll addSubview:self.scrollwithimage];
        [self.scroll addSubview:self.paginawebButton];
        [self.view addSubview:self.scroll];
    }else{
        CGSize completo = self.view.bounds.size;
        float posscroll;
        [self.scroll setFrame:CGRectMake(0, 10, completo.width, completo.height)];
        [self.labelTitulo setFrame:CGRectMake(0, 0, completo.width, self.labelTitulo.frame.size.height)];
        posscroll = ((completo.width/2)-180)/2;
        [self.descripcionText setFrame:CGRectMake((completo.width/2)+2, 25, (completo.width/2), 200)];
        [self.scrollwithimage setFrame:CGRectMake(posscroll, 25,(completo.width/2)-2,200)];
        [self.paginawebButton setFrame:CGRectMake(0, 230, completo.width, self.paginawebButton.frame.size.height)];
        
        self.scrollwithimage.contentSize = CGSizeMake(completo.width, 200);
        orient = FALSE;
        [self establecerimagenes:completo orientacion:orient];
        
        [self.scroll addSubview:self.labelTitulo];
        [self.scroll addSubview:self.descripcionText];
        [self.scroll addSubview:self.scrollwithimage];
        [self.scroll addSubview:self.paginawebButton];
        [self.scroll bringSubviewToFront:self.descripcionText];
        [self.view addSubview:self.scroll];
    }
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

-(void)configurarfacebook{
    [SZFacebookUtils setAppId:@"322714617838202"];
    NSString *existingToken = @"EXISTING_TOKEN";
    NSDate *existingExpiration = [NSDate distantFuture];
    
    [SZFacebookUtils linkWithAccessToken:existingToken expirationDate:existingExpiration success:^(id<SocializeFullUser> user) {
        NSLog(@"Link successful");
    } failure:^(NSError *error) {
        NSLog(@"Link failed: %@", [error localizedDescription]);
    }];
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

-(void) detectOrientation {
    /**if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || 
     ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) {
     
     
     
     } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
     
     // load view 1
     
     } */
    [self posicionarobjetos];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    //[self configuraciones];
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
    [self configuraciones];
    //[self posicionarobjetos];
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
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
