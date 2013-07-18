//
//  Descargar_imagenes.m
//  Antigua Wow!
//
//  Created by Rh_M on 5/07/13.
//
//

#import "Descargar_imagenes.h"


@implementation Descargar_imagenes{
    NSMutableArray *images;
    int cont;
}

-(void)obtenerURL{
    images = [[NSMutableArray alloc]init];
    NSMutableArray *adat;
    NSError *error;
    NSData *data;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directorio = [path objectAtIndex:0];
    NSString *file;
    file = [directorio stringByAppendingFormat:@"/lugar.txt"];
    data = [NSData dataWithContentsOfFile:file];
    adat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    for (int i=0; i<adat.count; i++){
        NSDictionary *info = [adat objectAtIndex:i];
        [images addObject:[info objectForKey:@"imgesp"]];
    }
    
    file = [directorio stringByAppendingFormat:@"/img_lugar.txt"];
    data = [NSData dataWithContentsOfFile:file];
    adat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    for (int i=0; i<adat.count; i++) {
        NSDictionary *info = [adat objectAtIndex:i];
        [images addObject:[info objectForKey:@"imagen"]];
    }
}

-(void)descargar{
    [self obtenerURL];
    for (int i = 0; i<[images count]; i++) {
        NSString *s = [images objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:s];
        NSString *nombrearchivo = url.lastPathComponent;

        NSArray *array = [s  componentsSeparatedByString:@"/"];
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *carpeta = [docDir stringByAppendingFormat:@"/%@",[array objectAtIndex:(array.count -2)]];
        
        NSString *fotointerna = [NSString stringWithFormat:@"%@/%@",carpeta,nombrearchivo];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:carpeta]) {
            [fm createDirectoryAtPath:carpeta withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        if (![fm fileExistsAtPath:fotointerna]) {
            NSData *data3= [NSData dataWithContentsOfURL:[NSURL URLWithString:s]];
            [data3 writeToFile:fotointerna atomically:YES];
            cont++;
        }
    }
    NSLog(@"Se descargaron %d imagenes",cont);
}

-(void)iniciar_descarga{
    cont = 0;
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(descargar)
                                                                              object:nil];
    
    [queue addOperation:operation];
}

@end
