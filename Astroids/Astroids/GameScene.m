//
//  GameScene.m
//  Astroids
//
//  Created by Utku Dora on 15/02/16.
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "JCButton.h"
#import "Bullet.h"
#import "CGVectorAdditions.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    
    [self createAndDisplayShip];
    [self createAndDisplayControls];
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
}

- (void) createAndDisplayControls
{
    
        self.leftButton = [[JCButton alloc] initWithButtonRadius: 30
                                                          color: [SKColor redColor]
                                                   pressedColor: [SKColor blueColor]
                                                        isTurbo: NO
                                                    isRapidFire: YES];
        [self.leftButton setPosition:CGPointMake( (self.size.width / 23), (self.size.height / 5) )];
        self.leftButton.zPosition = 100;
        [self addChild: self.leftButton];
        
        
        self.rightButton = [[JCButton alloc] initWithButtonRadius: 30
                                                            color: [SKColor redColor]
                                                     pressedColor: [SKColor blueColor]
                                                          isTurbo: NO
                                                      isRapidFire: YES];
        [self.rightButton setPosition:CGPointMake( (self.size.width / 8) , (self.size.height / 5) )];
        self.rightButton.zPosition = 100;
        [self addChild: self.rightButton];
    
        self.thrustButton = [[JCButton alloc] initWithButtonRadius: 30
                                                             color: [SKColor redColor]
                                                      pressedColor: [SKColor blueColor]
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
    
        self.shootButton = [[JCButton alloc] initWithButtonRadius: 30
                                                            color: [SKColor redColor]
                                                     pressedColor: [SKColor blueColor]
                                                          isTurbo: NO
                                                      isRapidFire: YES];
        [self.shootButton setPosition:CGPointMake( (self.size.width - (self.size.width / 8))  , (self.size.height / 5) )];
        self.shootButton.zPosition = 100;
        [self addChild: self.shootButton];
    
        SKAction *shootingDelay = [SKAction waitForDuration: SHOOTING_DELAY];
        SKAction *checkShootingButton = [SKAction runBlock:^{
            [self shootingHandler];
        }];
        SKAction *teleportDelay = [SKAction waitForDuration: TELEPORT_DELAY];
        SKAction *checkShootingAction = [SKAction sequence:@[shootingDelay,checkShootingButton]];
        [self runAction:[SKAction repeatActionForever:checkShootingAction]];
    
    SKAction *checkBorderInterception = [SKAction runBlock:^{
        if (self.spaceship.frame.origin.x> self.size.width){
            
            [ self.spaceship setPosition:CGPointMake(self.spaceship.frame.origin.x-self.size.width,self.spaceship.frame.origin.y)];
        }
       else if (self.spaceship.frame.origin.x< 0){
            
            [ self.spaceship setPosition:CGPointMake(self.spaceship.frame.origin.x+self.size.width,self.spaceship.frame.origin.y)];
        }

        
        if (self.spaceship.frame.origin.y> self.size.height){
            
            [ self.spaceship setPosition:CGPointMake(self.spaceship.frame.origin.x,self.spaceship.frame.origin.y-self.size.height)];
        }
    if (self.spaceship.frame.origin.y< 0){
            
            [ self.spaceship setPosition:CGPointMake(self.spaceship.frame.origin.x,self.spaceship.frame.origin.y+self.size.height)];
        }
        
    }];
    SKAction *checkTeleportAction = [SKAction sequence:@[teleportDelay,checkBorderInterception]];
    [self runAction:[SKAction repeatActionForever:checkTeleportAction]];
    
       // SKAction *checkBorderIntersection = [SKAction sequence:@[shootingDelay,checkShootingButton]];
       // [self runAction:[SKAction repeatActionForever:checkShootingAction]];
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

@end
