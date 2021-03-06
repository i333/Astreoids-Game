//
//  JCButton.m
//  TestSpriteKit01
//
//  Created by Juan Carlos Sedano Salas on 18/09/13.
//  Copyright (c) 2013 Juan Carlos Sedano Salas. All rights reserved.
//
// https://github.com/jsedano/JCInput/tree/master/JCInput

#import "JCButton.h"
#import "JCJoystick.h"
#import "Math.h"
@interface JCButton()
@property (nonatomic,strong) UITouch *onlyTouch;
@property float buttonRadius;
@property SKColor *color;
@property SKColor *pressedColor;
@property BOOL wasRead;
@property BOOL isOn;
@property BOOL isTurbo;
@property BOOL isRapidFire;
@property BOOL isDown;
@end

@implementation JCButton

-(id)initWithButtonRadius:(float)buttonRadious
                    color:(SKColor *)color
             pressedColor:(SKColor *)pressedColor
                  isTurbo:(BOOL)isTurbo 
              isRapidFire:(BOOL)isRapid

{
    if((self = [super init]))
    {
        self.color = color;
        self.pressedColor = pressedColor;
        self.onlyTouch = nil;
        self.buttonRadius = buttonRadious;
        self.isTurbo = isTurbo;
        self.isOn = NO;
        self.wasRead = NO;
        self.isDown = NO;
        self.isRapidFire = isRapid;
        [self setUserInteractionEnabled:YES];
        self.lineWidth = 2;
        CGMutablePathRef circlePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(circlePath , NULL , CGRectMake(self.position.x-self.buttonRadius, self.position.y-self.buttonRadius, self.buttonRadius*2, self.buttonRadius*2) );
        self.path = circlePath;
        self.fillColor =  self.color;
        CGPathRelease( circlePath );
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!self.onlyTouch) {
        self.onlyTouch = [touches anyObject];
        self.isOn = YES;
        self.wasRead = NO;
        self.isDown = YES;
        self.fillColor = self.pressedColor;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if(!self.onlyTouch){
        return;
    }
    CGPoint location = [self.onlyTouch locationInNode:[self parent]];
    if (![self containsPoint:location]) {
        self.onlyTouch = nil;
        if (self.isTurbo) {
            if (self.wasRead) {
                self.isOn = NO;
            }
        }
        self.isDown = NO;
        self.fillColor = self.color;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if ([[touches allObjects] containsObject:self.onlyTouch]) {
        if (self.wasRead) {
            self.isOn = NO;
        }
        self.isDown = NO;
        self.fillColor = self.color;
        self.onlyTouch = nil;
    }
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if ([[touches allObjects] containsObject:self.onlyTouch]) {
        self.fillColor = self.color;
        self.onlyTouch = nil;
        self.isOn = NO;
        self.wasRead = YES;
        
    }
}


-(BOOL)wasPressed
{
    self.wasRead = YES;
    if(self.isRapidFire && self.isDown){
        return YES;
    }
    if (self.isOn) {
        if (!self.isTurbo) {
            self.isOn = NO;
        }
        return YES;
    }
    return NO;
    
}
@end