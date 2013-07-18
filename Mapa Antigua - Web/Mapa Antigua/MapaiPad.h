//
//  MapaiPad.h
//  Aqui en... Antigua
//
//  Created by Luis Angel Ramos Gomez on 4/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "local.h"
#import "locacion.h"
#import "Idioma.h"
#import "Servicio.h"
#import "Categoria.h"
#import "Tipo.h"
#import "imagenlogo.h"
#import "Anuncios.h"
#import "ShowImageiPad.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "InformacionLocaliPad.h"

@interface MapaiPad : UIViewController<UISplitViewControllerDelegate,UIPopoverControllerDelegate,CLLocationManagerDelegate>{
    AppDelegate *appDelegate;
    UIPopoverController *popoverControllerinfo;
    InformacionLocaliPad *infolocal;
    ShowImageiPad *oferta;
    UIImageView *brujula;
    BOOL masterescondido;
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property (nonatomic,retain) InformacionLocaliPad *infolocal;
@property (nonatomic,strong) Idioma *selectidioma;
@property (nonatomic,retain) local *auxlocal;
@property (nonatomic,retain) locacion *auxlocacion;

@property (nonatomic,retain) Servicio *auxservicio;
@property (nonatomic,retain) Categoria *auxcategoria;
@property (nonatomic,retain) Tipo *auxtipo;
@property (nonatomic,retain) Anuncios *auxanuncios;

@property (nonatomic,strong) imagenlogo *auxlogo;

@property (nonatomic, retain) NSMutableArray *locacionesArray;
@property (nonatomic, retain) NSMutableArray *localesArray;
@property (nonatomic, retain) NSMutableArray *todoturismo;

@property (nonatomic, retain) NSString *selecciontodo;

@property (nonatomic, retain) NSString *titserv;
@property (nonatomic, retain) NSString *titcat;
@property (nonatomic, retain) NSString *tittip;
@property (nonatomic) int turismo;
@property (nonatomic) BOOL busqueda;

-(void)ubicarbotonoes;
-(void)cargarlocaciones;
-(void)cambiaridioma:(Idioma *)idioma;
-(void)establecertitulo;

@end
