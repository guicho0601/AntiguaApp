//
//  ListalocalesiPad.h
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "local.h"
#import "Categoria.h"
#import "Tipo.h"
#import "Restaurante.h"
#import "Idioma.h"
#import "clasificacion.h"
#import "locacion.h"
#import "imagenlogo.h"
#import "MapaiPad.h"
#import "Search.h"

@protocol Localesdelegate <NSObject>
@optional
-(void)avisosearchlocal:(Search *)aux;
@end

@interface ListalocalesiPad : UITableViewController<Searchdelegate>{
    AppDelegate *appDelegate;
    IBOutlet UITableView *tableView;
    Search *buscar;
    
    __weak id<Localesdelegate> delegate;
}

@property (strong, nonatomic) MapaiPad *detailViewController;

@property(nonatomic,retain) UIColor *colores;

@property(nonatomic,retain) local *auxlocal;
@property(nonatomic,retain) Categoria *auxcategoria;
@property(nonatomic,retain) Tipo *auxtipo;
@property(nonatomic,retain) Restaurante *auxrestaurante;
@property(nonatomic,retain) Idioma *selectidioma;
@property(nonatomic,retain) clasificacion *auxclasificacion;
@property(nonatomic,retain) locacion *auxlocacion;
@property(nonatomic,retain) imagenlogo *auxlogo;

@property (weak, nonatomic) id<Localesdelegate> delegate;

@property (nonatomic, retain) NSMutableArray *localesArray;

-(void)cargarlocales;
-(void)cambiaridioma:(Idioma *)idioma;

@end
