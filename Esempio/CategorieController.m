//
//  CategorieController.m
//  Esempio
//
//  Created by Paul on 18/08/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import "CategorieController.h"
#import "ListaSpeseController.h"
#import "ManagerDB.h"

@implementation CategorieController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabellaCategorieView.delegate   = self;
    self.tabellaCategorieView.dataSource = self;
    
    self.dbManager = [[ManagerDB alloc] initWithDatabaseFilename:@"exptrackDB.sql"];
    self.categorie = [[NSMutableArray alloc] init];
    
    self.categorie = [self.dbManager caricaCategorie];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
}

// ======== Numero di sezioni nella tabella =========== //

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// ======== Numero di righe nella sezione ============ //

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.categorie count];
}

// ======== Definisco l'altezza per ciascuna riga === //

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43.0;
}

// ======== Definisco com'è fatta ciascuna riga della tabella ===== //

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleCategory" forIndexPath:indexPath];
    
    Categoria* temporary = [[Categoria alloc] init];
    
    temporary = [self.categorie objectAtIndex:indexPath.row];
    
    cell.textLabel.text = temporary.categoria;
    cell.textLabel.textColor = [UIColor purpleColor];
    cell.textLabel.font = [UIFont fontWithName:@"Farah" size:20];
    
    return cell;
}


// ======== Riga selezionata (SELECTED) ======== //

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *selectedCell=[tableView cellForRowAtIndexPath:indexPath];

    // Prendo il nome della categoria e lo mantengo
    self.selectedCategory = selectedCell.textLabel.text;
    
    [self performSegueWithIdentifier:@"versoListaSpese" sender:self];
    
}

// ======== Riga cancellata (DELETE) ========= //

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        Categoria* categ = [[Categoria alloc] init];
        
        categ = [self.categorie objectAtIndex:indexPath.row];
        
        NSNumber* idCategoriaEliminare = categ.idCategoria;
        
        [self.dbManager cancellaCategoria:idCategoriaEliminare];
        
        [self.categorie removeObjectAtIndex:indexPath.row];
        [self.tabellaCategorieView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
        
}

// ========= Dati da passare alla view successiva ======= //

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"versoListaSpese"]){
        ListaSpeseController* controllerSpese = (ListaSpeseController *)segue.destinationViewController;
        controllerSpese.categoriaSelezionata = self.selectedCategory;
    }
    
    else if ([segue.identifier isEqualToString:@"versoAggiungiCategoria"]){
        NuovaCategoriaController *controllerCategorie = (NuovaCategoriaController *)segue.destinationViewController;
        controllerCategorie.delegate = self;
    }
    
}

// ====== Unwind segue ======= //
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

-(void)viewWillAppear:(BOOL)animated { [super viewWillAppear:animated]; NSIndexPath *indexPath = [self.tabellaCategorieView indexPathForSelectedRow]; [self.tabellaCategorieView reloadData]; if(indexPath) { [self.tabellaCategorieView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone]; } } -(void)viewDidAppear:(BOOL)animated { [super viewDidAppear:animated]; NSIndexPath *indexPath = [self.tabellaCategorieView indexPathForSelectedRow]; if(indexPath) { [self.tabellaCategorieView deselectRowAtIndexPath:indexPath animated:YES]; } }

// ====== Metodo per ricaricare la tabella Categorie (tramite protocollo in NuovaCateg.h ) ==== //

-(void)tabellaCategorieFinish{

    self.categorie = [[NSMutableArray alloc] init];
    self.categorie = [self.dbManager caricaCategorie];
}


// ===

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
