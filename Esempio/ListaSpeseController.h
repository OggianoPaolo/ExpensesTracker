//
//  ListaSpeseController.h
//  Esempio
//
//  Created by Paul on 17/08/18.
//  Copyright © 2018 Paul. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "NuovaSpesaController.h"
#import "Spesa.h"
#import "ManagerDB.h"

@interface ListaSpeseController : UIViewController <UITableViewDelegate, UITableViewDataSource, NuovaSpesaControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tabellaSpeseView;

@property (strong, nonatomic) NSString *categoriaSelezionata;

@property (nonatomic, strong) NSArray *arrayExpenses;

//@property (nonatomic, strong) NSArray *csvExpenses;

@property (nonatomic, strong) ManagerDB *dbManager;

@property (nonatomic, strong) NSMutableArray <Spesa*>* arraySpese;

@end

