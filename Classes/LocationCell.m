//
//  LocationCell.m
//  StillOpen
//
//  Created by Andy Dufresne on 2/9/13.
//
//

#import "LocationCell.h"

@implementation LocationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake( 10, 10, 25, 25 ); // your positioning here
    
    CGRect oldFrame = self.textLabel.frame;
    self.textLabel.frame = CGRectMake( oldFrame.origin.x, oldFrame.origin.y + 3, oldFrame.size.width, oldFrame.size.height);
    
    oldFrame = self.detailTextLabel.frame;
    self.detailTextLabel.frame =  CGRectMake( oldFrame.origin.x, oldFrame.origin.y - 3, oldFrame.size.width, oldFrame.size.height);

}
@end
