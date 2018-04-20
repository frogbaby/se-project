//
//  StorageUtility.h
//  MyFirstApp
//
//  Created by danping yan on 2/12/18.
//  Copyright © 2018 danping yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StorageUtility : NSObject

+(NSNumber *) timestamp;
+(NSMutableDictionary *) nowDate:(NSNumber *)timestamp;

+(CGFloat)screenWidth;
+(CGFloat)screenHeight;








@end
