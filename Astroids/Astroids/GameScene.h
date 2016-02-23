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
@property(strong, nonatomic) NSMutableArray* asteroidArr;

// Controls
@property (strong, nonatomic) JCButton* shootButton;
@property (strong, nonatomic) JCButton* thrustButton;

@property (strong, nonatomic) JCButton* leftButton;
@property (strong, nonatomic) JCButton* rightButton;

// Game
@property (nonatomic) long playerScore;
@property (nonatomic) int numLives;

// Display
@property (strong, nonatomic) SKLabelNode* scoreLabel;
@property (strong, nonatomic) SKLabelNode* highScoreLabel;

@property(strong, nonatomic) NSMutableArray* lifeIcons;

// Menu
@property (strong, nonatomic) SKLabelNode* nameLabel;
@property(strong, nonatomic) UIButton *startGameButton;

@end

static const int BUTTON_SIZE = 35;
static const int SHIP_SIZE = 20;

static const int INIT_NUM_ASTEROIDS = 1;
static const int MAX_NUM_ASTEROIDS = 10;
static const int MENU_NUM_ASTEROIDS = 5;

static const int INIT_NUM_LIVES = 4;

static const int ASTEROID_SMALL_VALUE = 100;
static const int ASTEROID_MED_VALUE = 50;
static const int ASTEROID_LARGE_VALUE = 20;

static const int EXTRA_LIFE_THRESHOLD = 5000;

static const CGFloat MOVEMENT_DELAY = 0.1f;
static const CGFloat SHOOTING_DELAY = 0.3f;

static const CGFloat THRUST_SPEED = 0.1f;

static const CGFloat ASTEROID_SPEED = 0.1f;
