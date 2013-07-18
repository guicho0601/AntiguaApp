//
//  ListalocalesiPhone.h
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
#import "MapaeniPhone.h"
#import "imagenlogo.h"
#import "Search.h"

@class ListalocalesiPhone;

@protocol ListalocalesiPhonedelegate <NSObject>
@optional
-(void) seleccioncerrarmenulocales;
-(void) avisosearchlocal:(Search*)aux;
@end

@interface ListalocalesiPhone : UITableViewController<Searchdelegate>{
    AppDelegate *appDelegate;
    IBOutlet UITableView *tableView;
    
    __weak id<ListalocalesiPhonedelegate> delegate;
}

@property(nonatomic,retain) UIColor *colores;

@property(nonatomic,retain) local *auxlocal;
@property(nonatomic,retain) Categoria *auxcategoria;
@property(nonatomic,retain) Tipo *auxtipo;
@property(nonatomic,retain) Restaurante *auxrestaurante;
@property(nonatomic,retain) Idioma *selectidioma;
@property(nonatomic,retain) clasificacion *auxclasificacion;
@property(nonatomic,retain) locacion *auxlocacion;
@property(nonatomic,strong) MapaeniPhone *auxdetail;
@property(nonatomic,retain) imagenlogo *auxlogo;

@property (nonatomic, retain) NSMutableArray *localesArray;

@property(weak,nonatomic) id<ListalocalesiPhonedelegate> delegate;


-(void)cargarlocales;
-(void)cambiaridioma:(Idioma *)idioma;

@end
