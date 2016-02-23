//
//  LifeIcon.m
//  Astroids
//
//  Created by Thomas Donohue on 2/22/16.
//
//

#import "LifeIcon.h"

@implementation LifeIcon

-(id) initIconWithSize: (CGFloat) iconSize
{
    if((self = [super init])) {
        //----------------------------SIZE---------------------------------
        self.size = CGSizeMake(iconSize, iconSize);
        
        //----------------------------STROKE---------------------------------
        self.strokeColor = [SKColor whiteColor];
        self.lineWidth = 1;
        
        //----------------------------PATH---------------------------------
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, -(self.size.width/2), 0 - (self.size.height));
        CGPathAddLineToPoint(pathToDraw, NULL, 0.0f, (self.size.height/2));
        CGPathAddLineToPoint(pathToDraw, NULL, (self.size.width/2), -(self.size.height));
        CGPathMoveToPoint(pathToDraw, NULL, -(self.size.width/2)+1, -(3 * self.size.height/4));
        CGPathAddLineToPoint(pathToDraw, NULL, (self.size.width/2)-1, -(3 * self.size.height/4));
        self.path = pathToDraw;
        
    }
    return self;
    
}

@end
