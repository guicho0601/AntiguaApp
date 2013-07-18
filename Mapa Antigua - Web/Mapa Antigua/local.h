//
//  local.h
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface local : NSObject
@property(nonatomic)int idlocal;
@property(nonatomic,retain) NSString *nombre;
@property(nonatomic,retain) NSString *descripcionesp;
@property(nonatomic,retain) NSString *descripcioning;
@property(nonatomic,retain) NSString *paginaweb;
@property(nonatomic) int idservicio;
@property(nonatomic) int idcategoria;
@property(nonatomic,retain) NSString *imagen;
@property(nonatomic,retain) NSString *logo;
@property(nonatomic,retain) NSString *imagening;
@property(nonatomic) int tipo;
@property(nonatomic) int posx;
@property(nonatomic) int posy;
@property(nonatomic) int turismo;
@property(nonatomic) int anuncio;
@end
