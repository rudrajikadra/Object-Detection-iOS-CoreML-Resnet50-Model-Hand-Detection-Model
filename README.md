# Object-Detection-iOS-CoreML-Resnet50-Model-Hand-Detection-Model
There are two phases of this iOS application, one which has the implementation of Resnet Model (CoreML Model) and also Hand State Detection Model which i made using Custom Vision.
* The Resnet Model is the model you can find online which is a coreml model implemented in the app.
* The other Hand State Detection model is the one i created using my own dataset and creating the model using Custom Vision Api.
Both the models are implemented in this application. 

### How it works
- Give access to the Camera
- The Resnet Model will identify objects that are in front of the camera.
- When you switch the toggle switch it will switch to the Hand Model.
- The hand model will identify the state of the hand in front of the camera i.e. Open Fist, Close Fist or no fist at all.

## Note
* Xcode 9 and Swift 4 was used for this project.
* The CoreML model for the hand detection is included in the project repository.

## How it looks like
(Gif)
