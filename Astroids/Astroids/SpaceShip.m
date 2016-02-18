//
//  Spaceship.m
//  Astroids
//
//  Created by Thomas Donohue on 2/17/16.
//
//

#import "Spaceship.h"

@implementation Spaceship

-(id) initShip
{
    if((self = [super init]))
    {
        
        self.size = CGSizeMake(20, 20);
        
        self.strokeColor = [SKColor redColor];
        self.lineWidth = 3;
        
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, -(self.size.width/2), 0 - (self.size.height));
        CGPathAddLineToPoint(pathToDraw, NULL, 0.0f, (self.size.height/2));
        CGPathAddLineToPoint(pathToDraw, NULL, (self.size.width/2), -(self.size.height));
        CGPathMoveToPoint(pathToDraw, NULL, -(self.size.width/2)+1, -(3 * self.size.height/4));
        CGPathAddLineToPoint(pathToDraw, NULL, (self.size.width/2)-1, -(3 * self.size.height/4));
        self.path = pathToDraw;
        
        //self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: self.size.width/2];
        //self.physicsBody.usesPreciseCollisionDetection = YES;
        
        //self.physicsBody.collisionBitMask = 0;
        
        
    }
    return self;
    
}

@end
