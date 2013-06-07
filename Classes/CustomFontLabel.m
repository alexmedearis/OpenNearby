//
//  CustomFontLabel.m
//  SimpleFontWrapper
//
//  Created by Alex Medearis on 6/7/13.
//  Copyright (c) 2013 Alex Medearis. All rights reserved.
//

#import "CustomFontLabel.h"

@implementation CustomFontLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


-(void)layoutSubviews{
    [self setFont:[UIFont fontWithName:@"LifeSavers-Regular" size:self.font.pointSize]];
    [super layoutSubviews];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
