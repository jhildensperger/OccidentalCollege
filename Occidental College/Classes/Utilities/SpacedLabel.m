//
//  SpacedLabel.m
//  Occidental College
//
//  Created by James Hildensperger on 5/12/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import "SpacedLabel.h"

@implementation SpacedLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawRect:(CGRect)rect 
{
    
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSelectFont (context, [self.font.fontName cStringUsingEncoding:NSASCIIStringEncoding], self.font.pointSize, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(context, 5);
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGAffineTransform myTextTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f );
    CGContextSetTextMatrix (context, myTextTransform);
    
    // draw 1 but invisbly to get the string length.
    CGPoint p =CGContextGetTextPosition(context);
    float centeredY = (self.font.pointSize + (self.frame.size.height- self.font.pointSize)/2)-2;
    CGContextShowTextAtPoint(context, 0, centeredY, [self.text cStringUsingEncoding:NSASCIIStringEncoding], [self.text length]);
    CGPoint v =CGContextGetTextPosition(context);
    
    // calculate width and draw second one.
    float width = v.x - p.x;
    float centeredX =(self.frame.size.width- width)/2;
    CGContextSetFillColorWithColor(context, [self.textColor CGColor]);
    CGContextShowTextAtPoint(context, centeredX, centeredY, [self.text cStringUsingEncoding:NSASCIIStringEncoding], [self.text length]);
    
}
@end
