//
//  Spaceship.m
//  Astroids
//
//  Created by Thomas Donohue on 2/17/16.
//
//

#import "Spaceship.h"
#import "CategoryBitMasks.h"

@implementation Spaceship

-(id) initShipWithSize: (CGFloat) shipSize
{
    if((self = [super init]))
    {
        // SIZE
        self.size = CGSizeMake(shipSize, shipSize);
        
        // STROKE
        self.strokeColor = [SKColor whiteColor];
        self.lineWidth = 3;
        
        // PATH
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, -(self.size.width/2), 0 - (self.size.height));
        CGPathAddLineToPoint(pathToDraw, NULL, 0.0f, (self.size.height/2));
        CGPathAddLineToPoint(pathToDraw, NULL, (self.size.width/2), -(self.size.height));
        CGPathMoveToPoint(pathToDraw, NULL, -(self.size.width/2)+1, -(3 * self.size.height/4));
        CGPathAddLineToPoint(pathToDraw, NULL, (self.size.width/2)-1, -(3 * self.size.height/4));
        self.path = pathToDraw;
        
        // PHYSICS
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: self.size.width / 2];
        self.physicsBody.usesPreciseCollisionDetection = YES;
        // wrap around screen
        self.physicsBody.categoryBitMask = shipCategory | wrapCategory;
        // collide with asteroid
        self.physicsBody.contactTestBitMask = asteroidCategory;
        // bounce off nothing
        self.physicsBody.collisionBitMask = 0;
        
        
    }
    return self;
    
}

@end
