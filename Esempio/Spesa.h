//
//  Spesa.h
//  Experidie
//
//  Created by Paul on 03/09/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Spesa : NSObject

@property (nonatomic, strong) NSNumber* idSpesa;
@property (nonatomic, strong) NSDate* data;
@property (nonatomic, strong) NSDecimalNumber* totale;
@property (nonatomic, strong) NSString* valuta;
@property (nonatomic, strong) NSString* nota;
@property (nonatomic, strong) NSString* categoria;

@property (nonatomic, strong) NSString* name;
- (id) initWithName:(NSString*)name
               idSpesa:(NSNumber*)idSpesa
               data:(NSDate*)data
               totale: (NSDecimalNumber*) totale
               valuta:(NSString*)valuta
               nota:(NSString*)nota
               categoria:(NSString*)categoria;


@end