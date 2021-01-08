# Deformable Snow for Unity -- PIGSquad Stream Repo

Workshop streamed on: https://www.twitch.tv/pigsquad!

![preview](http://i.imgur.com/VytQ4n0.png)

A straightforward technique for rendering deformable snow in limited areas based off of http://www.gdcvault.com/play/1020177/Deformable-Snow-Rendering-in-Batman

### Summary:

* An orthographic camera with a short clipping plane captures depth without clearing its buffer.

* A shader for snow reads the depth texture and creates imprints in its tessellated surface.

* Snow is refreshed by using a screen effect which constantly darkens the imprint buffer.

### Notes:
This specific implimentation is for flat fixed areas! It can be reconfigured to different aspect ratios but doesn't work outside its volume. It's possible to extend though!

In [That Blooming Feeling](https://totsteam.itch.io/thatbloomingfeeling) I used a similar technique in world space that follows the camera and has the environment responding to the buffer (animating / recoiling / +). It's based off of Naughty Dog's method they use for vehicle damage, foliage interaction, +. They have some good notes on this lower down in this talk! http://advances.realtimerendering.com/other/2016/naughty_dog/index.html 

If this doesn't work on your machine out of the box double check you're using OpenGLCore or DX11+ in your Unity project. Tessellation is only supported on more recent graphics APIs.

Cheers,

Holly Newlands

@thnewlands
