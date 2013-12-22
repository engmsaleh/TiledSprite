# TiledSprite
An easy way to get repeated textures in Cocos2D v3. 

## Usage
Include the TiledSprite.h and .m file in your Cocos2D project. And create a sprite like this:

```
// Get the current screen size
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	
	// Load the repeated pattern as a texture
	CCTexture *pattern = [CCTexture textureWithFile:@"example/pattern.png"];
	
	// Adn create the tiledsprite with the full screen size
	TiledSprite *tiledSprite = [TiledSprite tileSpriteWithTexture:pattern rect:CGRectMake(0, 0, screenSize.width, screenSize.height)];
	
	// And add to the scene
	[self addChild:tiledSprite];
```

## Example

### The pattern
![pattern](https://raw.github.com/Matthijn/TiledSprite/master/pattern.png)

_Pattern generated with: http://bg.siteorigin.com_

### Result
[![Simulator Screenshot](https://raw.github.com/Matthijn/TiledSprite/master/screenshot_small.png)](https://raw.github.com/Matthijn/TiledSprite/master/screenshot.png)

Easy as Pie!
