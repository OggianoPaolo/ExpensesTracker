//
//  NuovaCategoriaController.h
//  Esempio
//
//  Created by Paul on 17/08/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagerDB.h"

// = Protocollo = //

@protocol NuovaCategoriaControllerDelegate

-(void)tabellaCategorieFinish;

@end

// = Interfaccia = //

@interface NuovaCategoriaController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nuovaCategoriaTxtView;
@property (nonatomic, strong) id<NuovaCategoriaControllerDelegate> delegate;
@property (nonatomic, strong) ManagerDB *dbManager;

- (IBAction)salvaButton:(id)sender;





@end



