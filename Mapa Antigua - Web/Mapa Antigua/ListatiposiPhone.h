//
//  ListatiposiPhone.h
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Categoria.h"
#import "Tipo.h"
#import "Idioma.h"
#import "Restaurante.h"
#import "MapaeniPhone.h"
#import "imagenlogo.h"
#import "ListalocalesiPhone.h"
#import "Search.h"

@class ListatiposiPhone;
@protocol Listatiposdelegate <NSObject>
@optional
-(void) seleccioncerrarmenutipos;
-(void) setLocales:(ListalocalesiPhone *)loc;
-(void) avisosearchtipo:(Search*)aux;
@end

@interface ListatiposiPhone : UITableViewController<ListalocalesiPhonedelegate,Searchdelegate>{
    AppDelegate *appDelegate;
    IBOutlet UITableView *tableView;
    
    __weak id<Listatiposdelegate> delegate;
}

@property(nonatomic,retain) UIColor *colores;

@property(nonatomic, retain) Categoria *auxcategoria;
@property(nonatomic, retain) Tipo *auxtipo;
@property(nonatomic, retain) Restaurante *restaurante;
@property(nonatomic, retain) MapaeniPhone *auxdetail;

@property (nonatomic, retain) NSMutableArray *tiposArray;
@property (nonatomic,strong) Idioma *selectidioma;
@property (nonatomic, retain) imagenlogo *auxlogo;

@property(weak,nonatomic) id<Listatiposdelegate> delegate;


-(void)cargartipos;
-(void)cambiaridioma:(Idioma *)idioma;

@end
