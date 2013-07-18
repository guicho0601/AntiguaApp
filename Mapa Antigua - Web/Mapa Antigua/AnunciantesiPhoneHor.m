//
//  AnunciantesiPhoneHor.m
//  Aqui en Antigua
//
//  Created by Luis Angel Ramos Gomez on 13/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#define ancho 440
#define alto 100
#define tiempo 6

#import "AnunciantesiPhoneHor.h"

@implementation AnunciantesiPhoneHor
@synthesize scrollView;
@synthesize pageControl;
@synthesize widhtall,heihtall,anunciosarray,detailViewController,delegate,queue;

-(void)cargaranuncios{
    if(anunciosarray != nil)
    {
        [anunciosarray removeAllObjects];
    } else {
        anunciosarray = [[NSMutableArray alloc]init];
    }
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    if(sqlite3_open([appDelegate.databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *sqlStatement = [NSString stringWithFormat:@"select * from anuncios"];
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                NSString *id_local = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *local = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *imagen = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                Anuncios *auxanuncios = [[Anuncios alloc]init];
                auxanuncios.id_local = [id_local intValue];
                auxanuncios.local = local;
                auxanuncios.imagen = imagen;
                
                [anunciosarray addObject:auxanuncios];
            }
        } else {
            
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
}

-(void)iniciaranuncios{
    cambioauto = true;
    thread = [[NSThread alloc]initWithTarget:self selector:@selector(cambioautomatico) object:nil];
    [thread start];
}

-(void)abrirlocal:(UITapGestureRecognizer *)sender{
    CGPoint punto = [sender locationInView:self.scrollView];
    int abc = 0;
    for (int i=0; i<anunciosarray.count; i++) {
        float a = medio*i;
        float b = a+medio;
        if (punto.x > a && punto.x < b) {
            abc = i;
            break;
        }
    }
     if (abc < [anunciosarray count]) {
         Anuncios *aux = [anunciosarray objectAtIndex:abc];
         [self.detailViewController setAuxanuncios:aux];
         [self.detailViewController setSelecciontodo:@"Anuncio"];
         [self.detailViewController cargarlocaciones];
         [self.delegate cerrarmenuhor];
     }
}

-(void)cargarimagen{
    CGFloat puntoancho=0;
    medio = ancho/3;
    for (int i=0; i < anunciosarray.count; i++) {
        Anuncios *aux = [anunciosarray objectAtIndex:i];
        
        CGRect frame;
        frame.origin.x=puntoancho;
        frame.origin.y=0;
        frame.size.width = medio;
        frame.size.height = alto;
        
        UIImageView *subimage = [[UIImageView alloc]initWithFrame:frame];
        NSURL *url = [NSURL URLWithString:aux.imagen];
        NSString *nombrearchivo = url.lastPathComponent;
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",docDir,nombrearchivo];
        if (![fm fileExistsAtPath:fotointerna]) {
            [self.view addSubview:indicador];
            [indicador startAnimating];
            NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:aux.imagen]];
            [data3 writeToFile:fotointerna atomically:YES];
        }
        NSData *imgData = [NSData dataWithContentsOfFile:fotointerna];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        [subimage setImage:thumbNail];
        
        [self.scrollView addSubview:subimage];
        
        puntoancho+= medio;
    }
}
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object 
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == self.queue && [keyPath isEqualToString:@"operations"]) {
        if ([self.queue.operations count] == 0) {
            [indicador stopAnimating];
            [indicador removeFromSuperview];
            //NSLog(@"queue has completed");
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object 
                               change:change context:context];
    }
}

-(void)configuraciones{
    pageControlBeingUsed = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(abrirlocal:)];
    tap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tap];
    
    float tem = (anunciosarray.count/3);
    if (fmod(anunciosarray.count,3) != 0){
        tem +=1;
    }
	self.scrollView.contentSize = CGSizeMake(ancho * tem, alto);
	self.scrollView.delegate = self;
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
	self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = tem;
    [self iniciaranuncios];
    [self.pageControl setFrame:CGRectMake(0, heihtall-36, widhtall, 36)];
    [self.pageControl setHidden:YES];
    
    self.queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(cargarimagen)
                                        object:nil];
    [self.queue addOperation:operation];
    [self.queue addObserver:self forKeyPath:@"operations" options:0 context:NULL];
    indicador = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicador.center = CGPointMake(ancho/2,alto/2);
    [indicador startAnimating];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self cargaranuncios];
	[self configuraciones];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (IBAction)changePage {
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
}

-(void)cambioautomatico{
    while (cambioauto) {
        int a= self.pageControl.currentPage;
        if ((self.pageControl.numberOfPages-1) == a) {
            a = 0;
        }else{
            a += 1;
        }
        self.pageControl.currentPage = a;
        [self changePage];
        [NSThread sleepForTimeInterval:tiempo];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
