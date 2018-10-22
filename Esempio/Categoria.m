//
//  Categoria.m
//  Experidie
//
//  Created by Paul on 03/09/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import "Categoria.h"

@implementation Categoria

- (id) initWithName:(NSString*) name idCategoria:(NSNumber*)idCategoria categoria:(NSString*) categoria{
    if(self = [super init]){
        _name = [name copy];
        _idCategoria = idCategoria;
        _categoria   = categoria;
    }
    return self;
}

@end
