//
//  TiledSprite.h
//  Strik
//
//  Created by Matthijn Dijkstra on 21/12/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "CCNode.h"

@interface TiledSprite : CCNode

// The texture which you want to repeat. To increase performance don't make the textures too small (e.g not 5x5 but rather have a 200x200 texture which repeats the texture itself multiple times) 
@property (nonatomic) CCTexture *texture;

- (id)initWithTexture:(CCTexture *)texture rect:(CGRect)rect;

+ (id)tileSpriteWithTexture:(CCTexture *)texture rect:(CGRect)rect;

@end
