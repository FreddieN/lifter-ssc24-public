//
//  MultipleRobotRenderTest.swift
//  Denavit–Hartenberg
//
//  Created by Freddie Nicholson on 21/01/2024.
//

import SwiftUI
import ARKit
import RealityKit

private var d1:Float = 0.1297723
private var d2:Float = -0.009669061
private var d4:Float = 0.17012408
private var d6:Float = 0.03590011
private var a1:Float = 0.0800327
private var a2:Float = 0.12861885


private struct RealityKitView: UIViewRepresentable {
    @Binding var l1a: Float
    @Binding var l2a: Float
    @Binding var l3a: Float
    @Binding var l4a: Float
    @Binding var l5a: Float
    @Binding var l6a: Float
    var shoulder: Bool
    var elbow: Bool
    var wrist: Bool
    var operating_mode: Bool = true


    func calcFinalTransformationMatrix() -> [Float] {
        if operating_mode {
            //world
            var Tmatrix = iksolver.getTransformMatrix(desx: l1a, desy: l2a, desz: l3a, roll: l4a, pitch: l5a, yaw: l6a)
            return Tmatrix
        } else {
            //joint
            var sixDofRobotDH: [fksolver.dh_row] = []
            sixDofRobotDH.append(fksolver.dh_row(q: l1a, d: d1, a: a1, alpha: 90))
            sixDofRobotDH.append(fksolver.dh_row(q: l2a+90, d: d2, a: a2, alpha: 0))
            sixDofRobotDH.append(fksolver.dh_row(q: l3a, d: 0, a: 0, alpha: 90))
            sixDofRobotDH.append(fksolver.dh_row(q: l4a, d: d4, a: 0, alpha: -90))
            sixDofRobotDH.append(fksolver.dh_row(q: l5a, d: 0, a: 0, alpha: 90))
            sixDofRobotDH.append(fksolver.dh_row(q: l6a, d: d6, a: 0, alpha: 0))
            var Tmatrix = fksolver.solveFK3(dh: sixDofRobotDH)
            return Tmatrix
            }
    }
    
    
    func makeUIView(context: Context) -> ARView {
        let view = ARView(frame: CGRect.zero,
                                 cameraMode: .nonAR,
                                 automaticallyConfigureSession: false)
             view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.environment.background = .color(.systemGray6)
        
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
        if let modelEntity = try? Entity.load(named: "football.usdz") {
            modelEntity.name = "Football"
            let anchor1 = AnchorEntity(world:.zero)
            anchor1.position = SIMD3(0,0,0)
            anchor1.addChild(modelEntity)
            view.scene.addAnchor(anchor1)
            modelEntity.setScale(SIMD3(0.1,0.1,0.1), relativeTo: nil)
        }

       return view
    }

    func updateUIView(_ view: ARView, context: Context) {
        var relative_positions="""
        Relative Joint Positions:
        
        """
        
    
        
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
    

        
        
        linkangles = iksolver.solveIKDiffSolutions(desx: l1a, desy:l2a, desz:l3a, d1: d1, d2:d2, d4: d4, d6: d6, a1: a1, a2: a2,roll:l6a,pitch:l4a,yaw:l5a,shoulder:shoulder,elbow:elbow,wrist:wrist)
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

    let inputcoords = [l1a, l2a, l3a]
    let distance_between_target_and_input = sqrt(( pow((targetcoords[0]-inputcoords[0]),2)+pow((targetcoords[1]-inputcoords[1]),2)+pow((targetcoords[2]-inputcoords[2]),2) ))

    
    if distance_between_target_and_input > 0.1 || distance_between_target_and_input.isNaN {
} else {

        l1?.setOrientation(simd_quatf(angle: (linkangles[0]*(Float.pi))/180, axis: [0, 1, 0]), relativeTo: nil)
        l2?.setOrientation(simd_quatf(angle: (linkangles[1]*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l1)
        l3?.setOrientation(simd_quatf(angle: (linkangles[2]*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l2)
        l4?.setOrientation(simd_quatf(angle: ((linkangles[3])*(Float.pi))/180, axis: [1, 0, 0]),relativeTo: l3)
        l5?.setOrientation(simd_quatf(angle: ((linkangles[4])*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l4)
        l6?.setOrientation(simd_quatf(angle: ((linkangles[5])*(Float.pi))/180, axis: [1, 0, 0]),relativeTo: l5)
        
       

}
        
}
    
}

struct MultipleRobotRenderTest: View {
 
    var shoulder: Bool
    var elbow: Bool
    var wrist: Bool
    var solNo: Int
    @Binding var l1a: Float
    @Binding var l2a: Float
    @Binding var l3a: Float
    @Binding var l4a: Float
    @Binding var l5a: Float
    @Binding var l6a: Float
    
    @State var loaded: Bool = true
    
    var body: some View {
        VStack {
            VStack {
                if(loaded) {
                    RealityKitView(l1a: $l1a, l2a: $l2a, l3a: $l3a, l4a: $l4a, l5a: $l5a, l6a: $l6a,shoulder:shoulder, elbow:elbow,wrist:wrist).frame(width:200, height:150)
                } else {
                    ProgressView().onAppear(perform: {
                        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                            loaded = true
                        }
                    })
                }
                Text("Solution \(solNo)").padding(.top).font(.subheadline).fontWeight(.bold)
                Text("Shoulder: \(shoulder ? "Forwards" : "Backwards")")
                Text("Elbow: \(elbow ? "Up" : "Down")")
                Text("Wrist: \(wrist ? "Up" : "Down")")
            }.padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)

            
            
        }.padding(15)
    }
}


