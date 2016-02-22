//
//  GameScene.m
//  Astroids
//
//  Created by Utku Dora on 15/02/16.
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#define ARC4RANDOM_MAX 0x100000000

#import "GameScene.h"
#import "JCButton.h"
#import "Bullet.h"
#import "Asteroid.h"
#import "CGVectorAdditions.h"
#import "CategoryBitMasks.h"

@implementation GameScene


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.backgroundColor = [SKColor blackColor];
    
    [self createWrappingBorders];
    self.physicsWorld.contactDelegate = self;
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    
    [self createAndDisplayShip];
    [self createAndDisplayControls];
    [self createAsteroids: INIT_NUM_ASTEROIDS];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    /**for (UITouch *touch in touches) {
     CGPoint location = [touch locationInNode:self];
     }**/
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //self.spaceship.zRotation = self.joystick.angle;
    //NSLog(@"update");
    for(Asteroid *asteroid in self.asteroidArr){
        CGVector asteroidDir = CGConvertAngleToVector(asteroid.zRotation);
        //[asteroid.physicsBody applyImpulse:
         //CGVectorMultiplyByScalar(asteroidDir, ASTEROID_SPEED)];
        
    }
}

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    // WRAP COLLISIONS
    
    // distance from the edge
    CGFloat distance = contact.bodyB.node.frame.size.width / 2 + 5.0f;
    
    if(contact.bodyA.categoryBitMask == topCategory){
        // entity hit top
        SKAction *moveBottom = [SKAction moveTo:CGPointMake(contact.bodyB.node.position.x, distance) duration:0.0f];
        [contact.bodyB.node runAction:moveBottom];
    }
    
    if(contact.bodyA.categoryBitMask == leftCategory){
        // entity hit left
        SKAction *moveRight = [SKAction moveTo:CGPointMake(self.size.width-distance, contact.bodyB.node.position.y) duration:0.0f];
        [contact.bodyB.node runAction:moveRight];
    }
    
    if(contact.bodyA.categoryBitMask == rightCategory){
        // entity hit right
        SKAction *moveLeft = [SKAction moveTo:CGPointMake(distance, contact.bodyB.node.position.y) duration:0.0f];
        [contact.bodyB.node runAction:moveLeft];
    }
    
    if(contact.bodyA.categoryBitMask == bottomCategory){
        // entity hit bottom
        SKAction *moveTop = [SKAction moveTo:CGPointMake(contact.bodyB.node.position.x, self.size.height-distance) duration:0.0f];
        [contact.bodyB.node runAction:moveTop];
    }
    
    // ASTEROID COLLISIONS
    
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
    
    if(asteroidType1Collision || asteroidType2Collision){
        NSLog(@"Shot asteroid");

        Asteroid* shotAsteroid = (Asteroid*)  (asteroidType1Collision ? contact.bodyA.node : contact.bodyB.node);
        
        if(shotAsteroid.size > 0){
        
            Bullet* shotBullet = (Bullet*)  (asteroidType2Collision ? contact.bodyA.node : contact.bodyB.node);
            
            CGVector bulletDirection = shotBullet.direction;
            CGVector vecPerp = CGVectorMakePerpendicular(bulletDirection);
            
            CGFloat fragDist = shotAsteroid.radius - (shotAsteroid.radius / 2);
            
            CGPoint pos1 = CGPointMake(shotAsteroid.position.x + vecPerp.dx * fragDist, shotAsteroid.position.y + vecPerp.dy * fragDist);
            CGPoint pos2 = CGPointMake(shotAsteroid.position.x - vecPerp.dx * fragDist, shotAsteroid.position.y - vecPerp.dy * fragDist);
            
            CGFloat randSpeed1 = ((double)arc4random() / ARC4RANDOM_MAX) * (1.5f) + 1.5f;
            CGFloat randSpeed2 = ((double)arc4random() / ARC4RANDOM_MAX) * (1.5f) + 1.5f;
            
            if(shotAsteroid.size == 2){
                randSpeed1 = ((double)arc4random() / ARC4RANDOM_MAX) * (2.5f) + 3.5f;
                randSpeed2 = ((double)arc4random() / ARC4RANDOM_MAX) * (2.5f) + 3.5f;
            }
            
            CGVector aImpulse1 = CGVectorMultiplyByScalar(vecPerp, randSpeed1);
            CGVector aImpulse2 = CGVectorMultiplyByScalar(vecPerp, -randSpeed2);
            
            //NSLog(@"aImpulse1: (%0.2f,%0.2f)", aImpulse1.dx, aImpulse1.dy);
            //NSLog(@"aImpulse2: (%0.2f,%0.2f)", aImpulse2.dx, aImpulse2.dy);
            
            Asteroid* smallerAsteroid1 = [[Asteroid alloc] initWith: 0 size: shotAsteroid.size - 1 position: pos1];
            [self.asteroidArr addObject: smallerAsteroid1];
            [self addChild: smallerAsteroid1];
            [smallerAsteroid1.physicsBody applyImpulse: aImpulse1];
            
            Asteroid* smallerAsteroid2 = [[Asteroid alloc] initWith: 0 size: shotAsteroid.size - 1 position: pos2];
            [self.asteroidArr addObject: smallerAsteroid2];
            [self addChild: smallerAsteroid2];
            [smallerAsteroid2.physicsBody applyImpulse: aImpulse2];
        }
        
        [self.asteroidArr removeObject: shotAsteroid];
    
        [self removeChildrenInArray:[NSArray arrayWithObjects: contact.bodyA.node, contact.bodyB.node, nil]];
        
        if([self.asteroidArr count] == 0){
            //[self createAsteroids: INIT_NUM_ASTEROIDS];
        }
        
    }
    
    if(asteroidType3Collision || asteroidType4Collision){
        NSLog(@"Spaceship crashed");
        
        [self removeChildrenInArray:[NSArray arrayWithObject: self.spaceship]];
        self.spaceship = nil;
        
        [NSTimer scheduledTimerWithTimeInterval: 1.0f
                                         target: self
                                       selector: @selector(createAndDisplayShip)
                                       userInfo: nil
                                        repeats: NO];
        
    }
    
}

- (void) addWrappingBorder:(CGPoint)orig toPoint:(CGPoint) dest withCategory:(int) cat{
    
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

- (void) createWrappingBorders {
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
    
    /**self.joystick = [[JCJoystick alloc] initWithControlRadius: 25
     baseRadius: 25
     baseColor: [SKColor redColor]
     joystickRadius: 25
     joystickColor: [SKColor blueColor]
     ];
     [self.joystick setPosition:CGPointMake(self.size.width / 7, self.size.height/ 5)];
     self.joystick.zPosition = 100;
     [self addChild: self.joystick];**/
}

- (void) createAndDisplayShip
{
    self.spaceship = [[Spaceship alloc] initShipWithSize: 20.0];
    [self.spaceship setPosition:CGPointMake(self.size.width/2,self.size.height/2)];
    [self addChild: self.spaceship];
}

- (void) shootBullet
{
    //self.spaceship.frame.origin.x
    
    CGVector shipDir = CGConvertAngleToVector(self.spaceship.zRotation);
    
    CGPoint startPos = CGPointMake(self.spaceship.position.x + shipDir.dx,
                                   self.spaceship.position.y + shipDir.dy);
    
    Bullet* bullet = [[Bullet alloc] initWith: startPos
                                    direction: shipDir];
    
    [self addChild: bullet];
}

- (void) shootingHandler
{
    if(self.spaceship != nil && self.shootButton.wasPressed)
    {
        [self shootBullet];
    }
}

- (void) movementHandlers
{
    if(self.spaceship != nil){
        
        if(self.thrustButton.wasPressed){
            CGVector shipDir = CGConvertAngleToVector(self.spaceship.zRotation);
            
            [self.spaceship.physicsBody applyImpulse:
             CGVectorMultiplyByScalar(shipDir, THRUST_SPEED)];
        }
        
        if (self.leftButton.wasPressed) {
            SKAction *action = [SKAction rotateByAngle:0.2 duration:0.1];
            [self.spaceship runAction:[SKAction repeatAction:action count:1]];
        }
        
        if (self.rightButton.wasPressed) {
            SKAction *action = [SKAction rotateByAngle:-0.2 duration:0.1];
            [self.spaceship runAction:[SKAction repeatAction:action count:1]];
        }
    }
    
}

- (void) createAsteroids: (int) numAsteroids
{
    
    int shipx1 = self.spaceship.position.x - self.spaceship.size.width;
    int shipx2 = self.spaceship.position.x + self.spaceship.size.width;
    int shipy1 = self.spaceship.position.y - self.spaceship.size.height;
    int shipy2 = self.spaceship.position.y + self.spaceship.size.height;
    
    for(int i = 0; i < numAsteroids; i++){
        
        int xpos1 = arc4random_uniform(shipx1);
        int ypos1 = arc4random_uniform(shipy1);
        int xpos2 = shipx2 + arc4random_uniform(self.size.width - shipx2);
        int ypos2 = shipy2 + arc4random_uniform(self.size.height - shipy2);
        
        int xpos = arc4random_uniform(100) < 50 ? xpos1 : xpos2;
        int ypos = arc4random_uniform(100) < 50 ? ypos1 : ypos2;
        CGPoint pos = CGPointMake(xpos, ypos);
        
        CGVector impulse = CGVectorMake(arc4random_uniform(50), arc4random_uniform(50));
        
        //NSLog(@"Asteroid Position: (%0.2f,%0.2f)",pos.x,pos.y);
        //NSLog(@"Asteroid impulse: (%0.2f,%0.2f)",impulse.dx,impulse.dy);
        
        Asteroid* asteroid = [[Asteroid alloc] initWith: 0
                                                   size: 2
                                               position: pos];
        [self addChild: asteroid];
        [self.asteroidArr addObject: asteroid];
        [asteroid.physicsBody applyImpulse: impulse];
        
    }
    
    //For testing
    /**CGPoint pos = CGPointMake(300, 500);
    
    Asteroid* asteroid = [[Asteroid alloc] initWith: 0
                                               size: 2
                                           position: pos];
    [self addChild: asteroid];**/
}

@end
