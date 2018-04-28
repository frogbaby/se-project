//
//  INotesStorageManager.m
//  MyFirstApp
//
//  Created by danping yan on 1/31/18.
//  Copyright © 2018 danping yan. All rights reserved.
//

#import "INotesStorageManager.h"

@implementation INotesStorageManager

+ (id) getNote {
    NSArray *filesDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filesPath = filesDir[0];
    NSString *dataFilePath = [[NSString alloc] initWithString:[filesPath stringByAppendingString:@"note"]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
 
    
    @try {
        BOOL filesExist = [manager fileExistsAtPath:dataFilePath];
        
        if (filesExist) {
            NSArray *note = [NSKeyedUnarchiver unarchiveObjectWithFile:dataFilePath];
            return note;
        } else {
            NSArray *note = [[NSArray alloc]init];
            return note;
        }
        
    }
    @catch (NSException *exception){
        return nil;
        
    }
    @finally {
        
    }
    
}



+ (BOOL) storeNote:(NSArray *) note {
    
    NSArray *filesDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filesPath = filesDir[0];
    NSString *dataFilePath = [[NSString alloc] initWithString:[filesPath stringByAppendingString:@"note"]];
    
    
    
    @try{
        BOOL storageSuccess = [NSKeyedArchiver archiveRootObject:note toFile:dataFilePath];
        return storageSuccess;
        
    }
    @catch (NSException *exception) {
        return NO;
        
    }
    @finally {
        
    }
    
    
}


+ (BOOL) storeDictionary:(NSDictionary *)dictionary {
    
    id noteArray = [INotesStorageManager getNote];
    
    if(noteArray != nil) {
        
        NSMutableArray *newNote = [NSMutableArray arrayWithArray:noteArray];
        
        [newNote addObject:dictionary];
        BOOL storeSuccess = [INotesStorageManager storeNote:newNote];
        return storeSuccess;
        
    }
    
    return NO;
    
    
    
    
    
    
}





@end
