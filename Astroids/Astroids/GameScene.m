//
//  GameScene.m
//  Astroids
//
//  Created by Utku Dora on 15/02/16.
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#define ASTEROID_SMALL 0
#define ASTEROID_MED 1
#define ASTEROID_LARGE 2

#define ARC4RANDOM_MAX 0x100000000
#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))
#define RANDF(min, max) (((float)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);

#import "GameScene.h"
#import "JCButton.h"
#import "Bullet.h"
#import "Asteroid.h"
#import "Explosion.h"
#import "LifeIcon.h"
#import "CGVectorAdditions.h"
#import "CategoryBitMasks.h"

@implementation GameScene

static NSInteger highScore;

static int numAsteroidsToCreate = INIT_NUM_ASTEROIDS;
static long extraLifeThreshold = EXTRA_LIFE_THRESHOLD;

static BOOL _DEBUG = NO;

-(void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [SKColor blackColor];

    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    
    [self createStartGameButton];
    [self showMenuScreen];
}

//====================================INITIALIZATION==============================================

- (void) initializeGame
{
    if(!self.asteroidArr) {
        self.asteroidArr = [NSMutableArray array];
    }
    self.playerScore = 0;
    self.numLives = INIT_NUM_LIVES;
}

-(void)showMenuScreen
{
    
    self.nameLabel = [SKLabelNode labelNodeWithFontNamed:@"Hyperspace"];
    self.nameLabel.text = @"ASTEROIDS";
    self.nameLabel.fontSize = 100;
    self.nameLabel.fontColor = [SKColor whiteColor];
    self.nameLabel.position = CGPointMake(self.size.width / 2, (2 * self.size.height / 3));
    [self addChild: self.nameLabel];
    
    self.highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Hyperspace"];
    highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
    if (highScore < 0) {
        highScore = 0;
    }
    NSString* highScoreString = [@(highScore) stringValue];
    NSString *labelString = @"High Score: ";
    labelString = [labelString stringByAppendingString:highScoreString];
    self.highScoreLabel.text = labelString;
    self.highScoreLabel.fontSize = 35;
    self.highScoreLabel.fontColor = [SKColor whiteColor];
    self.highScoreLabel.position = CGPointMake(self.size.width / 2, (self.size.height / 3));
    [self addChild:  self.highScoreLabel];
    
    [self createWrappingBorders];
    [self createAsteroids: MENU_NUM_ASTEROIDS];
    
}

- (void) createStartGameButton
{
    self.startGameButton = [[UIButton alloc] initWithFrame: CGRectMake(self.size.width / 5, self.size.height / 4, 300, 60)];
    self.startGameButton.titleLabel.font = [UIFont fontWithName:@"Hyperspace" size: 35];
    
    [self.startGameButton addTarget: self
                             action: @selector(startGameButtonClicked:)
                   forControlEvents: UIControlEventTouchUpInside];
    [self.startGameButton setTitle: @"Play Game" forState: UIControlStateNormal];
    [self.startGameButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    
    [[self view] addSubview:self.startGameButton];
}

-(void) startGameButtonClicked:(UIButton*)sender
{

    self.startGameButton.hidden = true;
    
    [self removeAllChildren];
    [self removeAllActions];
    
    [self runAction:[SKAction playSoundFileNamed:@"beat1.wav" waitForCompletion:NO]];
    
    [self createWrappingBorders];
    
    [self initializeGame];
    
    [self createAndDisplayLabels];
    [self createAndDisplayControls];
    
    [self createAndDisplayShip];
    [self createAsteroids: numAsteroidsToCreate];
}

- (void) createAndDisplayLabels
{
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Hyperspace"];
    self.scoreLabel.text = @"00";
    self.scoreLabel.fontSize = 35;
    self.scoreLabel.fontColor = [SKColor whiteColor];
    self.scoreLabel.position = CGPointMake(self.size.width / 4, (53 * self.size.height / 64));
    [self addChild: self.scoreLabel];
    
    if(!self.lifeIcons) {
        self.lifeIcons = [NSMutableArray array];
    }
    for(int i = 0; i < self.numLives; i++) {
        LifeIcon* icon = [[LifeIcon alloc] initIconWithSize: (3 * SHIP_SIZE / 4)];
        icon.position = CGPointMake((7 * self.size.width / 32) + i * SHIP_SIZE, (52 * self.size.height / 64));
        [self.lifeIcons addObject: icon];
        [self addChild: icon];
    }
}

- (void) createAndDisplayControls
{
    
    SKColor* whiteT = [SKColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:0.5f];
    SKColor* grayT = [SKColor colorWithHue:0.0f saturation:0.0f brightness:0.5f alpha:0.5f];
    
    self.leftButton = [[JCButton alloc] initWithButtonRadius: BUTTON_SIZE
                                                       color: whiteT
                                                pressedColor: grayT
                                                     isTurbo: NO
                                                 isRapidFire: YES];
    [self.leftButton setPosition:CGPointMake( (self.size.width / 23), (self.size.height / 5) )];
    self.leftButton.zPosition = 100;
    [self addChild: self.leftButton];
    
    
    self.rightButton = [[JCButton alloc] initWithButtonRadius: BUTTON_SIZE
                                                        color: whiteT
                                                 pressedColor: grayT
                                                      isTurbo: NO
                                                  isRapidFire: YES];
    [self.rightButton setPosition:CGPointMake( (self.size.width / 8) , (self.size.height / 5) )];
    self.rightButton.zPosition = 100;
    [self addChild: self.rightButton];
    
    self.thrustButton = [[JCButton alloc] initWithButtonRadius: BUTTON_SIZE
                                                         color: whiteT
                                                  pressedColor: grayT
                                                       isTurbo: NO
                                                   isRapidFire: YES];
    
    [self.thrustButton setPosition:CGPointMake( (self.size.width - (self.size.width / 20))  , (self.size.height / 4) )];
    self.thrustButton.zPosition = 100;
    [self addChild: self.thrustButton];
    
    
    SKAction *movementDelay = [SKAction waitForDuration: MOVEMENT_DELAY];
    SKAction *checkMovementButtons = [SKAction runBlock:^{
        [self movementHandlers];
    }];
    
    SKAction *checkMovementAction = [SKAction sequence:@[movementDelay,checkMovementButtons]];
    [self runAction:[SKAction repeatActionForever:checkMovementAction]];
    
    self.shootButton = [[JCButton alloc] initWithButtonRadius: BUTTON_SIZE
                                                        color: whiteT
                                                 pressedColor: grayT
                                                      isTurbo: NO
                                                  isRapidFire: YES];
    [self.shootButton setPosition:CGPointMake( (self.size.width - (self.size.width / 8))  , (self.size.height / 5) )];
    self.shootButton.zPosition = 100;
    [self addChild: self.shootButton];
    
    SKAction *shootingDelay = [SKAction waitForDuration: SHOOTING_DELAY];
    SKAction *checkShootingButton = [SKAction runBlock:^{
        [self shootingHandler];
    }];
    
    SKAction *checkShootingAction = [SKAction sequence:@[shootingDelay,checkShootingButton]];
    [self runAction:[SKAction repeatActionForever:checkShootingAction]];
    
}

- (void) createAndDisplayShip
{
    self.spaceship = [[Spaceship alloc] initShipWithSize: SHIP_SIZE];
    [self.spaceship setPosition:CGPointMake(self.size.width / 2,self.size.height / 2)];
    for(Asteroid *asteroid in self.asteroidArr){
        if([self.spaceship intersectsNode: asteroid]) {
            [NSTimer scheduledTimerWithTimeInterval: 0.5f
                                             target: self
                                           selector: @selector(createAndDisplayShip)
                                           userInfo: nil
                                            repeats: NO];
            self.spaceship = nil;
            return;
        }
        
    }
    [self addChild: self.spaceship];
}

- (void) createAsteroids: (int) numAsteroids
{
    
    int shipx1 = self.spaceship.position.x - self.spaceship.size.width;
    int shipx2 = self.spaceship.position.x + self.spaceship.size.width;
    int shipy1 = self.spaceship.position.y - self.spaceship.size.height;
    int shipy2 = self.spaceship.position.y + self.spaceship.size.height;
    
    for(int i = 0; i < numAsteroids; i++) {
        
        int xpos1 = arc4random_uniform(shipx1);
        int ypos1 = arc4random_uniform(shipy1);
        int xpos2 = shipx2 + arc4random_uniform(self.size.width - shipx2);
        int ypos2 = shipy2 + arc4random_uniform(self.size.height - shipy2);
        
        int xpos = arc4random_uniform(100) < 50 ? xpos1 : xpos2;
        int ypos = arc4random_uniform(100) < 50 ? ypos1 : ypos2;
        CGPoint pos = CGPointMake(xpos, ypos);
        
        int randx = RAND_FROM_TO(25, 75);
        int randy = RAND_FROM_TO(25, 75);
        
        int signx = arc4random() % 2 ? 1 : -1;
        int signy = arc4random() % 2 ? 1 : -1;
        
        CGVector impulse = CGVectorMake(signx * randx, signy * randy);
        
        if(_DEBUG){
            NSLog(@"Asteroid Position: (%0.2f,%0.2f)",pos.x,pos.y);
            NSLog(@"Asteroid impulse: (%0.2f,%0.2f)",impulse.dx,impulse.dy);
        }
        
        Asteroid* asteroid = [[Asteroid alloc] initWith: RAND_FROM_TO(0, 2)
                                                   size: 2
                                               position: pos];
        
        CGFloat randRotation = RANDF(0.0, M_PI);
        CGFloat zsign = arc4random() % 2 ? 1.0 : -1.0;
        asteroid.zRotation = zsign * randRotation;
        
        [self addChild: asteroid];
        [self.asteroidArr addObject: asteroid];
        [asteroid.physicsBody applyImpulse: impulse];
        
    }
}

- (void) createWrappingBorders
{
    [self addWrappingBorder: CGPointMake(0, self.size.height)
                    toPoint: CGPointMake(self.size.width, self.size.height)
               withCategory: topCategory];
    
    [self addWrappingBorder: CGPointMake(0.0f,0.0f)
                    toPoint:CGPointMake(self.size.width, 0.0f)
               withCategory: bottomCategory];
    
    [self addWrappingBorder: CGPointMake(0.0f, 0.0f)
                    toPoint:CGPointMake(0.0f, self.size.height)
               withCategory: leftCategory];
    
    [self addWrappingBorder: CGPointMake(self.size.width, 0.0f)
                    toPoint:CGPointMake(self.size.width, self.size.height)
               withCategory: rightCategory];
}

//====================================COLLISION DETECTION==============================================

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    //-----------------------------------WRAP COLLISIONS----------------------------------------
    
    // distance from the edge
    CGFloat distance = contact.bodyB.node.frame.size.width / 2 + 5.0f;
    
    if(contact.bodyA.categoryBitMask == topCategory) {
        // entity hit top
        SKAction *moveBottom = [SKAction moveTo:CGPointMake(contact.bodyB.node.position.x, distance) duration:0.0f];
        [contact.bodyB.node runAction:moveBottom];
    }
    
    if(contact.bodyA.categoryBitMask == leftCategory) {
        // entity hit left
        SKAction *moveRight = [SKAction moveTo:CGPointMake(self.size.width-distance, contact.bodyB.node.position.y) duration:0.0f];
        [contact.bodyB.node runAction:moveRight];
    }
    
    if(contact.bodyA.categoryBitMask == rightCategory) {
        // entity hit right
        SKAction *moveLeft = [SKAction moveTo:CGPointMake(distance, contact.bodyB.node.position.y) duration:0.0f];
        [contact.bodyB.node runAction:moveLeft];
    }
    
    if(contact.bodyA.categoryBitMask == bottomCategory) {
        // entity hit bottom
        SKAction *moveTop = [SKAction moveTo:CGPointMake(contact.bodyB.node.position.x, self.size.height-distance) duration:0.0f];
        [contact.bodyB.node runAction:moveTop];
    }
    
    //-----------------------------------ASTEROID COLLISIONS----------------------------------------
    
    int asteroidType1Collision =
    (contact.bodyA.categoryBitMask & asteroidCategory) != 0 &&
    (contact.bodyB.categoryBitMask & bulletCategory) != 0;
    
    int asteroidType2Collision =
    (contact.bodyB.categoryBitMask & asteroidCategory) != 0 &&
    (contact.bodyA.categoryBitMask & bulletCategory) != 0;
    
    int asteroidType3Collision =
    (contact.bodyA.categoryBitMask & asteroidCategory) != 0 &&
    (contact.bodyB.categoryBitMask & shipCategory) != 0;
    
    int asteroidType4Collision =
    (contact.bodyB.categoryBitMask & asteroidCategory) != 0 &&
    (contact.bodyA.categoryBitMask & shipCategory) != 0;
    
    if(asteroidType1Collision || asteroidType2Collision) {
        if(_DEBUG) { NSLog(@"Shot asteroid"); }

        Asteroid* shotAsteroid = (Asteroid*)  (asteroidType1Collision ? contact.bodyA.node : contact.bodyB.node);
        
        if(shotAsteroid.size > 0){
        
            Bullet* shotBullet = (Bullet*)  (asteroidType2Collision ? contact.bodyA.node : contact.bodyB.node);
            
            CGVector bulletDirection = shotBullet.direction;
            CGVector vecPerp = CGVectorMakePerpendicular(bulletDirection);
            
            CGFloat fragDist = shotAsteroid.radius - (shotAsteroid.radius / 2);
            
            CGPoint pos1 = CGPointMake(shotAsteroid.position.x + vecPerp.dx * fragDist, shotAsteroid.position.y + vecPerp.dy * fragDist);
            CGPoint pos2 = CGPointMake(shotAsteroid.position.x - vecPerp.dx * fragDist, shotAsteroid.position.y - vecPerp.dy * fragDist);
            
            CGFloat maxSpeed = 0.7f * shotAsteroid.size;
            CGFloat minSpeed = 0.3f * shotAsteroid.size;
            
            CGFloat randSpeed1 = RANDF(minSpeed, maxSpeed);
            CGFloat randSpeed2 = RANDF(minSpeed, maxSpeed);
            
            CGFloat randAngle1 = RANDF(0.0, M_PI);
            CGFloat randAngle2 = RANDF(0.0, M_PI);
            
            CGFloat sign1 = arc4random() % 2 ? 1.0 : -1.0;
            CGFloat sign2 = arc4random() % 2 ? 1.0 : -1.0;
            
            CGVector randVec1 = CGConvertAngleToVector(sign1 * randAngle1);
            CGVector randVec2 = CGConvertAngleToVector(sign2 * randAngle2);
            
            CGVector aImpulse1 = CGVectorMultiplyByScalar(randVec1, randSpeed1);
            CGVector aImpulse2 = CGVectorMultiplyByScalar(randVec2, -randSpeed2);
            
            if(_DEBUG) {
                NSLog(@"aImpulse1: (%0.2f,%0.2f)", aImpulse1.dx, aImpulse1.dy);
                NSLog(@"aImpulse2: (%0.2f,%0.2f)", aImpulse2.dx, aImpulse2.dy);
            }
            
            Asteroid* smallerAsteroid1 = [[Asteroid alloc] initWith: shotAsteroid.type size: shotAsteroid.size - 1 position: pos1];
            smallerAsteroid1.zRotation = shotAsteroid.zRotation;
            [self.asteroidArr addObject: smallerAsteroid1];
            [self addChild: smallerAsteroid1];
            [smallerAsteroid1.physicsBody applyImpulse: aImpulse1];
            
            Asteroid* smallerAsteroid2 = [[Asteroid alloc] initWith: shotAsteroid.type size: shotAsteroid.size - 1 position: pos2];
            smallerAsteroid2.zRotation = shotAsteroid.zRotation;
            [self.asteroidArr addObject: smallerAsteroid2];
            [self addChild: smallerAsteroid2];
            [smallerAsteroid2.physicsBody applyImpulse: aImpulse2];
        }
        
        [self updateScore: shotAsteroid.size];
        [self.asteroidArr removeObject: shotAsteroid];
    
        [self removeChildrenInArray:[NSArray arrayWithObjects: contact.bodyA.node, contact.bodyB.node, nil]];
        
        if(_DEBUG) { NSLog(@"Asteroid count: %lu", (unsigned long)[self.asteroidArr count]); }
        
        if([self.asteroidArr count] == 0) {
            if(numAsteroidsToCreate < MAX_NUM_ASTEROIDS) {
                numAsteroidsToCreate++;
            }
            [self createAsteroids: numAsteroidsToCreate];
        }
        
    }
    
    if(asteroidType3Collision || asteroidType4Collision) {
        if(_DEBUG) { NSLog(@"Spaceship crashed"); }
        
        [self runAction:[SKAction playSoundFileNamed:@"bangSmall.wav" waitForCompletion:NO]];
        
        if(self.spaceship != nil) {
        
            self.numLives--;
            if([self.lifeIcons count]  > 0){
                NSArray *iconToRemove = [NSArray arrayWithObject: [self.lifeIcons objectAtIndex: [self.lifeIcons count] - 1]];
                [self removeChildrenInArray: iconToRemove];
                [self.lifeIcons removeObjectsInArray: iconToRemove];
            }
            Explosion* explode = [[Explosion alloc] initWithSize: SHIP_SIZE];
            explode.position = self.spaceship.position;
            [self addChild: explode];
            
            [self removeChildrenInArray:[NSArray arrayWithObject: self.spaceship]];
            self.spaceship = nil;
            
            if(self.numLives > 0) {
                [NSTimer scheduledTimerWithTimeInterval: 1.0f
                                                 target: self
                                               selector: @selector(createAndDisplayShip)
                                               userInfo: nil
                                                repeats: NO];
            }else {
                if (self.playerScore > highScore) {
                    
                    [[NSUserDefaults standardUserDefaults] setInteger: self.playerScore forKey:@"HighScore"];
                    
                }
                [self removeAllChildren];
                [self removeAllActions];
                
                [self runAction:[SKAction playSoundFileNamed:@"beat2.wav" waitForCompletion:NO]];
                
                [self.asteroidArr removeAllObjects];
                [self.lifeIcons removeAllObjects];
                self.startGameButton.hidden = false;
                
                [self showMenuScreen];
            }
        }
        
    }
    
}

//====================================HANDLERS==============================================

- (void) shootingHandler
{
    if(self.spaceship != nil && self.shootButton.wasPressed) {
        [self shootBullet];
    }
}

- (void) movementHandlers
{
    if(self.spaceship != nil) {
        
        if(self.thrustButton.wasPressed) {
            [self runAction:[SKAction playSoundFileNamed:@"thrust.wav" waitForCompletion:NO]];
            
            CGVector shipDir = CGConvertAngleToVector(self.spaceship.zRotation);
            
            [self.spaceship.physicsBody applyImpulse:
             CGVectorMultiplyByScalar(shipDir, THRUST_SPEED)];
        }
        
        if (self.leftButton.wasPressed) {
            SKAction *action = [SKAction rotateByAngle: 0.2 duration:0.1];
            [self.spaceship runAction:[SKAction repeatAction: action count:1]];
        }
        
        if (self.rightButton.wasPressed) {
            SKAction *action = [SKAction rotateByAngle: -0.2 duration:0.1];
            [self.spaceship runAction:[SKAction repeatAction: action count:1]];
        }
    }
    
}

//====================================UTILITIES==============================================

- (void) shootBullet
{
    [self runAction:[SKAction playSoundFileNamed:@"fire.wav" waitForCompletion:NO]];
    
    CGVector shipDir = CGConvertAngleToVector(self.spaceship.zRotation);
    
    CGPoint startPos = CGPointMake(self.spaceship.position.x + shipDir.dx,
                                   self.spaceship.position.y + shipDir.dy);
    
    Bullet* bullet = [[Bullet alloc] initWith: startPos
                                    direction: shipDir];
    
    [self addChild: bullet];
}

- (void) addWrappingBorder:(CGPoint)orig toPoint:(CGPoint) dest withCategory:(int) cat
{
    SKNode* border = [SKNode node];
    border.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint: orig
                                                      toPoint: dest];
    border.physicsBody.usesPreciseCollisionDetection = YES;
    border.physicsBody.categoryBitMask = cat;
    // collide with wrappable entities
    border.physicsBody.contactTestBitMask = wrapCategory;
    // bounce off nothing
    border.physicsBody.collisionBitMask = 0;
    [self addChild:border];
}

- (void) updateScore: (int) asteroidSize
{
    if(asteroidSize == ASTEROID_SMALL) {
        [self runAction:[SKAction playSoundFileNamed:@"bangSmall.wav" waitForCompletion:NO]];
        self.playerScore += ASTEROID_SMALL_VALUE;
    }else if(asteroidSize == ASTEROID_MED) {
        [self runAction:[SKAction playSoundFileNamed:@"bangMedium.wav" waitForCompletion:NO]];
        self.playerScore += ASTEROID_MED_VALUE;
    }else if(asteroidSize == ASTEROID_LARGE) {
        [self runAction:[SKAction playSoundFileNamed:@"bangLarge.wav" waitForCompletion:NO]];
        self.playerScore += ASTEROID_LARGE_VALUE;
    }
    if(self.playerScore > extraLifeThreshold) {
        [self runAction:[SKAction playSoundFileNamed:@"extraShip.wav" waitForCompletion:NO]];
        
        extraLifeThreshold += EXTRA_LIFE_THRESHOLD;
        [self addLife];
    }
    [self displayScore];
}

- (void) addLife
{
    self.numLives++;
    LifeIcon* icon = [[LifeIcon alloc] initIconWithSize: (3 * SHIP_SIZE / 4)];
    icon.position = CGPointMake((7 * self.size.width / 32) + ([self.lifeIcons count] - 1) * SHIP_SIZE, (52 * self.size.height / 64));
    [self.lifeIcons addObject: icon];
    [self addChild: icon];
}

- (void) displayScore
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", self.playerScore];
}

@end
