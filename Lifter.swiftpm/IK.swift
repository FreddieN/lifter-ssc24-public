//
//  IK.swift
//  Denavit–Hartenberg
//
//  Created by Freddie Nicholson on 17/01/2024.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit

private struct RealityKitView: UIViewRepresentable {
    @Binding var l1a: Float
    @Binding var l2a: Float
    @Binding var l3a: Float
    @Binding var l4a: Float
    @Binding var l5a: Float
    @Binding var l6a: Float

   

    func makeUIView(context: Context) -> ARView {
        let view = ARView(frame: CGRect.zero,
                                 cameraMode: .nonAR,
                                 automaticallyConfigureSession: false)
             view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.environment.background = .color(.white)
        
        let camera = PerspectiveCamera()
                camera.camera.fieldOfViewInDegrees = 60
                
                let cameraAnchor = AnchorEntity(world: .zero)
                cameraAnchor.addChild(camera)
        
                view.scene.addAnchor(cameraAnchor)

        
        camera.look(at: SIMD3(0,0.2,0), from: SIMD3(0,0.2,0.4), relativeTo: nil)
        
        let joints: [SIMD3<Float>] = [SIMD3(0,0.064,0),SIMD3(0.080028,-0.009,0.065981),SIMD3(0.0,-0.005,0.129936),SIMD3(0.133807,0.024,0.0),SIMD3(0.036193,0.017,0.0)]
        

        if let modelEntity = try? Entity.load(named: "ActuatorTestWithOrigins.usdz") {
            let anchor1 = AnchorEntity(world:.zero)
            anchor1.addChild(modelEntity)
            view.scene.addAnchor(anchor1)

        }

        
        
       return view
    }

    func updateUIView(_ view: ARView, context: Context) {
        var relative_positions="""
        Relative Joint Positions:
        
        """
        
        var d1:Float = 0
        var d2:Float = 0
        var d4:Float = 0
        var d6:Float = 0
        var a1:Float = 0
        var a2:Float = 0
        
        var linkangles: [Float] = [0,0,0,0,0,0]
            
        
        let base = view.scene.findEntity(named: "base")
        if let base {
        }
        let l1 = view.scene.findEntity(named: "link1a")
        
        if let l1 {
        }
        
        let l2 = view.scene.findEntity(named: "link2a")

        if let l2 {
            d1 = l2.position(relativeTo: base)[1]
            a1 = l2.position(relativeTo: l1)[0]
        }
        let l3 = view.scene.findEntity(named: "link3a")
        
        if let l3 {
                a2 = l3.position(relativeTo: l2)[1]

        }
        let l4 = view.scene.findEntity(named: "link4a")
        
        if let l4 {
                d2 = l4.position(relativeTo: l1)[2]

        }
        let l5 = view.scene.findEntity(named: "link5a")
        
        if let l5 {

            d4 = l5.position(relativeTo: l3)[0]
        }
        let l6 = view.scene.findEntity(named: "link6ag")
        if let l6 {
            
        }

        let attachment = view.scene.findEntity(named: "attachment")
        if let attachment {
            d6 = attachment.position(relativeTo: l5)[0]
        }
        if let attachment {
        }

        linkangles = iksolver.solveIKDiffSolutions(desx: l1a, desy:l2a, desz:l3a, d1: d1, d2:d2, d4: d4, d6: d6, a1: a1, a2: a2,roll:l6a,pitch:l4a,yaw:l5a,shoulder:false,elbow:true,wrist:true)
        l1?.setOrientation(simd_quatf(angle: (linkangles[0]*(Float.pi))/180, axis: [0, 1, 0]), relativeTo: nil)
        l2?.setOrientation(simd_quatf(angle: (linkangles[1]*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l1)
        l3?.setOrientation(simd_quatf(angle: (linkangles[2]*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l2)
        l4?.setOrientation(simd_quatf(angle: (linkangles[3]*(Float.pi))/180, axis: [1, 0, 0]),relativeTo: l3)
        l5?.setOrientation(simd_quatf(angle: (linkangles[4]*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l4)
        l6?.setOrientation(simd_quatf(angle: ((linkangles[5])*(Float.pi))/180, axis: [1, 0, 0]),relativeTo: l5)
        
       
        let visualBall = view.scene.findEntity(named: "Football")
        
        let q1: Float = linkangles[0]
        let q2: Float = linkangles[1]
        let q3: Float = linkangles[2]
        let q4: Float = linkangles[3]
        let q5: Float = linkangles[4]
        let q6: Float = linkangles[5]
        
        
        var sixDofRobotDH: [fksolver.dh_row] = []
        sixDofRobotDH.append(fksolver.dh_row(q: q1, d: d1, a: a1, alpha: 90))
        sixDofRobotDH.append(fksolver.dh_row(q: q2+90, d: d2, a: a2, alpha: 0))
        sixDofRobotDH.append(fksolver.dh_row(q: q3, d: 0, a: 0, alpha: 90))
        sixDofRobotDH.append(fksolver.dh_row(q: q4, d: d4, a: 0, alpha: -90))
        sixDofRobotDH.append(fksolver.dh_row(q: q5, d: 0, a: 0, alpha: 90))
        sixDofRobotDH.append(fksolver.dh_row(q: q6, d: d6, a: 0, alpha: 0))

        
        let targetcoords = fksolver.solveFK2(dh:sixDofRobotDH,to:6)
        visualBall?.setPosition(targetcoords, relativeTo: base)

        
    }
    
}

struct IK: View {
    @State private var l1a: Float = 0.25
    @State private var l2a: Float = 0.25
    @State private var l3a: Float = 0
    @State private var l4a: Float = 0
    @State private var l5a: Float = 0
    @State private var l6a: Float = 0

    @State private var isEditing = false

    
    var body: some View {
        VStack {
            
            RealityKitView(l1a: $l1a, l2a: $l2a, l3a: $l3a, l4a: $l4a, l5a:$l5a, l6a: $l6a).ignoresSafeArea()
            VStack() {
                HStack() {
                    Text("X").padding()
                    Slider(
                                value: $l1a,
                                in: -0.4...0.4,
                                onEditingChanged: { editing in
                                    isEditing = editing
                                }
                            )
                            Text("\(l1a)")
                                .foregroundColor(isEditing ? .red : .blue)
                }.padding()
                HStack() {
                    Text("Y").padding()
                    Slider(
                                value: $l2a,
                                in: 0...0.4,
                                onEditingChanged: { editing in
                                    isEditing = editing
                                }
                            )
                            Text("\(l2a)")
                                .foregroundColor(isEditing ? .red : .blue)
                }.padding()
                HStack() {
                    Text("Z").padding()
                    Slider(
                                value: $l3a,
                                in: -0.25...0.4,
                                onEditingChanged: { editing in
                                    isEditing = editing
                                }
                            )
                            Text("\(l3a)")
                                .foregroundColor(isEditing ? .red : .blue)
                }.padding()
                HStack() {
                    Text("F").padding()
                    Slider(
                                value: $l4a,
                                in: -180...180,
                                onEditingChanged: { editing in
                                    isEditing = editing
                                }
                            )
                            Text("\(l4a)")
                                .foregroundColor(isEditing ? .red : .blue)
                }.padding()
                HStack() {
                    Text("R").padding()
                    Slider(
                                value: $l5a,
                                in: -180...180,
                                onEditingChanged: { editing in
                                    isEditing = editing
                                }
                            )
                            Text("\(l5a)")
                                .foregroundColor(isEditing ? .red : .blue)
                }.padding()
                HStack() {
                    Text("E").padding()
                    Slider(
                                value: $l6a,
                                in: -180...180,
                                onEditingChanged: { editing in
                                    isEditing = editing
                                }
                            )
                            Text("\(l6a)")
                                .foregroundColor(isEditing ? .red : .blue)
                }.padding()
                
            }
        }
    }
}


