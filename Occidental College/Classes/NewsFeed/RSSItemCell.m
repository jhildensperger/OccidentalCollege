//
//  RSSItemCell.m
//  Occidental
//
//  Created by James Hildensperger on 7/24/13.
//  Copyright (c) 2013 JusCollege. All rights reserved.
//

#import "RSSItemCell.h"

@implementation RSSItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18.0];
        [self addSubview:self.titleLabel];
        
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 10)];
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.textColor = [UIColor lightGrayColor];
        self.subtitleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.subtitleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 60)];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.textColor = [UIColor lightGrayColor];
        self.detailLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
