//
//  ListaSpeseController.m
//  Esempio
//
//  Created by Paul on 17/08/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListaSpeseController.h"
#import "NuovaSpesaController.h"
#import "SingolaSpesaController.h"

@implementation ListaSpeseController

- (void) viewDidLoad{
    [super viewDidLoad];
    
    self.tabellaSpeseView.delegate   = self;
    self.tabellaSpeseView.dataSource = self;
    
    self.dbManager = [[ManagerDB alloc] initWithDatabaseFilename:@"exptrackDB.sql"];
    self.arraySpese = [[NSMutableArray alloc] init];
    
    
    self.title = [NSString stringWithFormat:@"%@%@", @"Spese ", self.categoriaSelezionata];
    
    
    self.arraySpese = [self.dbManager caricaSpese:self.categoriaSelezionata];
    [self.tabellaSpeseView reloadData];
}

// ===== Numero di sezioni nella table ========= //
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// ===== Numero di righe nella sezione della table view ===== //
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arraySpese count];
}

// ===== Altezza per ciascuna riga nella table view ====== //
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

// ===== Riga selezionata (SELECTED) ========== //
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SingolaSpesa";
    
    SingolaSpesaController *cell = (SingolaSpesaController *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SingolaSpesa" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Spesa* temporary = [[Spesa alloc ] init];
    temporary = [self.arraySpese objectAtIndex:indexPath.row];
    
    NSString *str = (NSString*) temporary.data; //da tipo nsdate
    NSRange range = [str rangeOfString:@" "];
    NSString *dataformattata = [str substringToIndex:range.location];
    
    
    
    cell.dataLabel.text   = dataformattata;
    cell.totaleLabel.text = (NSString*)temporary.totale;
    cell.valutaLabel.text = temporary.valuta;
    cell.notaLabel.text   = temporary.nota;
    [cell.notaLabel sizeToFit];
    
    return cell;
}

// ============ Riga cancellata (DELETE) ======== //
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Spesa* spesa = [[Spesa alloc] init];
        
        spesa = [self.arraySpese objectAtIndex:indexPath.row];
        
        NSNumber* idSpesaElim = spesa.idSpesa;
        
        [self.dbManager cancellaSpesa:idSpesaElim];
        
        [self.arraySpese removeObjectAtIndex:indexPath.row];
        [self.tabellaSpeseView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

// ========= Dati da passare alla View successiva ======= //
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"versoAggiungiSpesa"]){
        NuovaSpesaController* controller = (NuovaSpesaController *)segue.destinationViewController;
        
        controller.selCategorySecond = self.categoriaSelezionata; // qua mantengo il nome della categoria da passare
        controller.delegate = self;
    }
}

// ======= Metodo che carica la tabella (anche in questo caso sfruttando il protocollo) ====== //
-(void)tabellaSpeseFinish{
    self.arraySpese = [[NSMutableArray alloc] init];
    self.arraySpese = [self.dbManager caricaSpese:self.categoriaSelezionata];
    [self.tabellaSpeseView reloadData];
}

// ======= Unwind segue ====== //
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

/*
NSString* stringaPercorso;

// == Ottiene percorso dove salverà il file csv == //
-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    stringaPercorso = [paths objectAtIndex:0];
    
    NSString* nomefilecsv = [NSString stringWithFormat:@"%@%@%@", @"spese", self.categoriaSelezionata, @".csv"];
    
    return [documentsDirectory stringByAppendingPathComponent:nomefilecsv];
    
}
*/
// == Se premo Esporta == //
/*
- (IBAction)esportaSpese:(id)sender {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
        NSLog(@"Percorso ok");
    }
    
    NSMutableString *scriviRiga = [NSMutableString stringWithCapacity:0]; // la capacità si adegua automaticamente
    
    NSArray* templateArray = self.arrayExpenses;
    [scriviRiga appendString:[NSString stringWithFormat:@"\nData    | Importo  | Valuta  | Nota \n\n"]];
    
    
    
    for (int i=0; i<[self.arrayExpenses count]; i++) {
        
        NSString *str = [[templateArray objectAtIndex:i] objectAtIndex:1]; // prende la data di ogni spesa e la formatta
        NSRange range = [str rangeOfString:@" "];
        NSString *dataformattata = [str substringToIndex:range.location];
        
        
        
        [scriviRiga appendString:[NSString stringWithFormat:@"%@, %@, %@, %@\n",
                                   
                                         dataformattata,                     // indice 1 mentre indice 0 era l'id
                                        [[templateArray objectAtIndex:i] objectAtIndex:2],
                                        [[templateArray objectAtIndex:i] objectAtIndex:3],
                                        [[templateArray objectAtIndex:i] objectAtIndex:4]]];
        
        
    }

NSLog(@"\nSpese salvate: %@",scriviRiga);

NSFileHandle *handle;
handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ]; // informa l'handle dov'è il file da scrivere
[handle truncateFileAtOffset:[handle seekToEndOfFile]];                   // posiziona il cursore alla fine del file
[handle writeData:[scriviRiga dataUsingEncoding:NSUTF8StringEncoding]];   // scrivo una volta sola
    
NSLog(@"\n PERCORSO CSV FILE = %@", stringaPercorso);
    
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end