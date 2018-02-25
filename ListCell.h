//
//  ListCell.h
//  MyFirstApp
//
//  Created by danping yan on 1/30/18.
//  Copyright © 2018 danping yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell

+ (ListCell *)searchCellForTableView: (UITableView *)tableView;

- (void) setContentInList: (NSDictionary *)dictionary;

@end
