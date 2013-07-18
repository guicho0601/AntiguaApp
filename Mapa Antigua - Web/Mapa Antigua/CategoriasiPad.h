//
//  CategoriasiPad.h
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
#import "imagenlogo.h"
#import "MapaiPad.h"
#import "ListatiposiPad.h"
#import "ListalocalesiPad.h"
#import "Search.h"

@protocol Categoriasdelegate <NSObject>
@optional
-(void)avisosearchcategorias:(Search *)aux;
@end

@interface CategoriasiPad : UITableViewController<Localesdelegate,Tiposdelegate,Searchdelegate>{

    IBOutlet UITableView *tableView;
    AppDelegate *appDelegate;
    Search *buscar;
    
    __weak id<Categoriasdelegate> delegate;
}

@property (strong, nonatomic) MapaiPad *detailViewController;

@property(nonatomic,retain) UIColor *colores;

@property(nonatomic, retain) Servicio *auxservicio;
@property(nonatomic, retain) Categoria *auxcategoria;
@property(nonatomic, retain) Restaurante *auxrestaurante;

@property (nonatomic, retain) NSMutableArray *categoriasArray;
@property (nonatomic,strong) Idioma *selectidioma;
@property (nonatomic,retain) imagenlogo *auxlogo;

@property (weak, nonatomic) id<Categoriasdelegate> delegate;

-(void)cargarcategorias;
-(void)cambiaridioma:(Idioma *)idioma;


@end
