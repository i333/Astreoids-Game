//
//  Bullet.m
//  Astroids
//
//  Created by Thomas Donohue on 2/17/16.
//
//

#import "Bullet.h"
#import "CGVectorAdditions.h"
#import "CategoryBitMasks.h"

@implementation Bullet
    -(id) initWith:(CGPoint) pos direction:(CGVector) dir {
        if((self = [super init]))
        {
            // stroke
            self.strokeColor = [SKColor redColor];
            self.lineWidth = 3;
            
            // variables
            self.direction = CGVectorNormalize(dir);
            self.position = pos;
            
            // actions
            SKAction *moveBullet = [SKAction moveBy: CGVectorMultiplyByScalar(dir, BULLET_SPEED)
                                           duration: 1 ];
            
            [self runAction:[SKAction repeatActionForever: moveBullet]];
            
            // path
            CGMutablePathRef pathToDraw = CGPathCreateMutable();
            CGPathMoveToPoint(pathToDraw, NULL, 0.0f, 0.0f);
            CGPathAddLineToPoint(pathToDraw, NULL, dir.dx, dir.dy);
            self.path = pathToDraw;
            
            // physics
            self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:1.0f];
            self.physicsBody.usesPreciseCollisionDetection = YES;
            self.physicsBody.categoryBitMask = bulletCategory;
            self.physicsBody.collisionBitMask = 0;
            
        }
        return self;
    }
@end
