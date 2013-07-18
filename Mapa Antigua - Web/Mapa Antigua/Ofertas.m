//
//  Ofertas.m
//  Aqui en Antigua
//
//  Created by Luis Angel Ramos Gomez on 17/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#define tiempo 0.25

#import "Ofertas.h"
#import <QuartzCore/QuartzCore.h>
#import <Socialize/Socialize.h>

@implementation Ofertas
@synthesize imageView;
@synthesize scrollView;
@synthesize buttonPagina;
@synthesize delegate,localseleccionado,selectidioma,auxlocal,tweet,queue;

-(void)cargarinfolocal{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    if(sqlite3_open([appDelegate.databasePath UTF8String], &database) == SQLITE_OK) {
        
        NSString *sqlStatement=[NSString stringWithFormat:@"select * from local where nombre = '%@'",localseleccionado];
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSString *idlocal,*nombre,*descripcionesp,*descripcioning,*paginaweb,*imagen,*imagening;
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
                if (sqlite3_column_type(compiledStatement, 9)!= SQLITE_NULL){
                    imagening = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                }
                auxlocal.idlocal = [idlocal intValue];
                auxlocal.nombre = nombre;
                auxlocal.descripcionesp = descripcionesp;
                auxlocal.descripcioning = descripcioning;
                auxlocal.paginaweb = paginaweb;
                auxlocal.idcategoria = [idcategoria intValue];
                auxlocal.idservicio = [idservicio intValue];
                auxlocal.imagen = imagen;
                auxlocal.imagening = imagening;
            }
        } else {
            NSLog(@"Query NO");
        }
        // Libero la consulta
        sqlite3_finalize(compiledStatement);
    }
    // Cierro la base de datos
    sqlite3_close(database);
    
}

-(void)prepararpostFacebook{
    FBShowController *fb = [[FBShowController alloc]initWithNibName:nil bundle:nil];
    [fb setUrlimage:auxlocal.imagen];
    [fb setDelegate:self];
    [self.navigationController pushViewController:fb animated:YES];
}

-(void)cerrarFB{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
}

-(void)sendFB:(NSString *)mensaje{
    NSLog(@"%@",mensaje);
    /**
     NSMutableDictionary *postData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     mensaje, @"message",@"Aqui en Antigua!",@"caption",
     nil];
     
     [SZFacebookUtils postWithGraphPath:@"me/feed" params:postData success:^(id post) {
     NSLog(@"Posted %@!", post);
     } failure:^(NSError *error) {
     NSLog(@"Facebook post failed: %@, %@", [error localizedDescription], [error userInfo]);
     }];*/
    
    
    NSURL *url2 = [NSURL URLWithString:auxlocal.imagen];
    NSString *nombrearchivo = url2.lastPathComponent;
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",docDir,nombrearchivo];
    if (![fm fileExistsAtPath:fotointerna]) {
        NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:auxlocal.imagen]];
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

-(void)postontwitter:(UIBarButtonItem *)sender{
    NSURL *url = [[NSURL alloc] initWithString:@"twitter.com"];
    [tweet setInitialText:@""];
    [tweet addImage:imageView.image];
    [tweet addURL:url];
    [self presentModalViewController:tweet animated:YES];
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
    [self.delegate cerrarinfoimagen];
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)ajustarimagen{
    [scrollView setZoomScale:1.0 animated:YES];
    CGSize tam = imageView.image.size;
    float ancho,alto,px,py;
    if((UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))){
        CGSize completo = self.view.bounds.size;
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
    }else{
        //CGSize completo = self.view.bounds.size;
        CGSize completo = CGSizeMake(480, 300);
        if (tam.height > completo.height) {
            completo.height -= 44;
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
    }
    [imageView setFrame:CGRectMake(px, py, ancho, alto)];
}

-(void)cargarimagen{
    NSString *urlimagen;
    if (selectidioma.idioma == 0) urlimagen = auxlocal.imagening;
    else urlimagen = auxlocal.imagen;
    
    NSURL *url = [NSURL URLWithString:urlimagen]; 
    NSString *nombrearchivo = url.lastPathComponent;
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",docDir,nombrearchivo];
    if (![fm fileExistsAtPath:fotointerna]) {
        NSData *data3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlimagen]];
        [data3 writeToFile:fotointerna atomically:YES];
    }
    NSData *imgData = [NSData dataWithContentsOfFile:fotointerna];
    UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
    [imageView setImage:thumbNail];
   
    [self ajustarimagen];
}


-(void)configuracionbotonback{
    int a = self.view.bounds.size.width;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *botonatras = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:flechaizquierda] style:UIBarButtonItemStylePlain target:self action:@selector(regresomapa:)];
    self.navigationItem.leftBarButtonItem = botonatras;
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, a, 44)];
}

-(void)cambiolenguaje:(UIBarButtonItem*)sender{
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
    [self cargarimagen];
}

-(void)conftoolbar{
    UIImage *image = [UIImage imageNamed:facebookimg];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage: [image stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
    button.frame= CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    [button addTarget:self action:@selector(prepararpostFacebook)    forControlEvents:UIControlEventTouchUpInside];
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height) ];
    [v addSubview:button];
    UIBarButtonItem *facebookButton= [[UIBarButtonItem alloc] initWithCustomView:v];
    
    UIImage *images = [UIImage imageNamed:twitterimg];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundImage:[images stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
    button2.frame = CGRectMake(0, 0, images.size.width, images.size.height);
    [button2 addTarget:self action:@selector(postontwitter:) forControlEvents:UIControlEventTouchUpInside];
    UIView *v2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, images.size.width, images.size.height)];
    [v2 addSubview:button2];
    UIBarButtonItem *twitterButton = [[UIBarButtonItem alloc]initWithCustomView:v2];
    
    UIBarButtonItem *confButton = nil;
    
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    
         UIImage *image3 = [UIImage imageNamed:imagentuercabarra];
         UIButton *boton3 = [UIButton buttonWithType:UIButtonTypeCustom];
         [boton3 setBackgroundImage:[image3 stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateNormal];
         boton3.frame = CGRectMake(0, 0, image3.size.width, image3.size.height);
         [boton3 addTarget:self action:@selector(cambiolenguaje:) forControlEvents:UIControlEventTouchUpInside];
         UIView *v3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, image3.size.width, image3.size.height)];
         [v3 addSubview:boton3];
         confButton = [[UIBarButtonItem alloc]initWithCustomView:v3];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:twitterButton,facebookButton,confButton, nil];
    }
    [self.navigationController.navigationBar setAlpha:10];
    [self.navigationController.navigationBar setTranslucent:NO];
}

-(void) detectOrientation {
    /**if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || 
        ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) {
        
        
        
    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        
        // load view 1
        
    } */
        [self ajustarimagen];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object 
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == self.queue && [keyPath isEqualToString:@"operations"]) {
        if ([self.queue.operations count] == 0) {
            [indicador stopAnimating];
            [indicador removeFromSuperview];
            NSLog(@"queue has completed");
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object 
                               change:change context:context];
    }
}

-(void)configuraciones{
    auxlocal = [[local alloc]init];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [scrollView setDelegate:self];
    [self cargarinfolocal];
    [self conftoolbar];
    [self configurartweet];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    self.queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(cargarimagen)
                                        object:nil];
    [self.queue addOperation:operation];
    [self.queue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    indicador = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicador.center = CGPointMake(self.view.bounds.size.width/2,(self.view.bounds.size.height/2)-44);
    [self.view addSubview:indicador];
    [indicador startAnimating];
    if (selectidioma.idioma==0) {
        [buttonPagina setTitle:@"Get more info..." forState:UIControlStateNormal];
    }else{
        [buttonPagina setTitle:@"Mas informacion..." forState:UIControlStateNormal];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configuraciones];
}

- (void)viewDidUnload
{
    [self setButtonPagina:nil];
    [super viewDidUnload];
}

-(void)cambiaridioma:(Idioma *)idiom{
    selectidioma = idiom;
    auxlocal = [[local alloc]init];
    [self cargarinfolocal];
}

-(void)viewWillAppear:(BOOL)animated{
    //[self setContentSizeForViewInPopover:CGSizeMake(320, 470)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self configuracionbotonback];
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}


- (IBAction)abrirurl:(id)sender {
    NSString *url = auxlocal.paginaweb;  
    
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}

@end
