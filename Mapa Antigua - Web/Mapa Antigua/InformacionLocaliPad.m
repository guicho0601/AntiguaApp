#import "InformacionLocaliPad.h"
#define tiempo 3

#import <QuartzCore/QuartzCore.h>

@implementation InformacionLocaliPad{
    NSMutableArray *imagenesarray;
    NSMutableArray *visitados;
    BOOL visitado;
}
@synthesize indicador;
@synthesize labelTitulo;
@synthesize descripcionText;
@synthesize paginawebButton;
@synthesize scroll;
@synthesize secondScroll;
@synthesize scrollwithimage;
@synthesize sharebutton;
@synthesize pageControl;
@synthesize selectidioma,auxlocal,localseleccionado,tweet,turista,queue;

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
    
    NSURL *url2 = [NSURL URLWithString:[imagenesarray objectAtIndex:0]];
    NSString *nombrearchivo = url2.lastPathComponent;
    NSLog(@"%@",[imagenesarray objectAtIndex:0]);
    NSArray *array = [[imagenesarray objectAtIndex:0] componentsSeparatedByString:@"/"];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *carpeta = [docDir stringByAppendingFormat:@"/%@",[array objectAtIndex:(array.count -2)]];
    if (![fm fileExistsAtPath:carpeta]) {
        [fm createDirectoryAtPath:carpeta withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",carpeta,nombrearchivo];
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
    PostFB *ps = [[PostFB alloc]init];
    [ps postwall:auxlocal.idlocal nombre:auxlocal.nombre];
}



-(void)iniciaslide{
    autoTimer = [NSTimer scheduledTimerWithTimeInterval:(tiempo)
                                                 target:self
                                               selector:@selector(cambioautomatico)
                                               userInfo:nil
                                                repeats:YES];
}

-(void)abririmagen:(UITapGestureRecognizer *)sender{
    CGPoint punto = [sender locationInView:self.scrollwithimage];
    int abc = 0;
    
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
    NSString *imagen = [imagenesarray objectAtIndex:abc];
    
    ShowImage *show = [[ShowImage alloc]init];
    [show setNombreimagen:imagen];
    [show setDelegate:self];
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

-(void)limpiarimagen{
    UIImageView *btn = nil;
    NSArray *Array1 = [self.scrollwithimage subviews];
    for (btn in Array1){
        if ([btn isKindOfClass:[UIImageView class]]){
            [btn removeFromSuperview];
        }
    }
    
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
    visitado = [self insertarnuevovisitado:localseleccionado];
    [self limpiarimagen];
    CGSize completo = CGSizeMake(320, 460);
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
        
        NSLog(@"%@",[imagenesarray objectAtIndex:i]);
        
        if (!visitado) {
            //[self descargarimagen:[imagenesarray objectAtIndex:i] carpeta:carpeta foto:fotointerna];
            NSFileManager *fm = [NSFileManager defaultManager];
            if (![fm fileExistsAtPath:carpeta]) {
                [fm createDirectoryAtPath:carpeta withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            if (![fm fileExistsAtPath:fotointerna]) {
                NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:[imagenesarray objectAtIndex:i]]];
                [data3 writeToFile:fotointerna atomically:YES];
                
            }
        }
        NSData *imgData = [NSData dataWithContentsOfFile:fotointerna];
        
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        [subimage setImage:thumbNail];
        if (i == 0) {
            //    imagepost = thumbNail;
        }
        [self.scrollwithimage addSubview:subimage];
    }
    [self.indicador stopAnimating];
    [self.indicador setHidden:YES];
    NSLog(@"imagenes establecidas");
}

-(void)posicionarobjetos{
    CGSize completo = CGSizeMake(320, 460);
    [self.scroll setFrame:CGRectMake(0, 0, completo.width, completo.height)];
    [self.labelTitulo setFrame:CGRectMake(0, 0, completo.width, self.labelTitulo.frame.size.height)];
    [self.descripcionText setFrame:CGRectMake(0, 25, completo.width, self.descripcionText.frame.size.height)];
    [self.scrollwithimage setFrame:CGRectMake(0, 230,completo.width,120)];
    [self.paginawebButton setFrame:CGRectMake(0, 355, completo.width, self.paginawebButton.frame.size.height)];
    
    self.scrollwithimage.contentSize = CGSizeMake(completo.width * 2, 120);
    
    [self.indicador startAnimating];
    self.queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(establecerimagenes)
                                                                              object:nil];
    
    [self.queue addOperation:operation];
    
    //[self establecerimagenes];
    
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

-(void)configurarfacebook{
    /*
     [SZFacebookUtils setAppId:@"322714617838202"];
     NSString *existingToken = @"EXISTING_TOKEN";
     NSDate *existingExpiration = [NSDate distantFuture];
     
     [SZFacebookUtils linkWithAccessToken:existingToken expirationDate:existingExpiration success:^(id<SocializeFullUser> user) {
     NSLog(@"Link successful");
     } failure:^(NSError *error) {
     NSLog(@"Link failed: %@", [error localizedDescription]);
     }];
     */
}

-(void)regresomapa:(UIBarButtonItem *)sender{
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
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:twitterButton,facebookButton, nil];
    
    [self.navigationController.navigationBar setAlpha:10];
    [self.navigationController.navigationBar setTranslucent:NO];
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

-(void)configuraciones{
    [self cargarvisitados];
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
    //appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //[self configuraciones];
}

-(void)cambiaridioma:(Idioma *)idiom{
    selectidioma = idiom;
    auxlocal = [[local alloc]init];
    [self cargarinfolocal];
    [self establecerdatos];
}

-(void)viewWillAppear:(BOOL)animated{
    //[self setContentSizeForViewInPopover:CGSizeMake(320, 470)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self configuracionbotonback];
    }
    
    [self configuraciones];
    //[self iniciaslide];
}

-(void)viewDidAppear:(BOOL)animated{
    self.contentSizeForViewInPopover = CGSizeMake(320, 460);
    [self posicionarobjetos];
}

- (void)viewDidUnload
{
    [self setLabelTitulo:nil];
    [self setDescripcionText:nil];
    [self setPaginawebButton:nil];
    [self setAuxlocal:nil];
    [self setScroll:nil];
    [self setScrollwithimage:nil];
    [self setScrollwithimage:nil];
    [self setSharebutton:nil];
    [self setPageControl:nil];
    [self setSecondScroll:nil];
    [self setIndicador:nil];
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

-(void)cerrarshow{
    self.contentSizeForViewInPopover = CGSizeMake(320, 460);
    [self.view setFrame:CGRectMake(0, 0, 320, 460)];
    [self posicionarobjetos];
}

@end
