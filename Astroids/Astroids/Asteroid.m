//
//  Asteroid.m
//  Astroids
//
//  Created by Thomas Donohue on 2/20/16.
//
//

#import "Asteroid.h"
#import "CategoryBitMasks.h"

@implementation Asteroid

- (id) initWith: (int) type size: (int) sizeVal position: (CGPoint) pos
{
    if((self = [super init]))
    {
        // VARIABLES
        switch(sizeVal){
            case ASTEROID_SMALL:
                self.radius = 10;
                break;
            case ASTEROID_MED:
                self.radius = 25;
                break;
            case ASTEROID_LARGE:
                self.radius = 50;
                break;
        }
        self.type = type;
        self.size = sizeVal;
        self.position = pos;
        
        // STROKE
        self.strokeColor = [SKColor whiteColor];
        self.lineWidth = 3;
        
        // PATH
        CGMutablePathRef circlePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(circlePath , NULL , CGRectMake(-self.radius, -self.radius, self.radius*2, self.radius*2) );
        self.path = circlePath;
        
        // PHYSICS
        //self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath: pathToDraw];
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.radius];
        self.physicsBody.friction = 0.0f; // need this to float
        self.physicsBody.linearDamping = 0.0f;
        self.physicsBody.angularDamping = 0.0f;
        
        
        self.physicsBody.usesPreciseCollisionDetection = YES;
        // wrap around screen
        self.physicsBody.categoryBitMask = asteroidCategory | wrapCategory;
        //collide with bullet
        self.physicsBody.contactTestBitMask = bulletCategory;
        // bounce off nothing
        self.physicsBody.collisionBitMask = 0;
    }
    return self;
}


@end
