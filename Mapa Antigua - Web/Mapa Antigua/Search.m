//
//  Search.m
//  Aqui en Antigua
//
//  Created by Luis Angel Ramos Gomez on 15/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Search.h"

@implementation Search{
    NSArray *searchResults;
    NSMutableArray *nombres;
}
@synthesize tableView;
@synthesize detail,busquedaArray,selectidioma,ipaddetail,delegate;

-(void)cargarbusqueda{
    int abc=1;
    if(busquedaArray != nil)
    {
        [busquedaArray removeAllObjects];
    } else {
        busquedaArray = [[NSMutableArray alloc]init];
    }
    
     //    BUSQUEDA LOCALES
    
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
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        NSString *number = [NSString stringWithFormat:@"%d",abc];
        [temp addObject:number];
        [temp addObject:aux];
        [busquedaArray addObject:temp];
        temp = nil;
        
    }
    abc++;
    
    //        BUSQUEDA SERVICIOS
    
    
   
    file = [directorio stringByAppendingFormat:@"/servicio.txt"];
    data = [NSData dataWithContentsOfFile:file];
    adat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    for (int i=0; i<adat.count; i++){
        NSDictionary *info = [adat objectAtIndex:i];
        Servicio *auxservicio = [[Servicio alloc]init];
        auxservicio.idservicio = [[info objectForKey:@"idservicio"]intValue];
        auxservicio.servicioesp = [info objectForKey:@"nomesp"];
        auxservicio.servicioing = [info objectForKey:@"noming"];
        auxservicio.icono = [info objectForKey:@"icono"];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        NSString *number = [NSString stringWithFormat:@"%d",abc];
        [temp addObject:number];
        [temp addObject:auxservicio];
        [busquedaArray addObject:temp];
        temp = nil;
    }
    abc++;
    
    //        BUSQUEDA CATEGORIA
    
    file = [directorio stringByAppendingFormat:@"/categoria.txt"];
    data = [NSData dataWithContentsOfFile:file];
    adat = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    for (int i=0; i<adat.count; i++){
        NSDictionary *info = [adat objectAtIndex:i];
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
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        NSString *number = [NSString stringWithFormat:@"%d",abc];
        [temp addObject:number];
        [temp addObject:aux];
        [busquedaArray addObject:temp];
        temp = nil;
    
    }
    abc++;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
        self.title=@"Search";
    }else{
        self.title=@"Buscar";
    }
}

-(void)regresomapa:(UIBarButtonItem *)sender{
    [self.delegate avisocierrebusqueda];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configuraciones{
    [self establecertitulo];
    nombres = [[NSMutableArray alloc]init];
    UIBarButtonItem *botonatras = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:flechaizquierda] style:UIBarButtonItemStylePlain target:self action:@selector(regresomapa:)];
    self.navigationItem.leftBarButtonItem = botonatras;
}

-(void)cambiodeidioma:(Idioma*)aux{
    [self establecertitulo];
    [tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self configuraciones];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self cargarbusqueda];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchResults = [nombres filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView2 numberOfRowsInSection:(NSInteger)section
{
    if (tableView2 == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [busquedaArray count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView2 == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    } else {
        NSString *titulo;
        //NSString *icono;
        BOOL ingles;
        if (selectidioma.idioma == 0) {
            ingles = TRUE;
        }else{
            ingles = FALSE;
        }
        
        NSMutableArray *temp = [busquedaArray objectAtIndex:indexPath.row];
        if ([[temp objectAtIndex:0] isEqualToString:@"1"]) {
            local *aux = [temp objectAtIndex:1];
            titulo = aux.nombre;
        //    icono = aux.logo;
        }else if ([[temp objectAtIndex:0] isEqualToString:@"2"]){
            Servicio *aux = [temp objectAtIndex:1];
            if (ingles) titulo = aux.servicioing;
            else titulo = aux.servicioesp;
        //    icono = aux.icono;
        }else if ([[temp objectAtIndex:0] isEqualToString:@"3"]){
            Categoria *aux = [temp objectAtIndex:1];
            if (ingles) titulo = aux.categoriaing;
            else titulo = aux.categoriaesp;
         //   icono = aux.icono;
        }else if ([[temp objectAtIndex:0] isEqualToString:@"4"]){
            Tipo *aux = [temp objectAtIndex:1];
            if (ingles) titulo = aux.tipoing;
            else titulo = aux.tipoesp;
        //    icono = aux.icono;
        }
        /**if (icono == nil) {
            icono = @"logo_inicio_72x72.png";
        }
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:icono];
        imgView.backgroundColor = [UIColor blackColor];
        cell.imageView.image = imgView.image;*/
        cell.textLabel.text = titulo;
        [nombres addObject:titulo];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int number = 0;
    BOOL iph;
    if ([self.searchDisplayController isActive]) {
        NSString *sel = [searchResults objectAtIndex:indexPath.row];
        for (int i=0; i<[nombres count]; i++) {
            if ([[nombres objectAtIndex:i] isEqualToString:sel]) {
                number = i;
                break;
            }
        }
    } else {
        number = indexPath.row;
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        iph = FALSE;
    }else{
        iph = TRUE;
    }
    
    NSMutableArray *temp = [busquedaArray objectAtIndex:number];
    if ([[temp objectAtIndex:0] isEqualToString:@"1"]) {
        local *aux = [temp objectAtIndex:1];
        if (!iph) {
            [self.ipaddetail setAuxlocal:aux];
            [self.ipaddetail setSelecciontodo:@"Local"];
            [self.ipaddetail setBusqueda:true];
            [self.ipaddetail cargarlocaciones];
        }else{
            [self.detail setAuxlocal:aux];
            [self.detail setSelecciontodo:@"Local"];
            [self.detail setBusqueda:true];
            [self.detail cargarlocaciones];
        }
    }else if([[temp objectAtIndex:0] isEqualToString:@"2"]){
        Servicio *aux = [temp objectAtIndex:1];
        if (!iph) {
            [self.ipaddetail setAuxservicio:aux];
            [self.ipaddetail setSelecciontodo:@"Categoria"];
            [self.ipaddetail setBusqueda:true];
            [self.ipaddetail cargarlocaciones];
        }else{
            [self.detail setAuxservicio:aux];
            [self.detail setSelecciontodo:@"Categoria"];
            [self.detail setBusqueda:true];
            [self.detail cargarlocaciones];
        }
    }else if([[temp objectAtIndex:0] isEqualToString:@"3"]){
        Categoria *aux = [temp objectAtIndex:1];
        if (!iph) {
            [self.ipaddetail setAuxcategoria:aux];
            [self.ipaddetail setSelecciontodo:@"Tipo/Categoria"];
            [self.ipaddetail setBusqueda:true];
            [self.ipaddetail cargarlocaciones];
        }else{
            [self.detail setAuxcategoria:aux];
            [self.detail setSelecciontodo:@"Tipo/Categoria"];
            [self.detail setBusqueda:true];
            [self.detail cargarlocaciones];
        }
    }else if([[temp objectAtIndex:0] isEqualToString:@"4"]){
        Tipo *aux = [temp objectAtIndex:1];
        if (!iph) {
            [self.ipaddetail setAuxtipo:aux];
            [self.ipaddetail setSelecciontodo:@"Tipo"];
            [self.ipaddetail setBusqueda:true];
            [self.ipaddetail cargarlocaciones];
        }else{
            [self.detail setAuxtipo:aux];
            [self.detail setSelecciontodo:@"Tipo"];
            [self.detail setBusqueda:true];
            [self.detail cargarlocaciones];
        }
    }
    if (iph) {
        [self.delegate cerrarmenudesdebusqueda];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.searchDisplayController.searchBar resignFirstResponder];
    }
}

@end
