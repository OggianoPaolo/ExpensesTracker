//
//  NuovaCategoriaController.m
//  Esempio
//
//  Created by Paul on 17/08/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NuovaCategoriaController.h"

@implementation NuovaCategoriaController

- (void) viewDidLoad{
    [super viewDidLoad];
    
    self.nuovaCategoriaTxtView.delegate = self;
    
    self.dbManager = [[ManagerDB alloc] initWithDatabaseFilename:@"exptrackDB.sql"];
}

//================ Salva categoria ========= //

- (IBAction)salvaButton:(id)sender{
    
    NSString* nomecateg = self.nuovaCategoriaTxtView.text;
    
    Categoria* templateCategoria;
    
    templateCategoria = [[Categoria alloc] initWithName:@"Categoria" idCategoria:NULL categoria:nomecateg];
    
    [self.dbManager aggiungiCategoria:templateCategoria];
    
    // Il delegato viene informato che è finito l'inserimento
    [self.delegate tabellaCategorieFinish];
        
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end