//
//  Listaservicios.h
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Idioma.h"
#import "Servicio.h"
#import "AppDelegate.h"
#import "imagenlogo.h"
#import "MapaeniPhone.h"
#import "CategoriasiPhone.h"
#import "ListatiposiPhone.h"
#import "ListalocalesiPhone.h"
#import "Search.h"

@class Listaservicios;
@protocol ListaserviciosDelegate <NSObject>
@optional
-(void) seleccioncerrarmenu;
-(void) setCategorias:(CategoriasiPhone *)cat;
-(void) setTiposser:(ListatiposiPhone *)tip;
-(void) setLocalser:(ListalocalesiPhone *)loc;
-(void) setAreasser:(NSString *)cad;
-(void) avisosearchservicio:(Search*)aux;
@end

@interface Listaservicios : UITableViewController<CategoriasiPhonedelegate,Searchdelegate>{
    // Declaramos la tabla y el delegate de la aplicación
    IBOutlet UITableView *tableView;
    AppDelegate *appDelegate;
    __weak id<ListaserviciosDelegate> delegate;
}

// Creamos una propiedad retain para el array que almacenará los tutoriales y con el que poblaremos la tabla.
@property (nonatomic, retain) NSMutableArray *servicioArray;
@property (nonatomic,strong) Idioma *selectidioma;
@property (nonatomic,retain) imagenlogo *auxlogo;
@property (nonatomic,strong) MapaeniPhone *detail;

@property (nonatomic, retain) UIColor *colores;

@property(weak,nonatomic) id<ListaserviciosDelegate> delegate;

// Añadimos un método para la carga de nuestra base de datos.
- (void)cargarservicio;
-(void)cambiaridioma:(Idioma *)idioma;

@end
