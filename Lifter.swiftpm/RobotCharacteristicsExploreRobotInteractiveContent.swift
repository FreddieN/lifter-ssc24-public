//
//  RobotCharacteristicsExploreRobotInteractiveContent.swift
//  Lifter
//
//  Created by Freddie Nicholson on 04/02/2024.
//

import SwiftUI
import SceneKit

private struct SceneKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> SCNView {
           let sceneView = SCNView()
           sceneView.scene = createScene()
        sceneView.backgroundColor = UIColor(red: CGFloat(50/255.0), green: CGFloat(50/255.0), blue: CGFloat(50/255.0), alpha: CGFloat(1.0))
           sceneView.autoenablesDefaultLighting = true
           sceneView.allowsCameraControl = true
            

           
            let universe = sceneView.scene?.rootNode
           let camera = SCNCamera()
            camera.zNear = 0.01
           let observer = SCNNode()
           observer.camera = camera
        observer.position = SCNVector3(x: 0.4, y: 0.4, z: 0.4)
        observer.look(at: SCNVector3(0.1,0.1,0))
           universe?.addChildNode(observer)
        
           return sceneView
       }
    
   func updateUIView(_ uiView: SCNView, context: Context) {
        }

        private func createScene() -> SCNScene {
            let scene = SCNScene()

            if let usdzURL = Bundle.main.url(forResource: "ActuatorTestWithOrigins", withExtension: "usdz") {
                    let usdzNode = SCNReferenceNode(url: usdzURL)
                    usdzNode?.load()
                    
                    usdzNode?.position = SCNVector3(0, 0, 0)

                    scene.rootNode.addChildNode(usdzNode!)
                }
            
            let floorObject = SCNFloor()
              floorObject.reflectivity = 0.1
              floorObject.firstMaterial!.diffuse.contents = UIColor(red: CGFloat(204/255.0), green: CGFloat(204/255.0), blue: CGFloat(204/255.0), alpha: CGFloat(1.0))
              let floor = SCNNode(geometry: floorObject)
            scene.rootNode.addChildNode(floor)
              floor.position = SCNVector3(x:0,y:0,z:0)
            
            let light3 = SCNLight()
                light3.type = .spot
                light3.intensity=200
                let torch3 = SCNNode()
                torch3.light = light3
            torch3.position = SCNVector3(x: 0, y: 20, z: 0)
            scene.rootNode.addChildNode(torch3)
            torch3.look(at:SCNVector3(0,0,0))
            
            

            return scene
        }
    
}


struct RobotCharacteristicsExploreRobotInteractiveContent: View {


    
    var body: some View {
        
        SceneKitView().ignoresSafeArea()
        
    }
}



