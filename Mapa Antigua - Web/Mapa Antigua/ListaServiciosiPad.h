//
//  ListaServiciosiPad.h
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
#import "MapaiPad.h"
#import "CategoriasiPad.h"
#import "Search.h"

@protocol Serviciosdelegate <NSObject>
@optional
-(void)avisosearchservicio:(Search*)aux;
@end

@interface ListaServiciosiPad : UITableViewController<Categoriasdelegate,Searchdelegate>{

    IBOutlet UITableView *tableView;
    AppDelegate *appDelegate;
    Search *buscar;
    
    __weak id<Serviciosdelegate> delegate;
}

@property (strong, nonatomic) MapaiPad *detailViewController;

@property (nonatomic, retain) UIColor *colores;

@property (nonatomic, retain) NSMutableArray *servicioArray;
@property (nonatomic,strong) Idioma *selectidioma;
@property (nonatomic,retain) imagenlogo *auxlogo;

@property (weak, nonatomic) id<Serviciosdelegate> delegate;

- (void)cargarservicio;
-(void)cambiaridioma:(Idioma *)idioma;

@end
