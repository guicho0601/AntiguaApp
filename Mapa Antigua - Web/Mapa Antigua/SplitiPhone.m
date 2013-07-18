//
//  SplitiPhone.m
//  Aqui en... Antigua
//
//  Created by Luis Angel Ramos Gomez on 5/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SplitiPhone.h"

#define casita @"Casa.png"
#define casitaroja @"Casaroja.png"
#define tuerca @"tu.png"

@implementation SplitiPhone{
    UIView *tempview;
    UIImageView *viimg;
}
@synthesize menu;
@synthesize anuncios;
@synthesize separador;
@synthesize mapa;
@synthesize infoButton;
@synthesize menuimage,settimage,restaurante,areas,brujula;

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


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        widhtall = self.view.bounds.size.width;
        heightall = self.view.bounds.size.height;
        [mapaiphone.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
        if (!showmenu) {
//            OCULTAR VERTICAL
            [self.menu setFrame:CGRectMake(0, 0, 0, heightall-70)];
            [self.anuncios setFrame:CGRectMake(0, heightall-70, 0, 70)];
            [self.mapa setFrame:CGRectMake(0, 0, 320, heightall)];
            [menuimage setFrame:CGRectMake( 0,heightall-120, 40, 40)];
            [settimage setFrame:CGRectMake(0,heightall-80, 40, 40)];
            [brujula setFrame:CGRectMake(0, heightall-160, 40, 40)];
            [self.areas setFrame:CGRectMake(0, heightall-20, widhtall, 20)];
            [self.mapa setUserInteractionEnabled:YES];
            [self.menuimage setImage:[UIImage imageNamed:casita]];
        }else{
//            MOSTRAR VERTICAL
            [menu setFrame:CGRectMake(0, 0, widhtall-40, heightall-100)];
            //[servicios.view setFrame:CGRectMake(0, 0, 300, 460)];
            [navigatormaster.view setFrame:CGRectMake(0, 0, widhtall-40, heightall)];
            [mapa setFrame:CGRectMake(widhtall-40, 0, navigatormapa.view.frame.size.width, navigatormapa.view.frame.size.height)];
            
            [anuncios setFrame:CGRectMake(0, heightall-100, widhtall-40, 100)];
            anun = [[AnunciantesiPhoneVer alloc]initWithNibName:nil bundle:nil];
            [anun setDetailViewController:mapaiphone];
            [anun setDelegate:self];
            [anun.view setFrame:CGRectMake(0, 0, widhtall-40, 125)];
            [anuncios addSubview:anun.view];
            [anuncios bringSubviewToFront:anun.view];
            
            [self.navigationController.navigationBar setHidden:YES];
            [self.menuimage setFrame:CGRectMake(widhtall-40, heightall-120, 40, 40)];
            [self.settimage setFrame:CGRectMake(widhtall-40, heightall-80, 40, 40)];
            [brujula setFrame:CGRectMake(widhtall-40, heightall-160, 40, 40)];
            [self.areas setFrame:CGRectMake(widhtall-40, heightall-20, 40, 20)];
            int a=[navigatormaster.viewControllers count];
            switch (a) {
                case 1:
                    [servicios.navigationController.navigationBar setFrame:CGRectMake(0, 0,widhtall-40, 44)];
                    break;
                case 2:
                    [categorias.navigationController.navigationBar setFrame:CGRectMake(0, 0,widhtall-40, 44)];
                    break;
                    
                case 3:
                    if (restaurante.comida == 1) {
                        [tipos.navigationController.navigationBar setFrame:CGRectMake(0, 0,widhtall-40, 44)];
                    }else{
                        [locales.navigationController.navigationBar setFrame:CGRectMake(0, 0,widhtall-40, 44)];
                    }
                    break;
                    
                case 4:
                    [locales.navigationController.navigationBar setFrame:CGRectMake(0, 0,widhtall-40, 44)];
                    break;
                    
                    
                default:
                    break;
            }    
            [self.mapa setUserInteractionEnabled:NO];
            [self.menuimage setImage:[UIImage imageNamed:casitaroja]];
        }
    }else{
        widhtall = self.view.bounds.size.width;
        heightall = self.view.bounds.size.height;
        if (mapaiphone.navigationController.viewControllers.count > 1) {
            [mapaiphone.navigationController.navigationBar setFrame:CGRectMake(0, 0, 480, 44)];
        }else{
            [mapaiphone.navigationController.navigationBar setFrame:CGRectMake(0, 0, 480, 22)];
        }
        if (!showmenu) {
//            OCULTAR HORIZONTAL
            [self.menu setFrame:CGRectMake(0, 0, 0, heightall-70)];
            [self.anuncios setFrame:CGRectMake(0, heightall-70, 0, 70)];
            [self.mapa setFrame:CGRectMake(0, 0, widhtall, heightall)];
            [menuimage setFrame:CGRectMake( 0,heightall-120, 40, 40)];
            [settimage setFrame:CGRectMake(0,heightall-80, 40, 40)];
            [brujula setFrame:CGRectMake(0, heightall-160, 40, 40)];
            [areas setFrame:CGRectMake(0, heightall-20, widhtall, 20)];
            [self.mapa setUserInteractionEnabled:YES];
            [self.menuimage setImage:[UIImage imageNamed:casita]];
            
        }else{
//            MOSTRAR HORIZONTAL
            [self.menu setFrame:CGRectMake(0, 0, widhtall-40, heightall-100)];
            [navigatormaster.view setFrame:CGRectMake(0, 0, widhtall-40, heightall-100)];
            int a=[navigatormaster.viewControllers count];
            switch (a) {
                case 1:
                    [servicios.navigationController.navigationBar setFrame:CGRectMake(0, 0, widhtall-40, 32)];
                    [servicios.view setFrame:CGRectMake(0, 0, widhtall-40, heightall-50)];
                    break;
                case 2:
                    [categorias.navigationController.navigationBar setFrame:CGRectMake(0, 0, widhtall-40, 32)];
                    [categorias.view setFrame:CGRectMake(0, 0, widhtall-40, heightall-50)];
                    break;
                    
                case 3:
                    if (restaurante.comida == 1) {
                        [tipos.navigationController.navigationBar setFrame:CGRectMake(0, 0, widhtall-40, 32)];
                        [tipos.view setFrame:CGRectMake(0, 0, widhtall-40, heightall-50)];
                    }else{
                        [locales.navigationController.navigationBar setFrame:CGRectMake(0, 0, widhtall-40, 32)];
                        [locales.view setFrame:CGRectMake(0, 0, widhtall-40, heightall-50)];
                    }
                    break;
                    
                case 4:
                    [locales.navigationController.navigationBar setFrame:CGRectMake(0, 0, widhtall-40, 32)];
                    [locales.view setFrame:CGRectMake(0, 0, widhtall-40, heightall-50)];
                    break;
                    
                default:
                    break;
            }
            anunh = nil;
            anunh = [[AnunciantesiPhoneHor alloc]initWithNibName:nil bundle:nil];
            [anunh setDelegate:self];
            [anunh setDetailViewController:mapaiphone];
            [anunh.view setFrame:CGRectMake(0, 0, widhtall-40, 100)];
            [self.anuncios setFrame:CGRectMake(0, heightall-100, widhtall-40, 100)];
            [self.anuncios addSubview:anunh.view];
            [self.anuncios bringSubviewToFront:anunh.view];
            
            [mapa setFrame:CGRectMake(widhtall-40, 0, 480, heightall)];
            [menuimage setFrame:CGRectMake( widhtall-40,heightall-120, 40, 40)];
            [settimage setFrame:CGRectMake(widhtall-40,heightall-80, 40, 40)];
            [brujula setFrame:CGRectMake(widhtall-40, heightall-160, 40, 40)];
            [areas setFrame:CGRectMake(widhtall-40, heightall-20, 40, 20)];
            [self.mapa setUserInteractionEnabled:NO];
            [self.menuimage setImage:[UIImage imageNamed:casitaroja]];
        }
    }
}

-(void)cerrarmenu:(UITapGestureRecognizer *)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    if (showmenu) {
        if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
//            OCULTAR VERTICAL
            [self.menu setFrame:CGRectMake(0, 0, 0, heightall-70)];
            [self.separador setFrame:CGRectMake(0, heightall-70, 0, 70)];
            [self.mapa setFrame:CGRectMake(0, 0, widhtall, heightall)];
            [self.menuimage setFrame:CGRectMake(0, heightall-120, 40,40 )];
            [self.settimage setFrame:CGRectMake(0, heightall-80, 40, 40)];
            [brujula setFrame:CGRectMake(0, heightall-160, 40, 40)];
            [self.areas setFrame:CGRectMake(0, heightall-20, widhtall, 20)];
            [self.mapa setUserInteractionEnabled:YES];
        }else{
//            OCULTAR HORIZONAL
            [self.menu setFrame:CGRectMake(0, 0, 0, heightall-70)];
            [self.anuncios setFrame:CGRectMake(0, heightall-70, 0, 70)];
            [self.mapa setFrame:CGRectMake(0, 0, widhtall, heightall)];
            [menuimage setFrame:CGRectMake( 0,heightall-120, 40, 40)];
            [settimage setFrame:CGRectMake(0,heightall-80, 40, 40)];
            [brujula setFrame:CGRectMake(0, heightall-160, 40, 40)];
            [areas setFrame:CGRectMake(0, heightall-20, widhtall, 20)];
            [self.mapa setUserInteractionEnabled:YES];
        }
        //[self.navigationController.navigationBar setHidden:NO];
        [self.menuimage setImage:[UIImage imageNamed:casita]];
        showmenu = false;
    }
    [UIView commitAnimations];
}

-(void)mostrarmenu:(UITapGestureRecognizer *)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        widhtall = self.view.bounds.size.width;
        heightall = self.view.bounds.size.height;
        if (!showmenu) {
//            MOSTRAR MENU VERTICAL
                        
            [menu setFrame:CGRectMake(0, 0, widhtall-40, heightall-100)];
            //[servicios.view setFrame:CGRectMake(0, 0, 300, 460)];
            [navigatormaster.view setFrame:CGRectMake(0, 0, widhtall-40, heightall)];
            [mapa setFrame:CGRectMake(widhtall-40, 0, navigatormapa.view.frame.size.width, navigatormapa.view.frame.size.height)];
            
            [anuncios setFrame:CGRectMake(0, heightall-100, widhtall-40, 100)];
            anun = [[AnunciantesiPhoneVer alloc]initWithNibName:nil bundle:nil];
            [anun setDetailViewController:mapaiphone];
            [anun setDelegate:self];
            [anun.view setFrame:CGRectMake(0, 0, widhtall-40, 125)];
            [anuncios addSubview:anun.view];
            [anuncios bringSubviewToFront:anun.view];
            
            
            
            [self.navigationController.navigationBar setHidden:YES];
            [self.menuimage setFrame:CGRectMake(widhtall-40, heightall-120, 40, 40)];
            [self.menuimage setImage:[UIImage imageNamed:casitaroja]];
            [self.settimage setFrame:CGRectMake(widhtall-40, heightall-80, 40, 40)];
            [brujula setFrame:CGRectMake(widhtall-40, heightall-160, 40, 40)];
            [self.areas setFrame:CGRectMake(widhtall-40, heightall-20, 40, 20)];
            int a=[navigatormaster.viewControllers count];
            switch (a) {
                case 1:
                    [servicios.navigationController.navigationBar setFrame:CGRectMake(0, 0,widhtall-40, 44)];
                    break;
                case 2:
                    [categorias.navigationController.navigationBar setFrame:CGRectMake(0, 0,widhtall-40, 44)];
                    break;
                    
                case 3:
                    if (restaurante.comida == 1) {
                        [tipos.navigationController.navigationBar setFrame:CGRectMake(0, 0,widhtall-40, 44)];
                    }else{
                        [locales.navigationController.navigationBar setFrame:CGRectMake(0, 0,widhtall-40, 44)];
                    }
                    break;
                    
                case 4:
                    [locales.navigationController.navigationBar setFrame:CGRectMake(0, 0,widhtall-40, 44)];
                    break;
                    
                    
                default:
                    break;
            }
            [self.mapa setUserInteractionEnabled:NO];
            
            showmenu = true;
        }else{  
//            OCULTAR MENU VERTICAL
            [self.menu setFrame:CGRectMake(0, 0, 0, heightall-70)];
            [self.separador setFrame:CGRectMake(0, heightall-70, 0, 70)];
            [self.mapa setFrame:CGRectMake(0, 0, widhtall, heightall)];
            [self.menuimage setFrame:CGRectMake(0, heightall-120, 40,40 )];
            [self.settimage setFrame:CGRectMake(0, heightall-80, 40, 40)];
            [brujula setFrame:CGRectMake(0, heightall-160, 40, 40)];
            [self.areas setFrame:CGRectMake(0, heightall-20, widhtall, 20)];
            [self.mapa setUserInteractionEnabled:YES];
            [self.menuimage setImage:[UIImage imageNamed:casita]];
            showmenu = false;
        }
    }else{
        widhtall = self.view.bounds.size.width;
        heightall = self.view.bounds.size.height;
        if (!showmenu) {
//            MOSTRAR MENU HORIZONTAL
                        
            [self.menu setFrame:CGRectMake(0, 0, widhtall-40, heightall-100)];
            [navigatormaster.view setFrame:CGRectMake(0, 0, widhtall-40, heightall-100)];
            int a=[navigatormaster.viewControllers count];
            switch (a) {
                case 1:
                    [servicios.navigationController.navigationBar setFrame:CGRectMake(0, 0, widhtall-40, 32)];
                    [servicios.view setFrame:CGRectMake(0, 0, widhtall-40, heightall-50)];
                    break;
                case 2:
                    [categorias.navigationController.navigationBar setFrame:CGRectMake(0, 0, widhtall-40, 32)];
                    [categorias.view setFrame:CGRectMake(0, 0, widhtall-40, heightall-50)];
                    break;
                    
                case 3:
                    if (restaurante.comida == 1) {
                        [tipos.navigationController.navigationBar setFrame:CGRectMake(0, 0, widhtall-40, 32)];
                        [tipos.view setFrame:CGRectMake(0, 0, widhtall-40, heightall-50)];
                    }else{
                        [locales.navigationController.navigationBar setFrame:CGRectMake(0, 0, widhtall-40, 32)];
                        [locales.view setFrame:CGRectMake(0, 0, widhtall-40, heightall-50)];
                    }
                    break;
                    
                case 4:
                    [locales.navigationController.navigationBar setFrame:CGRectMake(0, 0, widhtall-40, 32)];
                    [locales.view setFrame:CGRectMake(0, 0, widhtall-40, heightall-50)];
                    break;
                    
                default:
                    break;
            }
            anunh = nil;
            anunh = [[AnunciantesiPhoneHor alloc]initWithNibName:nil bundle:nil];
            [anunh setDelegate:self];
            [anunh setDetailViewController:mapaiphone];
            [anunh.view setFrame:CGRectMake(0, 0, widhtall-40, 100)];
            [self.anuncios setFrame:CGRectMake(0, heightall-100, widhtall-40, 100)];
            [self.anuncios addSubview:anunh.view];
            [self.anuncios bringSubviewToFront:anunh.view];
            
            [mapa setFrame:CGRectMake(widhtall-40, 0, 480, heightall)];
            [menuimage setFrame:CGRectMake( widhtall-40,heightall-120, 40, 40)];
            [menuimage setImage:[UIImage imageNamed:casitaroja]];
            [settimage setFrame:CGRectMake(widhtall-40,heightall-80, 40, 40)];
            [brujula setFrame:CGRectMake(widhtall-40, heightall-160, 40, 40)];
            [areas setFrame:CGRectMake(widhtall-40, heightall-20, 40, 20)];
            [self.mapa setUserInteractionEnabled:NO];
            
            showmenu = true;
        }else{
//            OCULTAR MENU HORIZONTAL
            [self.menu setFrame:CGRectMake(0, 0, 0, heightall-70)];
            [self.anuncios setFrame:CGRectMake(0, heightall-70, 0, 70)];
            [self.mapa setFrame:CGRectMake(0, 0, widhtall, heightall)];
            [menuimage setFrame:CGRectMake( 0,heightall-120, 40, 40)];
            [settimage setFrame:CGRectMake(0,heightall-80, 40, 40)];
            [brujula setFrame:CGRectMake(0, heightall-160, 40, 40)];
            [areas setFrame:CGRectMake(0, heightall-20, widhtall, 20)];
            [self.mapa setUserInteractionEnabled:YES];
            [self.menuimage setImage:[UIImage imageNamed:casita]];
            showmenu = false;
        }
    }
    [UIView commitAnimations];
}

-(void)mostraridioma:(UITapGestureRecognizer *)sender{
    //NSString *titulo,
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
    
    [(Listaservicios *) [navigatormaster.viewControllers objectAtIndex:0] cambiaridioma:selectidioma];
    int a = [navigatormaster.viewControllers count];
    if (buscar == nil) {
        if (a>1) {
            [(CategoriasiPhone *) [navigatormaster.viewControllers objectAtIndex:1]cambiaridioma:selectidioma];
            if (a>2) {
                restaurante = [(CategoriasiPhone *) [navigatormaster.viewControllers objectAtIndex:1] auxrestaurante];
                if (restaurante.comida == 0) {
                    [(ListalocalesiPhone *) [navigatormaster.viewControllers objectAtIndex:2]cambiaridioma:selectidioma];
                }else{
                    [(ListalocalesiPhone *) [navigatormaster.viewControllers objectAtIndex:2]cambiaridioma:selectidioma];
                }
                if (a>3) {
                    [(ListalocalesiPhone *) [navigatormaster.viewControllers objectAtIndex:3]cambiaridioma:selectidioma];
                }
            }
        }
    }else{
        [buscar cambiodeidioma:selectidioma];
    }
    [(MapaeniPhone *) [navigatormapa.viewControllers objectAtIndex:0]cambiaridioma:selectidioma];
}

-(void)iniciocorelocation{
    locationManager=[[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.headingFilter = 1;
    locationManager.delegate=self;
    locationManager.distanceFilter = 1;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    [CLLocationManager locationServicesEnabled];
}

-(NSString *)imagentutorial{
    NSString *img;
    if (selectidioma.idioma == 0){
        img = @"ingles1.png";
    }
    else{ 
        img = @"Min_Tutorial.png";
    }
    return img;
}

-(void)iniciartempview{
    viimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[self imagentutorial]]];
    float locx = (self.view.bounds.size.width - viimg.image.size.width )/2;
    tempview = [[UIView alloc]init];
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
    [tempview setFrame:CGRectMake(locx, self.view.bounds.size.height,viimg.image.size.width ,viimg.image.size.height)];
    [UIView commitAnimations];
}

-(void)ocultartutorial{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    float locx = (self.view.bounds.size.width - viimg.image.size.width )/2;
    [tempview setFrame:CGRectMake(locx, self.view.bounds.size.height,viimg.image.size.width ,viimg.image.size.height)];
    [UIView commitAnimations];
}

#pragma mark - View lifecycle

-(void)configuraciones{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int selleng = [defaults integerForKey:@"lenguaje"];
    
    widhtall = self.view.bounds.size.width;
    heightall = self.view.bounds.size.height;
    
    //servicios = [[Listaservicios alloc]initWithStyle:UITableViewStylePlain];
    servicios = [[Listaservicios alloc]initWithNibName:nil bundle:nil];
    mapaiphone = [[MapaeniPhone alloc]initWithNibName:nil bundle:nil];
    
    [servicios setDetail:mapaiphone];
    servicios.delegate=self;
    [mapaiphone setDelegate:self];
    
    [servicios.view setFrame:CGRectMake(0, 0, 300, 460)];
    navigatormaster = [[UINavigationController alloc]initWithRootViewController:servicios];
    [navigatormaster.view setFrame:CGRectMake(0, 0, 300, 460)];
    [menu addSubview:navigatormaster.view];
    
    [self.menu setFrame:CGRectMake(0, 0, 0, 290)];
    [self.anuncios setFrame:CGRectMake(0, 290, 0, 70)];
    [self.separador setFrame:CGRectMake(0, 0, 0, 0)];
    
    [self.menu setBackgroundColor:[UIColor blackColor]];
    
    [mapaiphone.view setFrame:CGRectMake(0, 0, widhtall, heightall)];
    navigatormapa = [[UINavigationController alloc]initWithRootViewController:mapaiphone];
    [navigatormapa.view setFrame:CGRectMake(0, 0, 163, heightall)];
    [self.mapa addSubview:navigatormapa.view];
    [self.mapa setFrame:CGRectMake(0, 0, widhtall, heightall)];
    [mapaiphone.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [mapaiphone.navigationController.navigationBar setTranslucent:YES];
    [mapaiphone.navigationController.navigationBar setAlpha:0.5];
    
    menuimage = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.view.bounds.size.height-120, 40, 40)];
    [menuimage setImage:[UIImage imageNamed:casita]];
    [menuimage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapmenu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mostrarmenu:)];
    [tapmenu setNumberOfTapsRequired:1];
    [menuimage addGestureRecognizer:tapmenu];
    [self.view addSubview:menuimage];
    [self.view bringSubviewToFront:menuimage];
    
    settimage = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.view.bounds.size.height-80, 40, 40)];
    [settimage setImage:[UIImage imageNamed:tuerca]];
    [settimage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapsett = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mostraridioma:)];
    [tapsett setNumberOfTapsRequired:1];
    [settimage addGestureRecognizer:tapsett];
    [self.view addSubview:settimage];
    [self.view bringSubviewToFront:settimage];
    
    brujula = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-160, 40, 40)];
    [brujula setImage:[UIImage imageNamed:imagenbrujula]];
    [self.view addSubview:brujula];
    [self.view bringSubviewToFront:brujula];
    
    areas = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-20, self.view.bounds.size.width, 20)];
    [areas setBackgroundColor:[UIColor blackColor]];
    [areas setTextColor:[UIColor whiteColor]];
    [areas setAlpha:0.25];
    [areas setText:@"Hola"];
    //[self.view addSubview:areas];
    //[self.view bringSubviewToFront:areas];
    
    UISwipeGestureRecognizer *menuclose = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(cerrarmenu:)];
    [menuclose setDirection:UISwipeGestureRecognizerDirectionLeft];
    [menu addGestureRecognizer:menuclose];
    
    [anuncios setBackgroundColor:[UIColor redColor]];
    
    [servicios.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    showmenu = false;
    
    selectidioma = [[Idioma alloc]init];
    selectidioma.idioma = selleng;
    [servicios setSelectidioma:selectidioma];
    [mapaiphone setSelectidioma:selectidioma];
    
    [self iniciocorelocation];
    [self iniciartempview];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configuraciones];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [mapaiphone.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [mapaiphone.navigationController.navigationBar setTranslucent:YES];
    [mapaiphone.navigationController.navigationBar setAlpha:0.5];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [mapaiphone.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [mapaiphone.navigationController.navigationBar setTranslucent:YES];
    [mapaiphone.navigationController.navigationBar setAlpha:0.5];
    
    [self mostrandotempview];
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(ocultandotempview)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)viewDidUnload
{
    [self setMenu:nil];
    [self setAnuncios:nil];
    [self setSeparador:nil];
    [self setMapa:nil];
    [self setInfoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
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
    NSLog(@"Giro");
}


-(void)cerrarmenugeneral{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        widhtall = self.view.bounds.size.width;
        heightall = self.view.bounds.size.height;
        [self.menu setFrame:CGRectMake(0, 0, 0, heightall-70)];
        [self.separador setFrame:CGRectMake(0, heightall-70, 0, 70)];
        [self.mapa setFrame:CGRectMake(0, 0, widhtall, heightall)];
        [self.menuimage setFrame:CGRectMake(0, heightall-120, 40,40 )];
        [self.settimage setFrame:CGRectMake(0, heightall-80, 40, 40)];
        [brujula setFrame:CGRectMake(0, heightall-160, 40, 40)];
        [self.areas setFrame:CGRectMake(0, heightall-20, widhtall, 20)];
    }else{
        widhtall = self.view.bounds.size.width;
        heightall = self.view.bounds.size.height;
        
        [self.menu setFrame:CGRectMake(0, 0, 0, heightall-70)];
        [self.anuncios setFrame:CGRectMake(0, heightall-70, 0, 70)];
        [self.mapa setFrame:CGRectMake(0, 0, widhtall, heightall)];
        [menuimage setFrame:CGRectMake( 0,heightall-120, 40, 40)];
        [settimage setFrame:CGRectMake(0,heightall-80, 40, 40)];
        [brujula setFrame:CGRectMake(0, heightall-160, 40, 40)];
        [self.areas setFrame:CGRectMake(0, heightall-20, widhtall, 20)];
    }
    [self.mapa setUserInteractionEnabled:YES];
    [self.menuimage setImage:[UIImage imageNamed:casita]];
    showmenu = false;
    [UIView commitAnimations];
}

-(void) seleccioncerrarmenu{
    [self cerrarmenugeneral];
}

-(void)cerrarmenuver{
    [self cerrarmenugeneral];
}

-(void)cerrarmenuhor{
    [self cerrarmenugeneral];
}

-(void)setCategorias:(CategoriasiPhone *)cat{
    categorias = cat;
}

-(void)setTiposser:(ListatiposiPhone *)tip{
    tipos = tip;
}

-(void)setLocalser:(ListalocalesiPhone *)loc{
    locales = loc;
}

-(void)setAreasser:(NSString *)cad{
    [self.areas setText:cad];
}

-(void)avisosearchservicio:(Search *)aux{
    buscar = aux;
}

-(void)abrioinfo{
    [settimage setHidden:YES];
    [menuimage setHidden:YES];
    [brujula setHidden:YES];
}

-(void)cerroinfo{
    [settimage setHidden:NO];
    [menuimage setHidden:NO];
    [brujula setHidden:NO];
    if((UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))){
        [mapaiphone.navigationController.navigationBar setFrame:CGRectMake(0, 0,self.view.bounds.size.width , 22)];
    }else{
        [mapaiphone.navigationController.navigationBar setFrame:CGRectMake(0, 0,self.view.bounds.size.width , 44)];
    }
}

@end
