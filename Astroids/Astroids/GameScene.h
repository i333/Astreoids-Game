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

@interface GameScene : SKScene <SKPhysicsContactDelegate>

// Objects
@property (strong, nonatomic) Spaceship* spaceship;
@property(strong, nonatomic) NSMutableArray *asteroidArr;

// Controls
@property (strong, nonatomic) JCButton *shootButton;
@property (strong, nonatomic) JCButton *thrustButton;

@property (strong, nonatomic) JCButton *leftButton;
@property (strong, nonatomic) JCButton *rightButton;

@property (strong, nonatomic) JCJoystick *joystick;

@end

static const int BUTTON_SIZE = 35;

static const int INIT_NUM_ASTEROIDS = 2;

static const CGFloat MOVEMENT_DELAY = 0.1f;
static const CGFloat SHOOTING_DELAY = 0.3f;
static const CGFloat TELEPORT_DELAY = 0.1f;

static const CGFloat THRUST_SPEED = 0.1f;

static const CGFloat ASTEROID_SPEED = 0.1f;
