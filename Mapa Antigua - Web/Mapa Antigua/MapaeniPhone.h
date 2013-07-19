//
//  MapaeniPhone.h
//  Aqui en... Antigua
//
//  Created by Luis Angel Ramos Gomez on 5/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "locacion.h"
#import "Servicio.h"
#import "Categoria.h"
#import "Tipo.h"
#import "Informacionlocal.h"
#import "Ofertas.h"
#import "imagenlogo.h"
#import "Anuncios.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@protocol MapaiPhonedelegate <NSObject>
@optional
-(void)abrioinfo;
-(void)cerroinfo;
@end

@interface MapaeniPhone : UIViewController<UISplitViewControllerDelegate,UIPopoverControllerDelegate,
Infolocaldelegate,Ofertasdelegate>{
    AppDelegate *appDelegate;
    UIPopoverController *popoverControllerinfo;
    Informacionlocal *infolocal;
    Ofertas *oferta;
    
    __weak id<MapaiPhonedelegate> delegate;
}

@property (nonatomic,strong) Idioma *selectidioma;
@property (nonatomic,strong) local *auxlocal;
@property (nonatomic,strong) locacion *auxlocacion;

@property (nonatomic,strong) Servicio *auxservicio;
@property (nonatomic,strong) Categoria *auxcategoria;
@property (nonatomic,strong) Tipo *auxtipo;
@property (nonatomic,retain) Anuncios *auxanuncios;

@property (nonatomic,strong) imagenlogo *auxlogo;

@property (nonatomic, retain) NSMutableArray *locacionesArray;
@property (nonatomic, retain) NSMutableArray *localesArray;
@property (nonatomic, retain) NSMutableArray *todoturismo;

@property (nonatomic, retain) NSString *selecciontodo;

@property (nonatomic) CGPoint puntoxy;
@property (nonatomic, retain) NSString *titserv;
@property (nonatomic, retain) NSString *titcat;
@property (nonatomic, retain) NSString *tittip;
@property (nonatomic) int turismo;
@property (nonatomic) BOOL busqueda;

@property(weak,nonatomic) id<MapaiPhonedelegate> delegate;

-(void)ubicarbotonoes;
-(void)cargarlocaciones;
-(void)cambiaridioma:(Idioma *)idioma;
-(void)establecertitulo;

@end
