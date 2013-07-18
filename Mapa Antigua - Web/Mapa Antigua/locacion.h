//
//  locacion.h
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface locacion : NSObject
@property(nonatomic)int idlocacion;
@property(nonatomic)int idlocal;
@property(nonatomic)int coordx;
@property(nonatomic)int coordy;
@property(nonatomic,retain)NSString *nombrelocal;
@property(nonatomic,retain)NSString *logo;
@end
