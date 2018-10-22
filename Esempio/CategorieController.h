//
//  CategorieController.h
//  Esempio
//
//  Created by Paul on 18/08/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NuovaCategoriaController.h"
#import "ManagerDB.h"

@interface CategorieController : UIViewController <UITableViewDelegate, UITableViewDataSource, NuovaCategoriaControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tabellaCategorieView;

@property (nonatomic, strong) ManagerDB *dbManager;

@property (nonatomic, strong) NSMutableArray <Categoria*>* categorie;

@property (strong, nonatomic) NSString* selectedCategory;

@end
