 # lifter-ssc24-public
My app playground is all about learning the science behind how robots move! The activity will lead you through the basics of robot arms, convention engineers use, forward kinematics and inverse kinematics. In addition there is an Augmented Reality minigame BalloonPop that allows you to put all you have learned into action!

The app playground is built using SwiftUI for the interface using standard components. I used Autodesk Fusion 360 to design a CAD model of my own robot arm (based off standard design patterns) that is used for the learning sequences. I then composed this into a USDZ using Reality Composer Pro (released at WWDC23). RealityKit is used for the vast majority of 3D elements including the minigame. SceneKit is used for the elements that require .allowsCameraControl. ARKit is used for the minigame and combined with RealityKit gives intricate detail such as shadows and occlusion making a realistic robot simulation. I used Blender to create the balloon pop animation in the minigame. 

The Accelerate framework was used for performing the complex mathematics required to calculate the various joint angles, robot arm positions and orientations in rapid time on iPad. 


More about the Swift Student Challenge: https://developer.apple.com/swift-student-challenge/

## Demo Video

[![Demo Video](https://img.youtube.com/vi/OpXI9ef8jg8/0.jpg)](https://youtu.be/OpXI9ef8jg8)
