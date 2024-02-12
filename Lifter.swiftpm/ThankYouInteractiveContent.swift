//
//  ThankYouInteractiveContent.swift
//  Lifter
//
//  Created by Freddie Nicholson on 05/02/2024.
//

//
//  DenavitHartenbergInteractiveContent.swift
//  Lifter
//
//  Created by Freddie Nicholson on 31/01/2024.
//

import SwiftUI
import SceneKit



private struct SceneKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> SCNView {
           let sceneView = SCNView()
           sceneView.scene = createScene()
           sceneView.autoenablesDefaultLighting = true
           sceneView.allowsCameraControl = true

           return sceneView
       }
    
   func updateUIView(_ uiView: SCNView, context: Context) {
        }

        private func createScene() -> SCNScene {
            let scene = SCNScene()
            
            let universe = scene.rootNode
           let camera = SCNCamera()
            camera.zNear = 0.01
           let observer = SCNNode()
           observer.camera = camera
            observer.position = SCNVector3(x: 0.05, y: 0.175, z: 0.5)
           universe.addChildNode(observer)
            
            if let usdzURL = Bundle.main.url(forResource: "ActuatorTestWithOriginsEndCredit", withExtension: "usdz") {
                    let usdzNode = SCNReferenceNode(url: usdzURL)
                    usdzNode?.load()
                    
                usdzNode?.position = SCNVector3(0.15, 0, 0)

                    scene.rootNode.addChildNode(usdzNode!)
                }
            
            if let usdzURL = Bundle.main.url(forResource: "RedBalloon", withExtension: "usdz") {
                    let usdzNode = SCNReferenceNode(url: usdzURL)
                    usdzNode?.load()
                
                usdzNode?.position = SCNVector3(0.15, 0.25, 0.15)

                    scene.rootNode.addChildNode(usdzNode!)
                
                let am1 = SCNAction.move(to: SCNVector3(x: 0.15, y: 0.25, z: 0.15), duration: 2.4)
                let am2 = SCNAction.move(to: SCNVector3(x: 0.15, y: 0.26, z: 0.15), duration: 2.4)
                am1.timingMode = .easeInEaseOut
                am2.timingMode = .easeInEaseOut
                var animSequence: [SCNAction] = [am1,am2]
                let sequence = SCNAction.sequence(animSequence)
                let loop = SCNAction.repeatForever(sequence)
                usdzNode?.runAction(loop)
                }
            
            if let usdzURL = Bundle.main.url(forResource: "YellowBalloon", withExtension: "usdz") {
                    let usdzNode = SCNReferenceNode(url: usdzURL)
                    usdzNode?.load()
                    
                usdzNode?.position = SCNVector3(0, 0.35, -0.05)

                    scene.rootNode.addChildNode(usdzNode!)
                let am1 = SCNAction.move(to: SCNVector3(x: 0, y: 0.35, z: -0.05), duration: 2.4)
                let am2 = SCNAction.move(to: SCNVector3(x: 0, y: 0.36, z: -0.05), duration: 2.4)
                am1.timingMode = .easeInEaseOut
                am2.timingMode = .easeInEaseOut
                var animSequence: [SCNAction] = [am1,am2]
                let sequence = SCNAction.sequence(animSequence)
                let loop = SCNAction.repeatForever(sequence)
                usdzNode?.runAction(loop)
                }
            
            if let usdzURL = Bundle.main.url(forResource: "GreenBalloon", withExtension: "usdz") {
                    let usdzNode = SCNReferenceNode(url: usdzURL)
                    usdzNode?.load()
                    
                usdzNode?.position = SCNVector3(-0.10, 0.25, 0)

                    scene.rootNode.addChildNode(usdzNode!)
                
                let am1 = SCNAction.move(to: SCNVector3(x: -0.1, y: 0.25, z: 0), duration: 2.4)
                let am2 = SCNAction.move(to: SCNVector3(x: -0.1, y: 0.26, z: 0), duration: 2.4)
                am1.timingMode = .easeInEaseOut
                am2.timingMode = .easeInEaseOut
                var animSequence: [SCNAction] = [am1,am2]
                let sequence = SCNAction.sequence(animSequence)
                let loop = SCNAction.repeatForever(sequence)
                usdzNode?.runAction(loop)
                }
            
            
            

            return scene
        }
    
}


struct ThankYouInteractiveContent: View {


    
    var body: some View {
        
        SceneKitView().ignoresSafeArea()
        
    }
}




