# TiledSprite
An easy way to get repeated textures in Cocos2D v3. 

## Usage
Include the TiledSprite.h and .m file in your Cocos2D project. And create a sprite like this:

```
CCTexture *texture = [CCTexture textureWithFile:@"path/forTexture.png"];
TiledSprite *tiledSprite = [TiledSprite tiledSpriteWithTexture:texture rect:CGRectMake(100, 100, 200, 200); 
```

Easy as Pie!