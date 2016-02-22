//
//  Asteroid.h
//  Astroids
//
//  Created by Thomas Donohue on 2/20/16.
//
//

#import <SpriteKit/SpriteKit.h>

#define ASTEROID_SMALL 0
#define ASTEROID_MED 1
#define ASTEROID_LARGE 2

@interface Asteroid : SKShapeNode

- (id) initWith: (int) type size: (int) sizeVal position: (CGPoint) pos;

@property (nonatomic) int type;
@property (nonatomic) int size;
@property (nonatomic) CGFloat radius;

@end
