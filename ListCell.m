//
//  ListCell.m
//  MyFirstApp
//
//  Created by danping yan on 1/30/18.
//  Copyright © 2018 danping yan. All rights reserved.
//

#import "ListCell.h"

@interface ListCell()

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *weekLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation ListCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 47, 46)];
    self.dateLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.3];
    self.dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40];
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.dateLabel];
    
    self.weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 23, 36, 15)];
    self.weekLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.3];
    self.weekLabel.font = [UIFont systemFontOfSize:12];
    self.weekLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.weekLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 38, 60, 15)];
    self.timeLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.3];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.timeLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-240)/2, 79, 240, 42)];
    self.contentLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.contentLabel];
    
    return self;
    
}

+ (ListCell *)searchCellForTableView: (UITableView *)tableView {
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Note"];
    
    if(cell == nil) {
        
        cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Note"];
        
    }
    
    return cell;
    
}

- (void) setContentInList: (NSDictionary *)dictionary {
    
    self.dateLabel.text = [dictionary objectForKey:@"day"];
    self.weekLabel.text = [dictionary objectForKey:@"dayOfWeek"];
    self.timeLabel.text = [dictionary objectForKey:@"yearAndMonth"];
    self.contentLabel.text = [dictionary objectForKey:@"content"];
}








@end
