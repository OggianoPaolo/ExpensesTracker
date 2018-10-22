//
//  ManagerDB.m
//  Esempio
//
//  Created by Paul on 20/08/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import "ManagerDB.h"
#import <sqlite3.h>
#import "Spesa.h"
#import "Categoria.h"

@implementation ManagerDB


// Inizializzo prendendo il file DB
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        // sistemo il percorso di Documents nella property
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0]; // indice ZERO
        
        // Assegna (e mantiene) il nome del file DB
        self.databaseFilename = dbFilename;
        
        // Copia il file del database se necessario nella cartella Documents
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}


// ======== Metodo per la copia del database nella cartella Documents contenuta dentro il dispositivo ====== //

-(void)copyDatabaseIntoDocumentsDirectory{
    // Controlla se il database esiste nella directory
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // Se non esiste, ne fa una copia dal bundle.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Mostra qualche errore, se c'è.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

// ======================////////// NUOVI METODI //////// ============= //

// === Metodo per aggiungere una categoria === //

-(void) aggiungiCategoria:(Categoria *) templateCategoria{
    
    sqlite3 *sqlite3Database;
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK){
    
    NSString* addSQL=[NSString stringWithFormat:@"INSERT INTO categorie VALUES(null, '%@')", templateCategoria.categoria ];
    
    const char* addStmt=[addSQL UTF8String];
    
    char*errMsg=nil;
    
    if(sqlite3_exec(sqlite3Database, addStmt, NULL, NULL, &errMsg)==SQLITE_OK)
    {
        NSLog(@"Nuova categoria inserita");
    }
}

}


// === Metodo per aggiungere una spesa === //

-(void) aggiungiSpesa:(Spesa *) templateSpesa{

    sqlite3 *sqlite3Database;
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK){
        
        NSString* addSQL=[NSString stringWithFormat:@"insert into spese values(null, '%@', '%@', '%@', '%@', '%@')",
        templateSpesa.data,
        templateSpesa.totale,
        templateSpesa.valuta,
        templateSpesa.nota,
        templateSpesa.categoria];

        const char* addStmt=[addSQL UTF8String];
        
        char*errMsg=nil;
        
        if(sqlite3_exec(sqlite3Database, addStmt, NULL, NULL, &errMsg)==SQLITE_OK)
        {
            NSLog(@"Nuova spesa inserita");
        }
    }
}

// === Metodo per eliminare una categoria === //

- (void) cancellaCategoria:(NSNumber*) idCategoria{
    
    sqlite3 *sqlite3Database;
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK){
        
        NSString* deleteSQL=[NSString stringWithFormat:@"DELETE FROM categorie WHERE idCategoria=%@", idCategoria];
        
        const char* deleteStmt=[deleteSQL UTF8String];
        
        char*errMsg=0;
        
        if(sqlite3_exec(sqlite3Database, deleteStmt, NULL, NULL, &errMsg)==SQLITE_OK)
        {
            NSLog(@"Categoria eliminata correttamente");}
            
        else{
            NSLog(@"Errore statement SQL");}
        
        
    }
    else{
        NSLog(@"Errore apertura Database");}
}

// === Metodo per cancellare una spesa === //

- (void) cancellaSpesa:(NSNumber*) idSpesa{
    
    sqlite3 *sqlite3Database;
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK){
        
        NSString* delSQL=[NSString stringWithFormat:@"DELETE FROM spese WHERE idSpesa=%@", idSpesa];
        
        const char* delStmt=[delSQL UTF8String];
        
        char*errMsg=0;
        
        if(sqlite3_exec(sqlite3Database, delStmt, NULL, NULL, &errMsg)==SQLITE_OK)
        {
            NSLog(@"Spesa eliminata correttamente");}
        
        else
        {
            NSLog(@"Errore statement SQL");}
        
     }
     else
     {
        NSLog(@"Errore apertura Database");}
}

// === Metodo per caricare le spese === //

- (NSMutableArray <Spesa *>*)  caricaSpese:(NSString*) categSelezionata{
    
    NSMutableArray <Spesa *>* expensesArray = [[NSMutableArray alloc] init];
    
    sqlite3 *sqlite3Database;
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        
        NSString *usaStringa = categSelezionata;
        
        sqlite3_stmt *compiledStatement;
        
        NSString* queryStmt = [NSString stringWithFormat:@"SELECT * FROM spese WHERE categoria LIKE '%@' ORDER BY data DESC", usaStringa];
        const char *query_stmt = [queryStmt UTF8String];
        
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query_stmt, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK){
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                
                Spesa* templExpense = [[Spesa alloc] init];
                
                NSString* idCategoria= [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 0)];
                NSString* data       = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 1)];
                NSString* totale     = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 2)];
                NSString* valuta     = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 3)];
                NSString* nota       = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 4)];
                NSString* catego     = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 5)];
                
                [templExpense setIdSpesa:(NSNumber*)idCategoria];
                [templExpense setData:(NSDate*) data];
                [templExpense setTotale:(NSDecimalNumber*)totale];
                [templExpense setValuta:valuta];
                [templExpense setNota:nota];
                [templExpense setCategoria:catego];
                
                [expensesArray addObject:templExpense];
            }
            
            sqlite3_finalize(compiledStatement);
        }
        sqlite3_close(sqlite3Database);
    }
    else {
           NSLog(@"Errore per l'apertura del database %s", sqlite3_errmsg(sqlite3Database));
    }
    
    return expensesArray;
}

// === Metodo per caricare le categorie === //

- (NSMutableArray <Categoria *>*)  caricaCategorie{
    
    NSMutableArray <Categoria *>* categoriesArray = [[NSMutableArray alloc] init];
    
    sqlite3 *sqlite3Database;
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        
        sqlite3_stmt *compiledStatement;
        NSString* query = @"SELECT * FROM categorie";
        const char *query_stmt = [query UTF8String];
        
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query_stmt, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK){
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                
                Categoria* templCategory = [[Categoria alloc] init];
                
                NSString* idCategoria= [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 0)];
                NSString* categoria = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 1)];
                
                [templCategory setIdCategoria:(NSNumber*)idCategoria];
                [templCategory setCategoria:categoria];
                [categoriesArray addObject:templCategory];
            }
            sqlite3_finalize(compiledStatement);
        }
        sqlite3_close(sqlite3Database);
    }
    else {
          NSLog(@"Errore per l'apertura del database %s", sqlite3_errmsg(sqlite3Database));
    }
    
    return categoriesArray;
}

// ========= Metodo che prende una query generica e la esegue ======= //
/*
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    
    sqlite3 *sqlite3Database;
    
    // Imposta il percorso del database
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // == Preparo i due array == //
    
    // Se l'array Results contiene dati, verrà svuotato e poi inizializzato
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Stessa cosa per l'array delle colonne
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    // Apertura DB
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        
        // Prepara un oggetto sqlite3_stmt dove mettere i dati una volta compilata la query in un'istruzione SQL
        sqlite3_stmt *compiledStatement;
        
        // Carico i dati
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            
                // un check per vedere se la query è eseguibile
            if (!queryExecutable){
                // quindi vengono caricati i dati dal database
                
                // Un array per i dati
                NSMutableArray *arrayDatiRecord;
                
                
                // Vengono lette tutte le tuple delle tabelle e salvate nell'array
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // inizializza l'array
                    arrayDatiRecord = [[NSMutableArray alloc] init];
                    
                    // Numero totale di colonne
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Legge tutte le colonne e ciascun valore viene assegnato convertendolo in caratteri
                    for (int i=0; i<totalColumns; i++){
                        
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // Controlla se c'è del contenuto nella colonna, quindi lo aggiunge
                        if (dbDataAsChars != NULL) {
                            // Conversione in stringa
                            [arrayDatiRecord addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Mantiene il nome della colonna
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    // Assegna ciascun dato associato alla tupla nell'array dei risultati (controllando se ce ne sono ancora)
                    if (arrayDatiRecord.count > 0) {
                        
                        [self.arrResults addObject:arrayDatiRecord];
                    }
                }
            }
            else {
                
                // Se supero la fase della query eseguibile, eseguo la query e mantengo la tupla
                if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                    
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Mantengo l'ultima tupla inserita
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    
                    NSLog(@"DB Errore: query non eseguibile %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            // Solleva eccezione se non apre il database
            NSLog(@"Errore per l'apertura del database!! %s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Rilascia l'istruzione compilata dalla memoria
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Chiusura DB
    sqlite3_close(sqlite3Database);
}
*/

// ====== Metodo per caricare i dati dal DB (chiamando sempre RUN) ========= //
/*
-(NSArray *)loadDataFromDB:(NSString *)query{
    
    // Esegue la query, indicando se è eseguibile
    // converte la query in char*

    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    return (NSArray *)self.arrResults;
}

// ====== Metodo che esegue la query (chiama il metodo RUN) ===== //

-(void)executeQuery:(NSString *)query{
    // Esegue la query, indicando se è eseguibile
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}
*/
@end
