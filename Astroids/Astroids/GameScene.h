//
//  GameScene.h
//  Astroids
//

//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Spaceship.h"
#import "JCButton.h"
#import "JCJoystick.h"

@interface GameScene : SKScene

// Objects
@property (strong, nonatomic) Spaceship* spaceship;

// Controls
@property (strong, nonatomic) JCButton *shootButton;
@property (strong, nonatomic) JCButton *thrustButton;

@property (strong, nonatomic) JCButton *leftButton;
@property (strong, nonatomic) JCButton *rightButton;

@property (strong, nonatomic) JCJoystick *joystick;

@end
