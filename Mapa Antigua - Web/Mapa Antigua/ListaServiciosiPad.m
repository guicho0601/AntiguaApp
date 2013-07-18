//
//  ListaServiciosiPad.m
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListaServiciosiPad.h"
#import "Restaurante.h"

@implementation ListaServiciosiPad
@synthesize servicioArray;
@synthesize selectidioma;
@synthesize detailViewController=_detailViewController;
@synthesize colores;
@synthesize auxlogo,delegate;

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

-(void)abrirbusqueda:(UIBarButtonItem *)sender{
    buscar = [[Search alloc]initWithNibName:nil bundle:nil];
    [buscar setIpaddetail:self.detailViewController];
    [buscar setSelectidioma:selectidioma];
    [buscar setDelegate:self];
    [self.delegate avisosearchservicio:buscar];
    [self.navigationController pushViewController:buscar animated:YES];
}


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self establecertitulo];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view setBackgroundColor:colortablaipad];
    
    UIBarButtonItem *boton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:busquedaicono] style:UIBarButtonItemStylePlain target:self action:@selector(abrirbusqueda:)];
    self.navigationItem.rightBarButtonItem = boton;
}

- (void)viewDidUnload
{
    tableView = nil;
    [super viewDidUnload];
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
    // Return YES for supported orientations
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [servicioArray count];
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
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    //imgView.image = [UIImage imageNamed:@"I_COMIDA60x60.gif"];
    NSString *nombreicono = [auxservicio icono];
    imgView.image = [UIImage imageNamed:nombreicono];
    cell.imageView.image = imgView.image;
    [cell.textLabel setTextColor:colortextoceldaipad];
    return cell;
}


#pragma mark - Table view delegate

-(UIColor *)establecercolor:(int)fila{
    UIColor *col;
    switch (fila) {
        case 0:
            col=[UIColor orangeColor];
            break;
        case 1:
            col=[UIColor blueColor];
            break;
        default:
            break;
    }
    return col;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.detailViewController setSelecciontodo:@"Todo"];
        [self.detailViewController cargarlocaciones];
    }else{
        Restaurante *restaurante=[[Restaurante alloc]init];
        auxlogo = [[imagenlogo alloc]init];
        int turismo = 0;
        if (indexPath.row == 2) {
            restaurante.comida=1;
        }else{
            restaurante.comida=0;
        }
        if (indexPath.row == 1) turismo = 1;
        [self.detailViewController setTurismo:turismo];
        colores=[self establecercolor:indexPath.row];
        CategoriasiPad *categoriaipad = [[CategoriasiPad alloc]initWithNibName:nil bundle:nil];
        Servicio *auxservicio = [servicioArray objectAtIndex:indexPath.row];
        auxlogo.icono = auxservicio.icono;
        [categoriaipad setAuxlogo:auxlogo];
        [categoriaipad setAuxservicio:auxservicio];
        [self.detailViewController setTitcat:@""];
        [self.detailViewController setTittip:@""];
        if (selectidioma.idioma == 0) {
            [self.detailViewController setTitserv:auxservicio.servicioing];
        }else{
            [self.detailViewController setTitserv:auxservicio.servicioesp];
        }
        [self.detailViewController establecertitulo];
        [categoriaipad setAuxrestaurante:restaurante];
        [categoriaipad setSelectidioma:selectidioma];
        [categoriaipad setDelegate:self];
        [categoriaipad setDetailViewController:self.detailViewController];
        [self.navigationController pushViewController:categoriaipad animated:YES];
    }
}

-(void)avisosearchcategorias:(Search *)aux{
    [self.delegate avisosearchservicio:aux];
}

-(void)avisocierrebusqueda{
    [self.delegate avisosearchservicio:nil];
}

@end
