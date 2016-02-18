//
//  JCButton.h
//  TestSpriteKit01
//
//  Created by Juan Carlos Sedano Salas on 18/09/13.
//  Copyright (c) 2013 Juan Carlos Sedano Salas. All rights reserved.
//
// https://github.com/jsedano/JCInput/tree/master/JCInput

#import <SpriteKit/SpriteKit.h>

@interface JCButton : SKShapeNode
{
    
    
}
-(id)initWithButtonRadius:(float)buttonRadious
                    color:(SKColor *)color
             pressedColor:(SKColor *)pressedColor
                  isTurbo:(BOOL)isTurbo isRapidFire:(BOOL)isRapid;
-(BOOL)wasPressed;
@end