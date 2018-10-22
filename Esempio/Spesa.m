//
//  Spesa.m
//  Experidie
//
//  Created by Paul on 03/09/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import "Spesa.h"

@implementation Spesa

- (id) initWithName:(NSString*) name idSpesa:(NSNumber*)idSpesa data:(NSDate*)data totale:(NSDecimalNumber*)totale valuta:(NSString*)valuta nota:(NSString*)nota categoria:(NSString*)categoria{
    
    if(self = [super init]){
        _name = [name copy];
        _idSpesa  = idSpesa;
        _data     = data;
        _totale   = totale;
        _valuta   = valuta;
        _nota     = nota;
        _categoria= categoria;
    }
    return self;
}



    
    
    



@end

