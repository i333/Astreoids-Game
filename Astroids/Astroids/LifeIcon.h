//
//  LifeIcon.h
//  Astroids
//
//  Created by Thomas Donohue on 2/22/16.
//
//

#import <SpriteKit/SpriteKit.h>

@interface LifeIcon : SKShapeNode

- (id) initIconWithSize: (CGFloat) iconSize;

@property (nonatomic) CGSize size;

@end
