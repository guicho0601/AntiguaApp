//
//  Listaservicios.m
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Listaservicios.h"
#import "Restaurante.h"
#import "CategoriasiPhone.h"
#import "Search.h"

@implementation Listaservicios
@synthesize servicioArray,selectidioma,auxlogo;
@synthesize colores,detail,delegate;

-(void)cargarservicio{
    if(servicioArray != nil)
    {
        [servicioArray removeAllObjects];
    } else {
        servicioArray = [[NSMutableArray alloc]init];
    }
    
    NSMutableArray *adat;
    NSError *error;
    NSData *data;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directorio = [path objectAtIndex:0];
    NSString *file;
    file = [directorio stringByAppendingFormat:@"/servicio.txt"];
    data = [NSData dataWithContentsOfFile:file];
    adat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    
    Servicio *auxservicio = [[Servicio alloc]init];
    auxservicio.servicioesp = @"Mostrar todos";
    auxservicio.servicioing = @"Show all";
    [servicioArray addObject:auxservicio];
    for (int i=0; i<adat.count; i++){
        NSDictionary *info = [adat objectAtIndex:i];
        Servicio *auxservicio = [[Servicio alloc]init];
        auxservicio.idservicio = [[info objectForKey:@"idservicio"]intValue];
        auxservicio.servicioesp = [info objectForKey:@"nomesp"];
        auxservicio.servicioing = [info objectForKey:@"noming"];
        auxservicio.icono = [info objectForKey:@"icono"];
        [servicioArray addObject:auxservicio];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)establecertitulo{
    if (selectidioma.idioma == 0) {
        self.title=@"Services";
    }else{
        self.title=@"Servicios";
    }
}

-(void)cambiaridioma:(Idioma *)idioma{
    selectidioma = idioma;
    [self establecertitulo];
    [self cargarservicio];
    [self.tableView reloadData];
}

-(void)abrirbusqueda:(UIBarButtonItem *)sender{
    Search *buscar = [[Search alloc]initWithNibName:nil bundle:nil];
    [buscar setDetail:detail];
    [buscar setSelectidioma:selectidioma];
    [buscar setDelegate:self];
    [self.delegate avisosearchservicio:buscar];
    [self.navigationController pushViewController:buscar animated:YES];
}

-(void)configuraciones{
    [self establecertitulo];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.separatorColor = [UIColor colorWithRed:0xB3/160 green:0xb3/160 blue:0xb3/160 alpha:1];
    [self.view setBackgroundColor:colortablaiphone];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem.backBarButtonItem setImage:[UIImage imageNamed:flechaizquierda]];
    
    UIBarButtonItem *boton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:busquedaicono] style:UIBarButtonItemStylePlain target:self action:@selector(abrirbusqueda:)];
    self.navigationItem.rightBarButtonItem = boton; 
    
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
    //[self.detail setAuxservicio:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self configuraciones];
}

- (void)viewDidUnload
{
    tableView = nil;
    [super viewDidUnload];
}

-(Boolean)conexion{
    Boolean test=false;
    NSString *url = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] encoding:NSStringEncodingConversionExternalRepresentation error:nil];
    if (url != NULL) test=true;
    return test;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self cargarservicio];
    [tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation = UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [servicioArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Servicio *auxservicio = [servicioArray objectAtIndex:indexPath.row];
    if (selectidioma.idioma == 1) {
        cell.textLabel.text = [auxservicio servicioesp];
    }else{
        cell.textLabel.text = [auxservicio servicioing];
    }
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    //imgView.image = [UIImage imageNamed:@"I_COMIDA60x60.gif"];
    NSString *nombreicono = [auxservicio icono];
    imgView.image = [UIImage imageNamed:nombreicono];
    cell.imageView.image = imgView.image;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setTextColor:colortextoceldaiphone];
    [cell setBackgroundColor:[UIColor blackColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [cell.textLabel setFont:fuente];
    return cell;
}


#pragma mark - Table view delegate

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [detail setSelecciontodo:@"Todo"];
        [detail cargarlocaciones];
        [self.delegate seleccioncerrarmenu];
    }else{
        Restaurante *restaurante=[[Restaurante alloc]init];
        auxlogo = [[imagenlogo alloc]init];
        if (indexPath.row == 2) {
            restaurante.comida=1;
        }else{
            restaurante.comida=0;
        }
        int turismo=0;
        if (indexPath.row == 1) turismo=1;
        [self.detail setTurismo:turismo];
        CategoriasiPhone *categoriasiphone = [[CategoriasiPhone alloc]initWithNibName:nil bundle:nil];
        Servicio *auxservicio = [servicioArray objectAtIndex:indexPath.row];
        auxlogo.icono = auxservicio.icono;
        if (selectidioma.idioma == 0) [self.detail setTitserv:[NSString stringWithFormat:@"%@", auxservicio.servicioing]];
        else [self.detail setTitserv:[NSString stringWithFormat:@"%@", auxservicio.servicioesp]];
        [self.detail setTitcat:@""];
        [self.detail setTittip:@""];
        [self.detail establecertitulo];
        [categoriasiphone setAuxlogo:auxlogo];
        [categoriasiphone setAuxservicio:auxservicio];
        [categoriasiphone setAuxrestaurante:restaurante];
        [categoriasiphone setSelectidioma:selectidioma];
        [categoriasiphone setAuxdetail:self.detail]; 
        [categoriasiphone setColores:colores];
        [categoriasiphone setDelegate:self];
        [self.delegate setCategorias:categoriasiphone];
        [self.navigationController pushViewController:categoriasiphone animated:YES];
    
        //[self performSegueWithIdentifier:@"Servicios" sender:selectidioma];
    }
}

-(void) seleccioncerrarmenu{
    [self.delegate seleccioncerrarmenu];
}

-(void)setLocalescat:(ListalocalesiPhone *)loc{
    [self.delegate setLocalser:loc];
}

-(void)setTipos:(ListatiposiPhone *)tip{
    [self.delegate setTiposser:tip];
}

-(void)cerrarmenudesdebusqueda{
    [self.delegate seleccioncerrarmenu];
}

-(void)avisosearchcategoria:(Search *)aux{
    [self.delegate avisosearchservicio:aux];
}

-(void)avisocierrebusqueda{
    [self.delegate avisosearchservicio:nil];
}

@end
