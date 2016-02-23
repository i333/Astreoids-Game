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
        //--------------------------------------VARIABLES---------------------------------
        switch(sizeVal){
            case ASTEROID_SMALL:
                self.radius = 15;
                break;
            case ASTEROID_MED:
                self.radius = 30;
                break;
            case ASTEROID_LARGE:
                self.radius = 60;
                break;
        }
        self.type = type;
        self.size = sizeVal;
        self.position = pos;
        
        //-----------------------------------------STROKE------------------------------------------
        self.strokeColor = [SKColor whiteColor];
        self.lineWidth = 2;
        
        //------------------------------------------PATH--------------------------------------------
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        
        if(self.type == TYPE_ONE){
            CGPathMoveToPoint(pathToDraw, NULL, -(3 * self.radius / 4) , (5 * self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL, 0, (2 * self.radius / 3));
            
            CGPathMoveToPoint(pathToDraw, NULL, 0, (2 * self.radius / 3));
            CGPathAddLineToPoint(pathToDraw, NULL, self.radius / 2, (5 * self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL, self.radius / 2, (5 * self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL, (3 * self.radius / 4), (2 * self.radius / 3));
            
            CGPathMoveToPoint(pathToDraw, NULL, (3 * self.radius / 4), (2 * self.radius / 3));
            CGPathAddLineToPoint(pathToDraw, NULL, 2 * self.radius / 3, (self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL, 2 * self.radius / 3, (self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL, (5 * self.radius / 6), (-self.radius / 4));
            
            CGPathMoveToPoint(pathToDraw, NULL, (5 * self.radius / 6), (-self.radius / 4));
            CGPathAddLineToPoint(pathToDraw, NULL, 2 * self.radius / 3, -(3 * self.radius / 4));
            
            CGPathMoveToPoint(pathToDraw, NULL, 2 * self.radius / 3, -(3 * self.radius / 4));
            CGPathAddLineToPoint(pathToDraw, NULL, self.radius / 2, -(5 * self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL, self.radius / 2, -(5 * self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL, -(self.radius / 2), -(5 * self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL, -(self.radius / 2), -(5 * self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL, -(3 * self.radius / 4), -(self.radius / 2));
            
            CGPathMoveToPoint(pathToDraw, NULL, -(3 * self.radius / 4), -(self.radius / 2));
            CGPathAddLineToPoint(pathToDraw, NULL, -self.radius, 0);
            
            CGPathMoveToPoint(pathToDraw, NULL,  -self.radius, 0);
            CGPathAddLineToPoint(pathToDraw, NULL, -(3 * self.radius / 4) , (5 * self.radius / 6));
            
        }else if(self.type == TYPE_TWO){
            CGPathMoveToPoint(pathToDraw, NULL, -self.radius , self.radius / 3);
            CGPathAddLineToPoint(pathToDraw, NULL, -(self.radius / 2), (5 * self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL, -(self.radius / 2), (5 * self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL, (self.radius / 3), (5 * self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL, (self.radius / 3), (5 * self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL, (5 * self.radius / 6), self.radius / 4);
            
            CGPathMoveToPoint(pathToDraw, NULL, (5 * self.radius / 6), self.radius / 4);
            CGPathAddLineToPoint(pathToDraw, NULL, (5 * self.radius / 6), -(self.radius / 4));
            
            CGPathMoveToPoint(pathToDraw, NULL, (5 * self.radius / 6), -(self.radius / 4));
            CGPathAddLineToPoint(pathToDraw, NULL, (self.radius / 3), -(5 * self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL, (self.radius / 3), -(5 * self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL, 0, -(5 * self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL, 0, -(5 * self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL, 0, -(self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL, 0, -(self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL,  -(self.radius / 2), -(3 * self.radius / 4));
            
            CGPathMoveToPoint(pathToDraw, NULL, -(self.radius / 2), -(3 * self.radius / 4));
            CGPathAddLineToPoint(pathToDraw, NULL,  -(self.radius), 0);
            
            CGPathMoveToPoint(pathToDraw, NULL, -(self.radius), 0);
            CGPathAddLineToPoint(pathToDraw, NULL,  -(3 * self.radius / 4), (self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL,  -(3 * self.radius / 4), (self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL,  -self.radius , self.radius / 3);
            
        }else if(self.type == TYPE_THREE){
            CGPathMoveToPoint(pathToDraw, NULL, -self.radius , self.radius / 3);
            CGPathAddLineToPoint(pathToDraw, NULL, -(self.radius / 2), (5 * self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL, -(self.radius / 2), (5 * self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL, (self.radius / 6), (2 * self.radius / 3));
            
            CGPathMoveToPoint(pathToDraw, NULL, (self.radius / 6), (2 * self.radius / 3));
            CGPathAddLineToPoint(pathToDraw, NULL, (self.radius / 2), (5 * self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL, (self.radius / 2), (5 * self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL, (3 * self.radius / 4), (self.radius / 2));
            
            CGPathMoveToPoint(pathToDraw, NULL, (3 * self.radius / 4), (self.radius / 2));
            CGPathAddLineToPoint(pathToDraw, NULL, (self.radius / 2), 0);
            
            CGPathMoveToPoint(pathToDraw, NULL, (self.radius / 2), 0);
            CGPathAddLineToPoint(pathToDraw, NULL, (3 * self.radius / 4), -(self.radius / 2));
            
            CGPathMoveToPoint(pathToDraw, NULL, (3 * self.radius / 4), -(self.radius / 2));
            CGPathAddLineToPoint(pathToDraw, NULL, (self.radius / 6), -(3 * self.radius / 4));
            
            CGPathMoveToPoint(pathToDraw, NULL, (self.radius / 6), -(3 * self.radius / 4));
            CGPathAddLineToPoint(pathToDraw, NULL, -(self.radius / 4), -(self.radius / 2));
            
            CGPathMoveToPoint(pathToDraw, NULL, -(self.radius / 4), -(self.radius / 2));
            CGPathAddLineToPoint(pathToDraw, NULL, -(self.radius / 2), -(5 * self.radius / 6));
            
            CGPathMoveToPoint(pathToDraw, NULL,  -(self.radius / 2), -(5 * self.radius / 6));
            CGPathAddLineToPoint(pathToDraw, NULL, -self.radius, 0);
            
            CGPathMoveToPoint(pathToDraw, NULL,  -self.radius, 0);
            CGPathAddLineToPoint(pathToDraw, NULL, -self.radius , self.radius / 3);
            
        }else{
            CGPathAddEllipseInRect(pathToDraw , NULL , CGRectMake(-self.radius, -self.radius, 2 * self.radius, 2 * self.radius) );
        }
        
        self.path = pathToDraw;
        
        //-----------------------------------PHYSICS---------------------------------
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: self.radius];
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
