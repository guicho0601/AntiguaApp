//
//  Search.h
//  Aqui en Antigua
//
//  Created by Luis Angel Ramos Gomez on 15/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Idioma.h"
#import "Servicio.h"
#import "Categoria.h"
#import "Tipo.h"
#import "local.h"
#import "MapaeniPhone.h"
#import "MapaiPad.h"

@protocol Searchdelegate <NSObject>
@optional
-(void)cerrarmenudesdebusqueda;
-(void)avisocierrebusqueda;
@end

@interface Search : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>{
    AppDelegate *appDelegate;
    __weak id<Searchdelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) MapaeniPhone *detail;
@property (nonatomic,strong) MapaiPad *ipaddetail;
@property (nonatomic, retain) Idioma *selectidioma;
@property (nonatomic, retain) NSMutableArray *busquedaArray;

@property(weak,nonatomic) id<Searchdelegate> delegate;

-(void)cargarbusqueda;
-(void)cambiodeidioma:(Idioma*)aux;

@end
