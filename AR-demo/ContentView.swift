import SwiftUI
import RealityKit
import ARKit
import Combine

struct ContentView: View {
    @StateObject private var viewModel = ARViewModel()
    
    var body: some View {
        ZStack {
            ARViewContainer(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                if viewModel.isModelPlaced {
                    VStack {
                        Slider(value: $viewModel.modelScale, in: 0.1...2.0, step: 0.1) {
                            Text("Scale")
                        }
                        
                        Button("Delete") {
                            viewModel.deleteModel()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .padding()
                }
            }
        }
    }
}

class ARViewModel: ObservableObject {
    @Published var isModelPlaced = false
    @Published var modelScale: Float = 1.0 {
        didSet {
            updateModelScale()
        }
    }
    
    var anchorEntity: AnchorEntity?
    
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
    
    func updateModelScale() {
        guard let anchorEntity = anchorEntity else { return }
        anchorEntity.scale = [modelScale, modelScale, modelScale]
    }
    
    
    func deleteModel() {
        guard let anchorEntity = anchorEntity else { return }
        anchorEntity.removeFromParent()
        self.anchorEntity = nil
        isModelPlaced = false
    }
}

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard let arView = recognizer.view as? ARView else { return }
            let location = recognizer.location(in: arView)
            
            let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
            
            if let firstResult = results.first, !parent.viewModel.isModelPlaced {
                parent.viewModel.placeModel(in: arView, at: firstResult)
            }
        }
    }
}

#Preview {
    ContentView()
}
