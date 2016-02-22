//
//  GameScene.m
//  Astroids
//
//  Created by Utku Dora on 15/02/16.
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

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

static int numAsteroidsToCreate = INIT_NUM_ASTEROIDS;

-(void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [SKColor blackColor];

    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    
    [self initializeGame];
    
    [self createWrappingBorders];
    
    [self createAndDisplayLabels];
    [self createAndDisplayControls];
    
    [self createAndDisplayShip];
    [self createAsteroids: numAsteroidsToCreate];
}

-(void)update:(CFTimeInterval)currentTime
{
    //NSLog(@"update");
}

//====================================INITIALIZATION==============================================

- (void) initializeGame
{
    self.asteroidArr = [NSMutableArray array];
    self.playerScore = 0;
    self.numLives = INIT_NUM_LIVES;
}

- (void) createAndDisplayLabels
{
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Hyperspace"];
    self.scoreLabel.text = @"00";
    self.scoreLabel.fontSize = 35;
    self.scoreLabel.fontColor = [SKColor whiteColor];
    self.scoreLabel.position = CGPointMake(self.size.width / 4, (53 * self.size.height / 64));
    [self addChild: self.scoreLabel];
    
    for(int i = 0; i < self.numLives; i++) {
        self.lifeIcons = [NSMutableArray array];
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
        
        //NSLog(@"Asteroid Position: (%0.2f,%0.2f)",pos.x,pos.y);
        //NSLog(@"Asteroid impulse: (%0.2f,%0.2f)",impulse.dx,impulse.dy);
        
        Asteroid* asteroid = [[Asteroid alloc] initWith: RAND_FROM_TO(0, 1)
                                                   size: 2
                                               position: pos];
        
        CGFloat randRotation = RANDF(0.0, M_PI);
        CGFloat zsign = arc4random() % 2 ? 1.0 : -1.0;
        asteroid.zRotation = zsign * randRotation;
        
        [self addChild: asteroid];
        [self.asteroidArr addObject: asteroid];
        [asteroid.physicsBody applyImpulse: impulse];
        
    }
    
    //For testing
    /**CGPoint pos = CGPointMake(300, 500);
     
     Asteroid* asteroid = [[Asteroid alloc] initWith: 1
     size: 2
     position: pos];
     [self addChild: asteroid];**/
}

- (void) createWrappingBorders
{
    [self addWrappingBorder: CGPointMake(0,self.size.height)
                    toPoint: CGPointMake(self.size.width,self.size.height)
               withCategory: topCategory];
    
    [self addWrappingBorder: CGPointMake(0.0f,0.0f)
                    toPoint:CGPointMake(self.size.width,0.0f)
               withCategory: bottomCategory];
    
    [self addWrappingBorder: CGPointMake(0.0f,0.0f)
                    toPoint:CGPointMake(0.0f,self.size.height)
               withCategory: leftCategory];
    
    [self addWrappingBorder: CGPointMake(self.size.width,0.0f)
                    toPoint:CGPointMake(self.size.width,self.size.height)
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
        //NSLog(@"Shot asteroid");

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
            
            //NSLog(@"aImpulse1: (%0.2f,%0.2f)", aImpulse1.dx, aImpulse1.dy);
            //NSLog(@"aImpulse2: (%0.2f,%0.2f)", aImpulse2.dx, aImpulse2.dy);
            
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
        
        [self.asteroidArr removeObject: shotAsteroid];
    
        [self removeChildrenInArray:[NSArray arrayWithObjects: contact.bodyA.node, contact.bodyB.node, nil]];
        
        NSLog(@"Asteroid count: %lu", (unsigned long)[self.asteroidArr count]);
        if([self.asteroidArr count] == 0){
            numAsteroidsToCreate++;
            [self createAsteroids: numAsteroidsToCreate];
        }
        
    }
    
    if(asteroidType3Collision || asteroidType4Collision) {
        //NSLog(@"Spaceship crashed");
        
        Explosion* explode = [[Explosion alloc] initWithSize: SHIP_SIZE];
        explode.position = self.spaceship.position;
        [self addChild: explode];
        
        [self removeChildrenInArray:[NSArray arrayWithObject: self.spaceship]];
        self.spaceship = nil;
        
        [NSTimer scheduledTimerWithTimeInterval: 1.0f
                                         target: self
                                       selector: @selector(createAndDisplayShip)
                                       userInfo: nil
                                        repeats: NO];
        
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
            CGVector shipDir = CGConvertAngleToVector(self.spaceship.zRotation);
            
            [self.spaceship.physicsBody applyImpulse:
             CGVectorMultiplyByScalar(shipDir, THRUST_SPEED)];
        }
        
        if (self.leftButton.wasPressed) {
            //NSLog(@"ship rotation: %f", self.spaceship.zRotation);
            SKAction *action = [SKAction rotateByAngle:0.2 duration:0.1];
            [self.spaceship runAction:[SKAction repeatAction:action count:1]];
        }
        
        if (self.rightButton.wasPressed) {
            //NSLog(@"ship rotation: %f", self.spaceship.zRotation);
            SKAction *action = [SKAction rotateByAngle:-0.2 duration:0.1];
            [self.spaceship runAction:[SKAction repeatAction:action count:1]];
        }
    }
    
}

//====================================UTILITIES==============================================

- (void) shootBullet
{
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

@end
