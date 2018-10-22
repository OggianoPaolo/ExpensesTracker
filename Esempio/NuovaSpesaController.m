//
//  NuovaSpesaController.m
//  Esempio
//
//  Created by Paul on 17/08/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NuovaSpesaController.h"

@interface NuovaSpesaController () {
     NSArray  *currencies;
     NSString *valutascelta;
}
@end

@implementation NuovaSpesaController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.categLabel.text = self.selCategorySecond;
    self.totaleView.delegate = self;
    self.valutaView.delegate = self;
    self.valutaView.dataSource = self;
    self.notaView.delegate = self;
    
    [self.calendView setMaximumDate: [NSDate date]]; // data massima: data corrente
    
    // inizializzo il DB
    self.dbManager = [[ManagerDB alloc] initWithDatabaseFilename:@"exptrackDB.sql"];
    
    // Sistemo le valute nel picker
    currencies = @[@"Euro €", @"US Dollar $", @"Pound £"];
}


// ====== Numero di componenti da mettere nel picker ======= //

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// ====== Numero di valori da mettere nel picker (le valute) ==== //

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [currencies count];
}

// ====== Mostra il valore in ogni riga ===== //

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return currencies[row];
}

// ====== Riga selezionata (SELECTED - PICKER VIEW) ==== //

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    valutascelta = currencies[row];
}

// ====== Salva spesa (INSERT) ===== //

- (IBAction)salvaSpesaButton:(id)sender {
    
    Spesa * templateSpesa;
    templateSpesa = [[Spesa alloc] initWithName:@"Spesa"
                                        idSpesa:NULL
                                           data:[self.calendView date]
                                         totale:(NSDecimalNumber*)self.totaleView.text
                                         valuta:valutascelta
                                           nota:self.notaView.text
                                      categoria:self.categLabel.text];
    
    [self.dbManager aggiungiSpesa:templateSpesa];
    
    [self.delegate tabellaSpeseFinish];
        
        // Pop della view
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