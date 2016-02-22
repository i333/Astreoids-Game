//
//  Explosion.h
//  Astroids
//
//  Created by Thomas Donohue on 2/22/16.
//
//

#import <SpriteKit/SpriteKit.h>

@interface Explosion : SKShapeNode

-(id) initWithSize: (CGFloat) size;

@property (nonatomic) CGSize size;

@end
