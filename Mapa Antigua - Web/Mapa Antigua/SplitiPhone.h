//
//  SplitiPhone.h
//  Aqui en... Antigua
//
//  Created by Luis Angel Ramos Gomez on 5/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapaeniPhone.h"
#import "Idioma.h"
#import "Listaservicios.h"
#import "CategoriasiPhone.h"
#import "ListatiposiPhone.h"
#import "ListalocalesiPhone.h"
#import "Restaurante.h"
#import "AnunciantesiPhoneVer.h"
#import "AnunciantesiPhoneHor.h"
#import "Search.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface SplitiPhone : UIViewController <UIActionSheetDelegate,ListaserviciosDelegate,Anuncioverdelegate,Anunciohordelegate,MapaiPhonedelegate,CLLocationManagerDelegate>{
    UINavigationController *navigatormaster;
    UINavigationController *navigatormapa;
    UINavigationController *navigatorinfo;
    
    UIView *mapa;
    UIView *menu;
    UIView *separador;
    UIView *anuncios;
    UIView *info;
    
    CGFloat widhtall;
    CGFloat heightall;
    
    MapaeniPhone *mapaiphone;
    
    Listaservicios *servicios;
    CategoriasiPhone *categorias;
    ListatiposiPhone *tipos;
    ListalocalesiPhone *locales;
    AnunciantesiPhoneVer *anun;
    AnunciantesiPhoneHor *anunh;
    Search *buscar;
    
    Idioma *selectidioma;
    CLLocationManager *locationManager;
    
    BOOL showmenu;
    BOOL searching;
}
@property (strong, nonatomic) IBOutlet UIView *menu;
@property (strong, nonatomic) IBOutlet UIView *anuncios;
@property (strong, nonatomic) IBOutlet UIView *separador;
@property (strong, nonatomic) IBOutlet UIView *mapa;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@property (strong, nonatomic) UIImageView *menuimage;
@property (strong, nonatomic) UIImageView *settimage;
@property (strong, nonatomic) UIImageView *brujula;
@property (strong, nonatomic) UILabel *areas;

@property (nonatomic, retain) Restaurante *restaurante;

@end
