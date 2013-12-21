//
//  TiledSprite.m
//  Strik
//
//  Created by Matthijn Dijkstra on 21/12/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "TiledSprite.h"

@interface TiledSprite()

// For performance reasons we render all repeated texture nodes once of screen and create a texture out of that so we don't have to go through the entire tree each draw call
@property CCRenderTexture *renderTexture;

// We are going to use a batchnode to create the nodes for the first time since all nodes have the same texture this is faster
@property CCSpriteBatchNode *batchNode;

@end

@implementation TiledSprite

+ (id)tileSpriteWithTexture:(CCTexture *)texture rect:(CGRect)rect
{
	return [[TiledSprite alloc] initWithTexture:texture rect:rect];
}

- (id)initWithTexture:(CCTexture *)texture rect:(CGRect)rect
{
	if(self = [super init])
	{
		// Don't want to call the refresh twice @ init so bypassing those setters
		[super setContentSize:rect.size];
		_texture = texture;
		
		self.position = rect.origin;
		
		// Draw the repeated texture
		[self refresh];
	}
	return self;
}

- (void)setTexture:(CCTexture *)texture
{
	_texture = texture;
	[self refresh];
}

- (void)setContentSize:(CGSize)contentSize
{
	[super setContentSize:contentSize];
	[self refresh];
}


- (void)refresh
{
	// First clear out the old
	[self clear];
	
	// And render the repeated texture
	[self render:self.texture];
}

// Render the texture
- (void)render:(CCTexture *)texture
{
	// Create a batch node to draw all the sprite nodes the first time
	self.batchNode = [CCSpriteBatchNode batchNodeWithTexture:self.texture];
	self.batchNode.anchorPoint = CGPointMake(0, 0);
	
	CGSize textureSize = self.texture.contentSize;
	
	// Keep track of the number of childs for later reference
	int numberOfChilds;
	
	// Create 2 loops to add child nodes, starting from topleft and working our way down (which is easier for cropping correctly since a cropped node renders it's top left part)
	for(int x = 0; x < self.contentSize.width; x += textureSize.width)
	{
		for(int y = self.contentSize.height; y > 0; y -= textureSize.height)
		{
			CCSprite *sprite;
			
			// For cropped sprites the y position must be recalculated for others it is just the x and y from the loop
			CGFloat yPosition = y;
			CGFloat xPosition = x;
			
			// Determine if the full sprite fits
			if((x + textureSize.width <= self.contentSize.width) && (y - textureSize.height >= 0))
			{
				sprite = [CCSprite spriteWithTexture:self.texture];
			}
			// The full sprite doesn't fit anymore, crop it so it does fit before placing
			else
			{
				// Get the remaining width and height for this spritenode
				CGFloat remainingWidth = MIN(self.contentSize.width - x, textureSize.width);
				CGFloat remainingHeight = MIN(self.contentSize.height - (self.contentSize.height - y), textureSize.height);
				
				// Create a node with the cropped size
				sprite = [CCSprite spriteWithTexture:self.texture rect:CGRectMake(0, 0, remainingWidth, remainingHeight)];
			}
			
			// And add the sprite on the correct position
			sprite.position = CGPointMake(xPosition, yPosition);

			// The anchor point is top left, since we start from topleft in the loop too
			sprite.anchorPoint = CGPointMake(0, 1);
			[self.batchNode addChild:sprite];
			
			// We have an extra child!
			numberOfChilds++;
		}
	}

	// No need to create the CGImage if there is only one child it would not be faster
	if(numberOfChilds == 1)
	{
		// Add the batchNode as a child
		[self addChild:self.batchNode];
	}
	// It would be faster to create the CGImage
	else
	{
		self.renderTexture.anchorPoint = CGPointMake(0, 0);

		// Create a rendertexture with the correct size
		self.renderTexture = [CCRenderTexture renderTextureWithWidth:self.contentSizeInPoints.width height:self.contentSizeInPoints.height];
		[self.renderTexture addChild:self.batchNode];
		
		// Render the nodes offscreen in the renderTexture
		[self.renderTexture begin];
		for(CCNode *child in self.renderTexture.children)
		{
			[child visit];
		}
		[self.renderTexture end];
		
		// Create a texture from the rendertexture's CGImage
		CCTexture *texture = [[CCTexture alloc] initWithCGImage:[self.renderTexture newCGImage] contentScale:[[UIScreen mainScreen] scale]];
		
		// Create the sprite node for the texture and add to self so it is displayed
		CCSprite *spriteNode = [CCSprite spriteWithTexture:texture];
		
		spriteNode.anchorPoint = CGPointMake(0, 0);
		[self addChild:spriteNode];
		
		// Cleaning up a bit
		self.batchNode = nil;
		self.renderTexture = nil;
	}
}

- (void)clear
{
	for(CCNode *child in self.children)
	{
		[child removeFromParent];
	}
}

@end
