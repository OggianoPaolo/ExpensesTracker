//
//  ManagerDB.h
//  Esempio
//
//  Created by Paul on 20/08/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spesa.h"
#import "Categoria.h"

@interface ManagerDB : NSObject

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename; 

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

-(void)copyDatabaseIntoDocumentsDirectory;

// =========================================   CORREZIONE ========================== ////

//== Metodi per aggiungere una spesa / una categoria ==//

- (void) aggiungiSpesa:(Spesa *) templateSpesa;

- (void) aggiungiCategoria:(Categoria *) templateCategoria;

//== Metodi per caricare le spese in base alla categoria scelta / per le categorie ==//

- (NSMutableArray <Spesa *> *)  caricaSpese:(NSString*) categSelezionata;

- (NSMutableArray <Categoria*> *) caricaCategorie;

//== Metodi per cancellare una categoria / una spesa ==//

- (void) cancellaCategoria:(NSNumber*) idCategoria;

- (void) cancellaSpesa:(NSNumber*) idSpesa;

@end
