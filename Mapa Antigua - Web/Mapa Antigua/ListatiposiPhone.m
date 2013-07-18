//
//  ListatiposiPhone.m
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListatiposiPhone.h"
#import "ListalocalesiPhone.h"

@implementation ListatiposiPhone
@synthesize auxtipo,auxcategoria,selectidioma,tiposArray,restaurante,colores,auxdetail,auxlogo,delegate;

-(void)cargartipos{
    if(tiposArray != nil)
    {
        [tiposArray removeAllObjects];
    } else {
        tiposArray = [[NSMutableArray alloc]init];
    }
    Tipo *aux = [[Tipo alloc]init];
    aux.tipoesp = @"Mostrar todos";
    aux.tipoing = @"Show all";
    [tiposArray addObject:aux];
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    if(sqlite3_open([appDelegate.databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *sqlStatement = [NSString stringWithFormat:@"select tipo.idtipo,tipo.tipoesp,tipo.tipoing,tipo.idcategoria,tipo.icono from categoria,tipo where tipo.idcategoria=categoria.idcategoria and categoria.idcategoria = %d",auxcategoria.idcategoria];
        
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                NSString *idtipo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                NSString *tipoesp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *tipoing = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                NSString *idcategoria = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                NSString *icono;
                if (sqlite3_column_type(compiledStatement, 4)!=SQLITE_NULL) {
                    icono = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                }
                
                Tipo *auxitipo = [[Tipo alloc]init];
                auxitipo.idtipo = [idtipo intValue];
                auxitipo.tipoesp = tipoesp;
                auxitipo.tipoing = tipoing;
                auxitipo.idcategoria = [idcategoria intValue];
                auxitipo.icono = icono;
                [tiposArray addObject:auxitipo];
            }
        } else {
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
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
        self.title=auxcategoria.categoriaing;
    }else{
        self.title=auxcategoria.categoriaesp;
    }
}

-(void)cambiaridioma:(Idioma *)idioma{
    selectidioma = idioma;
    [self establecertitulo];
    [self cargartipos];
    [self.tableView reloadData];
}

-(void)regresarhome:(id*)sender{
    int back = 2; //Default to go back 2 
    int count = [self.navigationController.viewControllers count];
    
    //if(data[@"count"]) back = [data[@"count"] intValue];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count-(back+1)] animated:YES];
}

-(void)botonhome{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(regresarhome:)];
}

-(void)regreso{
    [self.auxdetail setTittip:@""];
    [self.auxdetail establecertitulo];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)abrirbusqueda:(UIBarButtonItem *)sender{
    Search *buscar = [[Search alloc]initWithNibName:nil bundle:nil];
    [buscar setDetail:auxdetail];
    [buscar setSelectidioma:selectidioma];
    [buscar setDelegate:self];
    [self.delegate avisosearchtipo:buscar];
    [self.navigationController pushViewController:buscar animated:YES];
}

#pragma mark - View lifecycle

-(void)configuraciones{
    [self establecertitulo];
    [self botonhome];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view setBackgroundColor:colores];
    [self.tableView setBackgroundColor:colortablaiphone];
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *boton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:flechaizquierda] style:UIBarButtonItemStylePlain target:self action:@selector(regreso)];
    self.navigationItem.leftBarButtonItem = boton;
    
    UIBarButtonItem *boton2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:busquedaicono] style:UIBarButtonItemStylePlain target:self action:@selector(abrirbusqueda:)];
    self.navigationItem.rightBarButtonItem = boton2;
    
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
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
    [self cargartipos];
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
    return [tiposArray count];
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
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    Tipo *auxitipo = [tiposArray objectAtIndex:indexPath.row];
    if (selectidioma.idioma == 1) {
        cell.textLabel.text = [auxitipo tipoesp];
    }else{
        cell.textLabel.text = [auxitipo tipoing];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    if (auxitipo.icono == nil) {
        imgView.image = [UIImage imageNamed:auxlogo.icono];
    }else{
        imgView.image = [UIImage imageNamed:auxitipo.icono];
    }
    if (indexPath.row == 0) {
        imgView.image = nil;
    }
    cell.imageView.image = imgView.image;
    [cell.textLabel setTextColor:colortextoceldaiphone];
    [cell.textLabel setFont:fuente];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [auxdetail setAuxlogo:auxlogo];
        [auxdetail setAuxcategoria:auxcategoria];
        [auxdetail setSelecciontodo:@"Tipo/Categoria"];
        [auxdetail cargarlocaciones];
        [self.delegate seleccioncerrarmenutipos];
    }else{
        ListalocalesiPhone *listalocales = [[ListalocalesiPhone alloc]initWithNibName:nil bundle:nil];
        Tipo *auxtipos = [tiposArray objectAtIndex:indexPath.row];
        if (selectidioma.idioma == 0) [self.auxdetail setTittip:[NSString stringWithFormat:@"/%@", auxtipos.tipoing]];
        else [self.auxdetail setTittip:[NSString stringWithFormat:@"/%@", auxtipos.tipoesp]];
        [self.auxdetail establecertitulo];
        //[listalocales setAuxcategoria:auxcategorias];
        [listalocales setAuxlogo:auxlogo];
        [listalocales setAuxtipo:auxtipos];
        [listalocales setSelectidioma:selectidioma];
        [listalocales setAuxrestaurante:restaurante];
        [listalocales setColores:colores];
        [listalocales setAuxdetail:self.auxdetail];
        [listalocales setDelegate:self];
        //[self.delegate setLocales:listalocales];
        [self.navigationController pushViewController:listalocales animated:YES];
    }

}

-(void) seleccioncerrarmenulocales{
    [self.delegate seleccioncerrarmenutipos];
}

-(void)cerrarmenudesdebusqueda{
    [self.delegate seleccioncerrarmenutipos];
}

-(void)avisosearchlocal:(Search *)aux{
    [self.delegate avisosearchtipo:aux];
}

-(void)avisocierrebusqueda{
    [self.delegate avisosearchtipo:nil];
}

@end
