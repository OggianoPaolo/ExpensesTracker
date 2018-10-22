//
//  NuovaSpesaController.h
//  Esempio
//
//  Created by Paul on 17/08/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagerDB.h"

@protocol NuovaSpesaControllerDelegate

-(void)tabellaSpeseFinish;

@end

@interface NuovaSpesaController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *calendView;
@property (weak, nonatomic) IBOutlet UITextField  *totaleView;
@property (weak, nonatomic) IBOutlet UIPickerView *valutaView;
@property (weak, nonatomic) IBOutlet UITextField  *notaView;
@property (weak, nonatomic) IBOutlet UILabel      *categLabel;

@property (strong, nonatomic) NSString* selCategorySecond;

@property (nonatomic, strong) id<NuovaSpesaControllerDelegate> delegate;
@property (nonatomic, strong) ManagerDB *dbManager;
@property (nonatomic, strong) NSArray *arrayCategorie;





@end
