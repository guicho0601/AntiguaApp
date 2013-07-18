//
//  CategoriasiPhone.h
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Servicio.h"
#import "Categoria.h"
#import "Restaurante.h"
#import "Idioma.h"
#import "MapaeniPhone.h"
#import "imagenlogo.h"
#import "ListatiposiPhone.h"
#import "ListalocalesiPhone.h"
#import "Search.h"

@class CategoriasiPhone;
@protocol CategoriasiPhonedelegate <NSObject>
@optional
-(void) seleccioncerrarmenu;
-(void) setTipos:(ListatiposiPhone *)tip;
-(void) setLocalescat:(ListalocalesiPhone *)loc;
-(void) avisosearchcategoria:(Search*)aux;
@end

@interface CategoriasiPhone : UITableViewController<Listatiposdelegate,ListalocalesiPhonedelegate,Searchdelegate>{
    
    IBOutlet UITableView *tableView;
    AppDelegate *appDelegate;
    
    __weak id<CategoriasiPhonedelegate> delegate;
}

@property(nonatomic,retain) UIColor *colores;

@property(nonatomic, retain) Servicio *auxservicio;
@property(nonatomic, retain) Categoria *auxcategoria;
@property(nonatomic, retain) Restaurante *auxrestaurante;
@property(nonatomic, retain) MapaeniPhone *auxdetail;

@property (nonatomic, retain) NSMutableArray *categoriasArray;
@property (nonatomic,strong) Idioma *selectidioma;
@property (nonatomic, retain) imagenlogo *auxlogo;

@property(weak,nonatomic) id<CategoriasiPhonedelegate> delegate;


-(void)cargarcategorias;
-(void)cambiaridioma:(Idioma *)idioma;

@end
