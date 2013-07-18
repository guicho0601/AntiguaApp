//
//  SplitViewControlleriPad.h
//  Aqui en... Antigua
//
//  Created by Luis Angel Ramos Gomez on 4/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListaServiciosiPad.h"
#import "CategoriasiPad.h"
#import "ListatiposiPad.h"
#import "ListalocalesiPad.h"
#import "MapaiPad.h"
#import "Idioma.h"
#import "Restaurante.h"
#import "Anunciantes.h"
#import "Search.h"
#import "Info_horizontal.h"

@interface SplitViewControlleriPad : UIViewController<UIPopoverControllerDelegate,Serviciosdelegate,infogeneralhordelegate>{
    UINavigationController *masternavigator;
    UINavigationController *detailnavigator;
    
    UIView *master;
    UIView *detail;
    UIView *separador;
    UIView *anuncios;
    
    ListaServiciosiPad *servicios;
    CategoriasiPad *categorias;
    ListatiposiPad *tipos;
    ListalocalesiPad *locales;
    MapaiPad *detailViewController;
    Anunciantes *anun;
    Search *buscar;
    
    UIBarButtonItem *hidebutton;
    
    BOOL hidemaster;
    BOOL searching;
}
@property (strong, nonatomic) IBOutlet UIButton *botoninfo;
- (IBAction)abririnfogeneral:(id)sender;

@property (nonatomic, strong) UINavigationController *masternavigator;
@property (nonatomic, strong) UINavigationController *detailnavigator;

@property (nonatomic, strong) IBOutlet UIView *master;
@property (nonatomic, strong) IBOutlet UIView *detail;
@property (strong, nonatomic) IBOutlet UIView *separador;
@property (nonatomic, strong) IBOutlet UIView *anuncios;

@property (nonatomic, retain) Idioma *auxidioma;
@property (nonatomic, retain) Restaurante *restaurante;

@property (nonatomic, retain) NSString *titserv;
@property (nonatomic, retain) NSString *titcat;
@property (nonatomic, retain) NSString *tittip;

@end
