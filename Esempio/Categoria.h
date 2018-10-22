//
//  Categoria.h
//  Experidie
//
//  Created by Paul on 03/09/18.
//  Copyright © 2018 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categoria : NSObject

@property (nonatomic, strong) NSNumber* idCategoria;
@property (nonatomic, strong) NSString* categoria;

@property (nonatomic, strong) NSString* name;
- (id) initWithName:(NSString*)name idCategoria:(NSNumber*)idCategoria categoria:(NSString*) categoria;

@end
