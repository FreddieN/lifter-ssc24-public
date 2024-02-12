//
//  DenavitHartenbergInteractiveContent.swift
//  Lifter
//
//  Created by Freddie Nicholson on 31/01/2024.
//

import SwiftUI
import SceneKit



private struct SceneKitView: UIViewRepresentable {
    var l1a: Float = 0
    var l2a: Float = 0
    var l3a: Float = 0
    var l4a: Float = 0
    var l5a: Float = 0
    var l6a: Float = 0
    
    func makeUIView(context: Context) -> SCNView {
           let sceneView = SCNView()
           sceneView.scene = createScene()
        sceneView.backgroundColor = UIColor(red: CGFloat(50/255.0), green: CGFloat(50/255.0), blue: CGFloat(50/255.0), alpha: CGFloat(1.0))
           sceneView.autoenablesDefaultLighting = true
           sceneView.allowsCameraControl = true
            

        
           return sceneView
       }
    
   func updateUIView(_ uiView: SCNView, context: Context) {
            // Update the view here if needed
        }

        private func createScene() -> SCNScene {
            let scene = SCNScene()
            
            let universe = scene.rootNode
           let camera = SCNCamera()
            camera.zNear = 0.01
           let observer = SCNNode()
           observer.camera = camera
        observer.position = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
        observer.look(at: SCNVector3(0.1,0.1,0))
           universe.addChildNode(observer)
            
            if let usdzURL = Bundle.main.url(forResource: "DHVisual", withExtension: "usdz") {
                    let usdzNode = SCNReferenceNode(url: usdzURL)
                    usdzNode?.load()
                    
                    usdzNode?.position = SCNVector3(0, 0, 0)

                    scene.rootNode.addChildNode(usdzNode!)
                }
            
            var d1:Float = 0.12977232
            var d2:Float = -0.009669051
            var d4:Float = 0.17012408
            var d6:Float = 0.035900116
            var a1:Float = 0.080032706
            var a2:Float = 0.12861885


            var sixDofRobotDH: [fksolver.dh_row] = []
            sixDofRobotDH.append(fksolver.dh_row(q: l1a, d: d1, a: a1, alpha: 90))
            sixDofRobotDH.append(fksolver.dh_row(q: l2a+90, d: d2, a: a2, alpha: 0))
            sixDofRobotDH.append(fksolver.dh_row(q: l3a, d: 0, a: 0, alpha: 90))
            sixDofRobotDH.append(fksolver.dh_row(q: l4a, d: d4, a: 0, alpha: -90))
            sixDofRobotDH.append(fksolver.dh_row(q: l5a, d: 0, a: 0, alpha: 90))
            sixDofRobotDH.append(fksolver.dh_row(q: l6a, d: d6, a: 0, alpha: 0))

          
            for (index, row) in sixDofRobotDH.enumerated() {
                if let usdzURL = Bundle.main.url(forResource: "Ref Frame", withExtension: "usdz") {
                    let finalmatrix = fksolver.solveFK3(dh:sixDofRobotDH,to:index)
                    
                   
                    var rotmatrix: simd_float3x3 = simd_float3x3.init(rows: [[finalmatrix[0],finalmatrix[1],finalmatrix[2]],
                                                                             [finalmatrix[4],finalmatrix[5],finalmatrix[6]],
                                                                             [finalmatrix[8],finalmatrix[9],finalmatrix[10]]])

                    
                    let usdzNode = SCNReferenceNode(url: usdzURL)
                        usdzNode?.load()
                        
                        usdzNode?.position = SCNVector3(finalmatrix[3],finalmatrix[7],finalmatrix[11])
                    usdzNode?.simdOrientation = simd_quatf(rotmatrix)
                    usdzNode?.scale = SCNVector3(0.05, 0.05, 0.05)
                        scene.rootNode.addChildNode(usdzNode!)
                    
                    if let usdzURL1 = Bundle.main.url(forResource: "JointCylinder", withExtension: "usdz") {
                        let usdzNode1 = SCNReferenceNode(url: usdzURL1)
                            usdzNode1?.load()
                            
                            usdzNode1?.position = SCNVector3(finalmatrix[3],finalmatrix[7],finalmatrix[11])
                        usdzNode1?.simdOrientation = simd_quatf(rotmatrix)
                        scene.rootNode.addChildNode(usdzNode1!)
                    }
                }
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


struct DenavitHartenbergInteractiveContent: View {


    
    var body: some View {
        
        SceneKitView().ignoresSafeArea()
        
    }
}



