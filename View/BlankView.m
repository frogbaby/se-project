//
//  BlankView.m
//  MyFirstApp
//
//  Created by danping yan on 4/1/18.
//  Copyright © 2018 danping yan. All rights reserved.
//

#import "BlankView.h"

@implementation BlankView

+(BlankView *)buttonContent:(NSString *)buttonContent target:(id)target action:(SEL)action {
    
    BlankView *blankView = [[BlankView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    UIButton *writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *writeContent = buttonContent;
    UIFont *writeButtonSize = [UIFont systemFontOfSize:14];
    writeButton.titleLabel.font = writeButtonSize;
    [writeButton setTitle:writeContent forState:UIControlStateNormal];
    [writeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    writeButton.layer.cornerRadius = 6;
    writeButton.layer.borderWidth = 2;
    writeButton.layer.masksToBounds = YES;
    writeButton.layer.borderColor = [UIColor grayColor].CGColor;
    
    CGSize buttonSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 29);
    NSDictionary *buttonAttributes = [NSDictionary dictionaryWithObjectsAndKeys:writeButton.titleLabel.font,NSFontAttributeName,nil];
    CGRect buttonRect = [writeContent boundingRectWithSize:buttonSize
                                                   options:kNilOptions
                                                attributes:buttonAttributes context:nil];
    
    CGFloat tempWriteButtonWidth = buttonRect.size.width+16;
    [writeButton setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-tempWriteButtonWidth)/2, (blankView.frame.size.height-30)/2+20, tempWriteButtonWidth, 30)];
    
    [writeButton addTarget:target
                    action:action
          forControlEvents:UIControlEventTouchUpInside];
    
    [blankView addSubview:writeButton];
    
    return blankView;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
