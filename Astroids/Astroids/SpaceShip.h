//
//  Spaceship.h
//  Astroids
//
//  Created by Thomas Donohue on 2/17/16.
//
//

#import <SpriteKit/SpriteKit.h>

@interface Spaceship : SKShapeNode

- (id) initShipWithSize: (CGFloat) shipSize;

@property (nonatomic) CGSize size;

@end
