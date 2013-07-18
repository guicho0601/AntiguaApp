//
//  ListatiposiPad.h
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
#import "imagenlogo.h"
#import "MapaiPad.h"
#import "ListalocalesiPad.h"
#import "Search.h"

@protocol Tiposdelegate <NSObject>
@optional
-(void)avisosearchtipos:(Search *)aux;
@end

@interface ListatiposiPad : UITableViewController<Localesdelegate,Searchdelegate>{
    AppDelegate *appDelegate;
    IBOutlet UITableView *tableView;
    Search *buscar;
    
    __weak id<Tiposdelegate> delegate;
}

@property (strong, nonatomic) MapaiPad *detailViewController;

@property(nonatomic,retain) UIColor *colores;

@property(nonatomic, retain) Categoria *auxcategoria;
@property(nonatomic, retain) Tipo *auxtipo;
@property(nonatomic, retain) Restaurante *restaurante;

@property (nonatomic, retain) NSMutableArray *tiposArray;
@property (nonatomic,strong) Idioma *selectidioma;
@property (nonatomic,retain) imagenlogo *auxlogo;

@property (weak, nonatomic) id<Tiposdelegate> delegate;

-(void)cargartipos;
-(void)cambiaridioma:(Idioma *)idioma;


@end
