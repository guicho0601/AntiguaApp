//
//  ListatiposiPad.m
//  Mapa Antigua
//
//  Created by Luis Angel Ramos Gomez on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListatiposiPad.h"

@implementation ListatiposiPad
@synthesize auxtipo,auxcategoria,selectidioma,tiposArray,restaurante,colores,auxlogo,delegate;
@synthesize detailViewController=_detailViewController;

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

-(void)regreso{
    [self.detailViewController setTittip:@""];
    [self.detailViewController establecertitulo];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)abrirbusqueda:(UIBarButtonItem *)sender{
    buscar = [[Search alloc]initWithNibName:nil bundle:nil];
    [buscar setIpaddetail:self.detailViewController];
    [buscar setSelectidioma:selectidioma];
    [buscar setDelegate:self];
    [self.delegate avisosearchtipos:buscar];
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

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Tipo *auxitipo = [tiposArray objectAtIndex:indexPath.row];
    if (selectidioma.idioma == 1) {
        cell.textLabel.text = [auxitipo tipoesp];
    }else{
        cell.textLabel.text = [auxitipo tipoing];
    }
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
    [cell.textLabel setTextColor:colortextoceldaipad];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.detailViewController setAuxlogo:auxlogo];
        [self.detailViewController setAuxcategoria:auxcategoria];
        [self.detailViewController setSelecciontodo:@"Tipo/Categoria"];
        [self.detailViewController cargarlocaciones];
    }else{
        ListalocalesiPad *listalocales = [[ListalocalesiPad alloc]initWithNibName:nil bundle:nil];
        Tipo *auxtipos = [tiposArray objectAtIndex:indexPath.row];
        //[listalocales setAuxcategoria:auxcategorias];
        [listalocales setAuxlogo:auxlogo];
        [listalocales setAuxtipo:auxtipos];
        if (selectidioma.idioma == 0) {
            [self.detailViewController setTittip:[NSString stringWithFormat:@"/%@",auxtipos.tipoing]];
        }else{
            [self.detailViewController setTittip:[NSString stringWithFormat:@"/%@",auxtipos.tipoesp]];
        }
        [self.detailViewController establecertitulo];
        [listalocales setSelectidioma:selectidioma];
        [listalocales setAuxrestaurante:restaurante];
        [listalocales setDetailViewController:self.detailViewController];
        [listalocales setDelegate:self];
        [self.navigationController pushViewController:listalocales animated:YES];
    }
}

-(void)avisosearchlocal:(Search *)aux{
    [self.delegate avisosearchtipos:aux];
}

-(void)avisocierrebusqueda{
    [self.delegate avisosearchtipos:nil];
}

@end
