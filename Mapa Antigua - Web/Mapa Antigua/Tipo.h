//
//  Tipo.h
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tipo : NSObject
@property(nonatomic) int idtipo;
@property(nonatomic,retain) NSString *tipoesp;
@property(nonatomic,retain) NSString *tipoing;
@property(nonatomic) int idcategoria;
@property(nonatomic,retain) NSString *icono;
@end
