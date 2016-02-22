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
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, self.radius / 4, 0);
        CGPathAddLineToPoint(pathToDraw, NULL, self.radius, -(self.radius / 2));
        
        CGPathMoveToPoint(pathToDraw, NULL, self.radius, -(self.radius / 2));
        CGPathAddLineToPoint(pathToDraw, NULL, (3 * self.radius / 2), 0);
        
        CGPathMoveToPoint(pathToDraw, NULL, (3 * self.radius / 2), 0);
        CGPathAddLineToPoint(pathToDraw, NULL, 2 * self.radius, -(self.radius / 2));
        
        CGPathMoveToPoint(pathToDraw,  NULL, 2 * self.radius, -(self.radius / 2));
        CGPathAddLineToPoint(pathToDraw, NULL, (7 * self.radius / 4), -(self.radius));
        
        CGPathMoveToPoint(pathToDraw,  NULL, (7 * self.radius / 4), -(self.radius));
        CGPathAddLineToPoint(pathToDraw, NULL, 2 * self.radius, -(5 * self.radius / 4));
        
        CGPathMoveToPoint(pathToDraw,  NULL, 2 * self.radius, -(5 * self.radius / 4));
        CGPathAddLineToPoint(pathToDraw, NULL, (4 * self.radius/ 3), -(2 * self.radius));
        
        CGPathMoveToPoint(pathToDraw,  NULL, (4 * self.radius/ 3), -(2 * self.radius));
        CGPathAddLineToPoint(pathToDraw, NULL, self.radius / 4, -(2 * self.radius));
        
        CGPathMoveToPoint(pathToDraw,  NULL, self.radius / 4, -(2 * self.radius));
        CGPathAddLineToPoint(pathToDraw, NULL, 0, -(5 * self.radius / 4));
        
        CGPathMoveToPoint(pathToDraw,  NULL,  0, -(5 * self.radius / 4));
        CGPathAddLineToPoint(pathToDraw, NULL, 0, -(self.radius / 4));
        
        CGPathMoveToPoint(pathToDraw,  NULL,   0, -(self.radius / 4));
        CGPathAddLineToPoint(pathToDraw, NULL, self.radius / 4, 0);
        
        //CGMutablePathRef circlePath = CGPathCreateMutable();
        //CGPathAddEllipseInRect(circlePath , NULL , CGRectMake(-self.radius, -self.radius, 2 * self.radius, 2 * self.radius) );
        
        self.path = pathToDraw;
        
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
