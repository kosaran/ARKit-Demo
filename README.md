# SwiftUI ARKit 3D Model Placement

## Overview

This iOS app uses SwiftUI and RealityKit to create an AR experience where users can place, scale, and delete a 3D model in their environment. The app utilizes ARKit for plane detection and model placement.

## Features

- **3D Model Placement**: Place a 3D model (medical cart) in the real world using AR.
- **Model Scaling**: Resize the placed 3D model using a slider.
- **Model Deletion**: Remove the placed model from the scene.
- **Horizontal Plane Detection**: Automatically detect horizontal surfaces for model placement.

## Requirements

- iOS 15.0+
- Xcode 13.0+
- iPhone or iPad with ARKit support

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/swiftui-arkit-project.git
   ```
2. Open the project in Xcode:
   ```
   cd swiftui-arkit-project
   open SwiftUIARKitProject.xcodeproj
   ```
3. Select your target device.
4. Build and run the project (Cmd + R).

## Usage

1. **Launch the App**: Open the app on your ARKit-compatible iOS device.
2. **Scan the Environment**: Move your device around to let ARKit detect horizontal planes.
3. **Place the Model**: Tap on a detected horizontal surface to place the medical cart model.
4. **Resize Model**: Use the slider at the bottom of the screen to resize the placed model.
5. **Delete Model**: Tap the "Delete" button to remove the placed model from the scene.

## Code Structure

- `ContentView.swift`: Main SwiftUI view containing the AR view and user interface elements.
- `ARViewModel.swift`: View model managing the AR functionality and model manipulation.
- `ARViewContainer.swift`: UIViewRepresentable wrapper for ARView to use it in SwiftUI.

## Key Components

### ARKit Configuration

```swift
let config = ARWorldTrackingConfiguration()
config.planeDetection = [.horizontal]
arView.session.run(config)
```

### Model Placement

```swift
func placeModel(in arView: ARView, at result: ARRaycastResult) {
    let modelName = "medical_cart_1"
    
    do {
        let loadedEntity = try Entity.load(named: modelName)
        let anchorEntity = AnchorEntity(world: result.worldTransform)
        anchorEntity.addChild(loadedEntity)
        arView.scene.addAnchor(anchorEntity)
        self.anchorEntity = anchorEntity
        isModelPlaced = true
    } catch {
        print("Failed to load model: \(error.localizedDescription)")
    }
}
```

### Model Scaling

```swift
func updateModelScale() {
    guard let anchorEntity = anchorEntity else { return }
    anchorEntity.scale = [modelScale, modelScale, modelScale]
}
```

### Model Deletion

```swift
func deleteModel() {
    guard let anchorEntity = anchorEntity else { return }
    anchorEntity.removeFromParent()
    self.anchorEntity = nil
    isModelPlaced = false
}
```

## Customization

To use a different 3D model:
1. Add your custom .usdz model to the project's asset catalog.
2. Update the `modelName` in the `placeModel` function of `ARViewModel`.

## Troubleshooting

- Ensure your device supports ARKit and runs iOS 15.0 or later.
- For optimal performance, use the app in a well-lit environment with distinct features or textures.
- If plane detection is slow, try moving the device to scan more of the environment.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

- Apple's SwiftUI, ARKit, and RealityKit documentation
- [Insert any third-party libraries or resources used]

## Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter) - email@example.com

Project Link: [https://github.com/yourusername/swiftui-arkit-project](https://github.com/yourusername/swiftui-arkit-project)
