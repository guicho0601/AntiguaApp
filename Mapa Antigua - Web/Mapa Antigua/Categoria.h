//
//  Categoria.h
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categoria : NSObject
@property(nonatomic) int idcategoria;
@property(nonatomic,retain) NSString *categoriaesp;
@property(nonatomic,retain) NSString *categoriaing;
@property(nonatomic) int idservicio;
@property(nonatomic,retain) NSString *icono;
@end
