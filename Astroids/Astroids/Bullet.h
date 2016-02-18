//
//  Bullet.h
//  Astroids
//
//  Created by Thomas Donohue on 2/17/16.
//
//

#import <SpriteKit/SpriteKit.h>

@interface Bullet : SKShapeNode


-(id) initWith:(CGPoint) pos direction:(CGVector) dir;

@property (nonatomic) CGVector direction;

@end

static const CGFloat BULLET_SPEED = 30.0f;
