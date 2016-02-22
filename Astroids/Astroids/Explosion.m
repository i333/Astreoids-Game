//
//  Explosion.m
//  Astroids
//
//  Created by Thomas Donohue on 2/22/16.
//
//

#import "Explosion.h"

@implementation Explosion

-(id) initWithSize: (CGFloat) size
{
    if((self = [super init]))
    {
        
        self.size = CGSizeMake(size, size);
        
        CGMutablePathRef circlePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(circlePath , NULL , CGRectMake(-self.size.width/2, -self.size.height/2, self.size.width, self.size.height) );
        self.path = circlePath;
        
        [self setFillColor:[SKColor redColor]];
        
        SKAction *firingWait = [SKAction waitForDuration:0.01f];
        SKAction *checkFiringButtons = [SKAction runBlock:^{
            [self reDraw];
        }];
        
        SKAction *checkFiringButtonsAction = [SKAction sequence:@[firingWait,checkFiringButtons]];
        [self runAction:[SKAction repeatActionForever:checkFiringButtonsAction]];
        
    }
    return self;
}

- (void) reDraw {
    self.size = CGSizeMake(self.size.width+1, self.size.height+1);
    
    if(self.size.width < 50){
        
        CGMutablePathRef circlePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(circlePath , NULL , CGRectMake(-self.size.width/2, -self.size.height/2, self.size.width, self.size.height) );
        self.path = circlePath;
    } else {
        self.path = nil;
    }
}

@end
