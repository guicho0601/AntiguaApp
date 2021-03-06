//
//  ListalocalesiPad.m
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListalocalesiPad.h"

@implementation ListalocalesiPad
@synthesize auxtipo,auxcategoria,auxlocal,auxrestaurante,selectidioma,
localesArray,auxlocacion,auxclasificacion,colores,auxlogo,delegate;
@synthesize detailViewController=_detailViewController;

-(NSString *)cargardesdecategoria{
    NSString *query = [NSString stringWithFormat:@"select * from local where idcategoria = %d",auxcategoria.idcategoria];
    return query;
}

-(NSString *)cargardesdetipo{
    
    NSString *query = [NSString stringWithFormat:@"select local.idlocal, local.nombre, local.descripcionesp, local.descripcioning, local.paginaweb, local.idservicio, local.idcategoria,local.imagen, local.logo from local,tipo,clasificacion where tipo.idtipo=clasificacion.idtipo and local.idlocal=clasificacion.idlocal and clasificacion.idtipo = %d",auxtipo.idtipo];
    return query;
}

-(void)cargarlocales{
    if(localesArray != nil)
    {
        [localesArray removeAllObjects];
    } else {
        localesArray = [[NSMutableArray alloc]init];
    }
    local *aux = [[local alloc]init];
    if (selectidioma.idioma==1) {
        aux.nombre=@"Mostrar todos";
    }else{
        aux.nombre = @"Show all";
    }
    [localesArray addObject:aux];
    
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
        if ([[info objectForKey:@"categoria"]intValue]==auxcategoria.idcategoria) {
            local *aux = [[local alloc]init];
            aux.idlocal = [[info objectForKey:@"idlugar"]intValue];
            aux.nombre = [info objectForKey:@"nombre"];
            aux.logo = [info objectForKey:@"logo"];
            aux.idcategoria = [[info objectForKey:@"categoria"]intValue];
            NSString *is = [aux.logo isEqual:[NSNull null]]?nil:aux.logo;
            if (is ==nil){
                aux.logo = nil;
            }
            aux.idservicio = [[info objectForKey:@"servicio"]intValue];
            [localesArray addObject:aux];
        }
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
-(void)establecertitulo{
    if (selectidioma.idioma == 0) {
        if (auxrestaurante.comida==1) {
            self.title=auxtipo.tipoing;
        }else{
            self.title=auxcategoria.categoriaing;
        }
    }else{
        if (auxrestaurante.comida == 1) {
            self.title=auxtipo.tipoesp;
        }else{
            self.title=auxcategoria.categoriaesp;
        }
    }
}

-(void)cambiaridioma:(Idioma *)idioma{
    selectidioma = idioma;
    [self establecertitulo];
    [self.tableView reloadData];
}

-(void)regreso{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)abrirbusqueda:(UIBarButtonItem *)sender{
    buscar = [[Search alloc]initWithNibName:nil bundle:nil];
    [buscar setIpaddetail:self.detailViewController];
    [buscar setSelectidioma:selectidioma];
    [buscar setDelegate:self];
    [self.delegate avisosearchlocal:buscar];
    [self.navigationController pushViewController:buscar animated:YES];
}

#pragma mark - View lifecycle

-(void)configuraciones{
    [self establecertitulo];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.view setBackgroundColor:colores];
    [self.view setBackgroundColor:colortablaipad];
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *boton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:flechaizquierda] style:UIBarButtonItemStylePlain target:self action:@selector(regreso)];
    self.navigationItem.leftBarButtonItem = boton;
    
    UIBarButtonItem *boton2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:busquedaicono] style:UIBarButtonItemStylePlain target:self action:@selector(abrirbusqueda:)];
    self.navigationItem.rightBarButtonItem = boton2;
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self cargarlocales];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [localesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    local *auxilocal = [localesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [auxilocal nombre];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    if (auxilocal.logo == nil) {
        imgView.image = [UIImage imageNamed:auxlogo.icono];
    }else{
        imgView.image = [UIImage imageNamed:auxilocal.logo];
    }
    if (indexPath.row == 0) {
        imgView.image = nil;
    }
    cell.imageView.image = imgView.image;
    [cell.textLabel setTextColor:colortextoceldaipad];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.detailViewController setAuxlogo:auxlogo];
    if (indexPath.row==0) {
        if (auxrestaurante.comida == 1) {
            [self.detailViewController setAuxtipo:auxtipo];
            [self.detailViewController setSelecciontodo:@"Tipo"];
            [self.detailViewController cargarlocaciones];
        }else{
            [self.detailViewController setAuxcategoria:auxcategoria];
            [self.detailViewController setSelecciontodo:@"Tipo/Categoria"];
            [self.detailViewController cargarlocaciones];
        }
    }else{
        local *aux = [localesArray objectAtIndex:indexPath.row];
        [self.detailViewController setAuxlocal:aux];
        [self.detailViewController setSelecciontodo:@"Local"];
        [self.detailViewController cargarlocaciones];
    }
}

-(void)avisocierrebusqueda{
    [self.delegate avisosearchlocal:nil];
}

@end
