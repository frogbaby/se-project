//
//  INotesStorageManager.h
//  MyFirstApp
//
//  Created by danping yan on 1/31/18.
//  Copyright © 2018 danping yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INotesStorageManager : NSObject

+ (id) getNote;
+ (BOOL) storeNote:(NSArray *) note;
+ (BOOL) storeDictionary:(NSDictionary *)dictionary;

@end
