//
//  CategoriasiPad.m
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriasiPad.h"

@implementation CategoriasiPad
@synthesize auxservicio,auxcategoria,auxrestaurante,categoriasArray,selectidioma,colores,auxlogo,delegate;
@synthesize detailViewController=_detailViewController;

-(void)cargarcategorias{
    if(categoriasArray != nil)
    {
        [categoriasArray removeAllObjects];
    } else {
        categoriasArray = [[NSMutableArray alloc]init];
    }
    Categoria *aux = [[Categoria alloc]init];
    aux.categoriaesp = @"Mostrar todos";
    aux.categoriaing = @"Show all";
    [categoriasArray addObject:aux];
    NSMutableArray *adat;
    NSError *error;
    NSData *data;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directorio = [path objectAtIndex:0];
    NSString *file;
    file = [directorio stringByAppendingFormat:@"/categoria.txt"];
    data = [NSData dataWithContentsOfFile:file];
    
    adat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    for (int i=0; i<adat.count; i++){
        NSDictionary *info = [adat objectAtIndex:i];
        if ([[info objectForKey:@"servicio"]intValue] == auxservicio.idservicio ) {
            Categoria *aux = [[Categoria alloc]init];
            aux.idcategoria = [[info objectForKey:@"idcategoria"]intValue];
            aux.categoriaesp = [info objectForKey:@"nomesp"];
            aux.categoriaing = [info objectForKey:@"noming"];
            aux.icono = [info objectForKey:@"icono"];
            NSString *is = [aux.icono isEqual:[NSNull null]]?nil:aux.icono;
            if (is ==nil){
                aux.icono = nil;
            }
            aux.idservicio = [[info objectForKey:@"servicio"]intValue];
            [categoriasArray addObject:aux];
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
        self.title=auxservicio.servicioing;
    }else{
        self.title=auxservicio.servicioesp;
    }
}

-(void)cambiaridioma:(Idioma *)idioma{
    selectidioma = idioma;
    [self establecertitulo];
    [self.tableView reloadData];
}

-(void)regreso{
    [self.detailViewController setTitcat:@""];
    [self.detailViewController establecertitulo];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)abrirbusqueda:(UIBarButtonItem *)sender{
    buscar = [[Search alloc]initWithNibName:nil bundle:nil];
    [buscar setIpaddetail:self.detailViewController];
    [buscar setSelectidioma:selectidioma];
    [self.delegate avisosearchcategorias:buscar];
    [buscar setDelegate:self];
    [self.navigationController pushViewController:buscar animated:YES];
}

#pragma mark - View lifecycle

-(void)configuraciones{
    @autoreleasepool {
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

- (void)viewWillAppear:(BOOL)animated
{
    [self cargarcategorias];
    [tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.detailViewController.masterPopoverController setPopoverContentSize:self.view.frame.size animated:YES];
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
    return [categoriasArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Categoria *auxicategoria = [categoriasArray objectAtIndex:indexPath.row];
    if (selectidioma.idioma == 1) {
        cell.textLabel.text = [auxicategoria categoriaesp];
    }else{
        cell.textLabel.text = [auxicategoria categoriaing];
    }
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    if (auxicategoria.icono == nil) {
        imgView.image = [UIImage imageNamed:auxlogo.icono];
    }else{
        imgView.image = [UIImage imageNamed:auxicategoria.icono];
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
    if (indexPath.row == 0) {
        [self.detailViewController setAuxlogo:auxlogo];
        [self.detailViewController setAuxservicio:auxservicio];
        [self.detailViewController setSelecciontodo:@"Categoria"];
        [self.detailViewController cargarlocaciones];
    }else{
        if (auxrestaurante.comida == 1) {
            ListatiposiPad *listatipos=[[ListatiposiPad alloc]initWithNibName:nil bundle:nil];
            Categoria *auxcategorias = [categoriasArray objectAtIndex:indexPath.row];
            auxlogo.icono = auxcategorias.icono;
            [listatipos setAuxlogo:auxlogo];
            [listatipos setAuxcategoria:auxcategorias];
            [self.detailViewController setTittip:@""];
            if (selectidioma.idioma == 0){
                [self.detailViewController setTitcat:[NSString stringWithFormat:@"/%@",auxcategorias.categoriaing]];
            }else{
                [self.detailViewController setTitcat:[NSString stringWithFormat:@"/%@",auxcategorias.categoriaesp]];
            }
            [self.detailViewController establecertitulo];
            [listatipos setSelectidioma:selectidioma];
            [listatipos setRestaurante:auxrestaurante];
            [listatipos setDetailViewController:self.detailViewController];
            [listatipos setDelegate:self];
            [self.navigationController pushViewController:listatipos animated:YES];
        }else{
            ListalocalesiPad *listalocales = [[ListalocalesiPad alloc]initWithNibName:nil bundle:nil];
            Categoria *auxcategorias = [categoriasArray objectAtIndex:indexPath.row];
            if (auxcategorias.icono != nil) auxlogo.icono = auxcategorias.icono;
            [listalocales setAuxlogo:auxlogo];
            [listalocales setAuxcategoria:auxcategorias];
            [self.detailViewController setTittip:@""];
            if (selectidioma.idioma == 0){
                [self.detailViewController setTitcat:[NSString stringWithFormat:@"/%@",auxcategorias.categoriaing]];
            }else{
                [self.detailViewController setTitcat:[NSString stringWithFormat:@"/%@",auxcategorias.categoriaesp]];
            }
            [self.detailViewController establecertitulo];
            [listalocales setSelectidioma:selectidioma];
            [listalocales setAuxrestaurante:auxrestaurante];
            [listalocales setDetailViewController:self.detailViewController];
            [listalocales setDelegate:self];
            [self.navigationController pushViewController:listalocales animated:YES];
        }
    }
}

-(void)avisosearchlocal:(Search *)aux{
    [self.delegate avisosearchcategorias:aux];
}

-(void)avisosearchtipos:(Search *)aux{
    [self.delegate avisosearchcategorias:aux];
}

-(void)avisocierrebusqueda{
    [self.delegate avisosearchcategorias:nil];
}

@end
