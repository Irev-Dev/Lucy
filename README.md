# Lucy
<img src="https://github.com/Irev-Dev/Lucy/blob/master/Images/IMG_3259.JPG" alt="image1" width="50%" align="left"> 

OpenSCAD/Parametric Miniquad Frame, designed with aggressively tilted body and with flat arms for minimal blockage of the thrust columns. The result is a quad that is most aerodynamic when flown at its most aggressive angle as opposed to most miniquad frames which become less aerodynamic the further forward they are tilted.

Named after [Lucy Gonzalez Parsons](https://www.youtube.com/watch?v=m1AOZlUflgo "More Dangerous Than a Thousand Rioters: The Revolutionary Life of Lucy Parsons") 

The frame is intended to be made from carbonfiber with some printed parts. It's currently being prototyped so contributions are welcome. The frame also has a [thingiverse](https://www.thingiverse.com/thing:2403189) page, though I prefer to colaborate on github.

## Contributing
I thought it was about time I got this code up on github, so I don't have any immediate ideas of ways to contribute. I need to do an initial tidy of the code and then maybe I'll put together a plan of improvements/features that can be done. But by all means contact me with ideas or make a change and make a pull request.

At this stage the frame has not been tested at all, I have quad components arriving soon, I plan on testing it by printing it completely out of PLA (because it's cheap). It will break the first time it's crashed without a doubt, but I think PLA should be rigid and strong enough while in flight. If the frame progresses nicely and I get some carbonfiber cut I'm not sure what filament should be used for the final printed parts. I have some taulman 910 nylon which I think is probably a good mix of tough and rigid, but perhaps PETG or TPU should be used?

## Features
### Parametric
<img src="https://github.com/Irev-Dev/Lucy/blob/master/Images/Capture11.png" width="100%" align="middle">
Most dimensions can be tweaked. The image above for example shows the angle of the body relative to the props varying from 40 to 70 degrees and the distance between the rear props changing from 180 to 130mm.

### Low Drag
This is where I hope this frame will come into it's own. Most quad frames have a elongated body which creates negative lift while flying and creates more drag the more aggressively the quad is flown, while compact frames reduce this somewhat the arms of the quad still block a large amount of the thrust column which is inevitable when the motors are mounted directly to carbon fiber sheet. Lucy Kwad gets around this by having a very aggressively tilted body and tilted motor mounts. The body is tilted further than the camera angle so that during medium speed flight there is some drag but also some positive lift and in top speed flight the frame will be tilt so as to have the least drag. The arms of the quad are tilted at the same angle as the body thanks to the tilted motor mounts.
The image below shows the body tilt at a greater angle than the camera. 70 degrees in the images though this is a guess, testing is needed.

<img src="https://github.com/Irev-Dev/Lucy/blob/master/Images/Capture1b.PNG" width="50%" align="middle">

## Updates

26/06/2017 - Inital commit

<img src="https://github.com/Irev-Dev/Lucy/blob/master/Images/IMG_3237.JPG" alt="image1" width="100%" align="left"> 

28/06/2017 - I have spent the last two nights getting the code ready enough to print for the first (what I hope will be) flyable version. I got motivated when my motors arrived. I will print it out of PLA, it won't last long but hopefully I get an idea of how it will fly. 

30/06/2017 - I have done about 70% of the build for the first prototype. I'm getting excited. I had to put the props on just to see what it looks like, pretty happy with the aesthetics :)
The PLA is definitely worrisome. Because of the design of the quad the arms are still rigid enough in the direction of thrust bit I'm worried about the torque of the motors during fast spool ups. If it expodes when I punch it I just hope it doesn't damage any of the electronics. 

<img src="https://github.com/Irev-Dev/Lucy/blob/master/Images/IMG_3259.JPG" width="510" align="middle">

11/08/2017 - Got back to working on this and finish the electronics for the first prototype, ran into some interesting problems. With the default PID's as soon the quad armed it would start vibrating and would generate enough lift form trying to correct itself that it would start to take off. halving the PID values didn't fix it, and neither did quartering them. Then I tried re-enforcing the arms quickly with some balsa wood (as shown below) and now it seems to fly well with halved default PID values. This is the problem with using PLA, I won't be able to tune it properly and therefore see how it will actually fly until I bite the bullet and get it made in carbon fiber. It's been interesting trying to get it to fly though.

I have only done line of sight hovering so far, I hope to take it for a good FPV flight soon.

<img src="https://github.com/Irev-Dev/Lucy/blob/master/Images/IMG_3329.JPG" width="510" align="middle">
