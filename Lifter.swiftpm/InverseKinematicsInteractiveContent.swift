//
//  InverseKinematicsInteractiveContent.swift
//  Lifter
//
//  Created by Freddie Nicholson on 30/01/2024.
//

import SwiftUI
import ARKit
import RealityKit
import Combine

private var d1:Float = 0.1297723
private var d2:Float = -0.009669061
private var d4:Float = 0.17012408
private var d6:Float = 0.03590011
private var a1:Float = 0.0800327
private var a2:Float = 0.12861885
private let angleChangeEvent = PassthroughSubject<Bool, Never>()
private let outOfBounds = PassthroughSubject<Bool, Never>()
private var lastKnownGood: [Float] = [0.18,0.25,0,0,0,0]

private struct RealityKitView: UIViewRepresentable {
    @Binding var l1a: Float
    @Binding var l2a: Float
    @Binding var l3a: Float
    @Binding var l4a: Float
    @Binding var l5a: Float
    @Binding var l6a: Float
    @Binding var operating_mode: Bool
    @Binding var prev_operating_mode: Bool

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
        
        view.environment.background = .color(.white)
        
        let camera = PerspectiveCamera()
                camera.camera.fieldOfViewInDegrees = 60
                
                let cameraAnchor = AnchorEntity(world: .zero)
                cameraAnchor.addChild(camera)
        
                view.scene.addAnchor(cameraAnchor)

        
        camera.look(at: SIMD3(0,0.2,0), from: SIMD3(0,0.2,0.6), relativeTo: nil)
        
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
        outOfBounds.send(true)
        
    } else {
  
            l1?.setOrientation(simd_quatf(angle: (linkangles[0]*(Float.pi))/180, axis: [0, 1, 0]), relativeTo: nil)
            l2?.setOrientation(simd_quatf(angle: (linkangles[1]*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l1)
            l3?.setOrientation(simd_quatf(angle: (linkangles[2]*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l2)
            l4?.setOrientation(simd_quatf(angle: ((linkangles[3])*(Float.pi))/180, axis: [1, 0, 0]),relativeTo: l3)
            l5?.setOrientation(simd_quatf(angle: ((linkangles[4])*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l4)
            l6?.setOrientation(simd_quatf(angle: ((linkangles[5])*(Float.pi))/180, axis: [1, 0, 0]),relativeTo: l5)
            
        angleChangeEvent.send(true)
        outOfBounds.send(false)
        lastKnownGood = [l1a,l2a,l3a,l4a,l5a,l6a]
    }
            
    }
}

 struct InverseKinematicsInteractiveContent: View {
     @State private var l1a: Float = 0.18
     @State private var l2a: Float = 0.25
    @State private var l3a: Float = 0
    @State private var l4a: Float = 0
    @State private var l5a: Float = 0
    @State private var l6a: Float = 0
    @State private var operating_mode: Bool = true
    @State private var prev_operating_mode: Bool = true
    @State private var isEditing = false
    @State private var loaded = true
     @State private var q1disp: Float = 0
     @State private var q2disp: Float = 0
    @State private var q3disp: Float = 0
    @State private var q4disp: Float = 0
    @State private var q5disp: Float = 0
    @State private var q6disp: Float = 0
     @State private var outOfBoundsDisp: Bool = false

    var current_transform: [Float] = []
    
     func updateDisp() {
         var sixDofRobotDH: [fksolver.dh_row] = []
         sixDofRobotDH.append(fksolver.dh_row(q: l1a, d: d1, a: a1, alpha: 90))
         sixDofRobotDH.append(fksolver.dh_row(q: l2a+90, d: d2, a: a2, alpha: 0))
         sixDofRobotDH.append(fksolver.dh_row(q: l3a, d: 0, a: 0, alpha: 90))
         sixDofRobotDH.append(fksolver.dh_row(q: l4a, d: d4, a: 0, alpha: -90))
         sixDofRobotDH.append(fksolver.dh_row(q: l5a, d: 0, a: 0, alpha: 90))
         sixDofRobotDH.append(fksolver.dh_row(q: l6a, d: d6, a: 0, alpha: 0))


         let linkangles = iksolver.solveIKDiffSolutions(desx: l1a, desy:l2a, desz:l3a, d1: d1, d2:d2, d4: d4, d6: d6, a1: a1, a2: a2,roll:l6a,pitch:l4a,yaw:l5a,shoulder:false,elbow:true,wrist:true)
         q1disp = linkangles[0]
         q2disp = linkangles[1]
         q3disp = linkangles[2]
         q4disp = linkangles[3]
         q5disp = linkangles[4]
         q6disp = linkangles[5]
     }
     
    var body: some View {
        VStack {
            if(loaded) {
                RealityKitView(l1a: $l1a, l2a: $l2a, l3a: $l3a, l4a: $l4a, l5a: $l5a, l6a: $l6a, operating_mode: $operating_mode, prev_operating_mode: $prev_operating_mode).ignoresSafeArea().onAppear(perform: {
                    updateDisp()
                })
            }
        
            
            VStack() {
                Text("Inverse Kinematics Joint Angles").onReceive(outOfBounds, perform: { isOutOfBounds in
                    outOfBoundsDisp = isOutOfBounds
                })
                if(!outOfBoundsDisp) {
                    Text("""
 q1: \(String(format: "%.2f", q1disp)) q2: \(String(format: "%.2f", q2disp)) q3: \(String(format: "%.2f", q3disp)) q4: \(String(format: "%.2f", q4disp)) q5: \(String(format: "%.2f", q5disp)) q6: \(String(format: "%.2f", q6disp))
""").onReceive(angleChangeEvent, perform: { _ in
                        updateDisp()}
)
                } else {
                    Text("Out of Bounds for this solution. Return to Workspace.").foregroundStyle(.red).onAppear() {
                        l1a = lastKnownGood[0]
                        l2a = lastKnownGood[1]
                        l3a = lastKnownGood[2]
                        l4a = lastKnownGood[3]
                        l5a = lastKnownGood[4]
                        l6a = lastKnownGood[5]
                    }
                    
                }
                HStack() {
                   
                    Button("Home Position", action: {
                        l1a=0.18
                        l2a=0.25
                        l3a=0
                        l4a=0
                        l5a=0
                        l6a=0
                    }).buttonStyle(.borderedProminent)
                }.padding()
                if(operating_mode == false) {
                    HStack() {
                        TouchControlPlusMinus(value:$l1a,symbolindicator:"1.square.fill",increment:1,min:-0.25,max:0.25)
                        TouchControlPlusMinus(value:$l2a,symbolindicator:"2.square.fill",increment:1,min:0,max:0.25)
                        TouchControlPlusMinus(value:$l3a,symbolindicator:"3.square.fill",increment:1,min:0,max:0.25)
                    }.padding()
                    HStack() {
                        TouchControlPlusMinus(value:$l4a,symbolindicator:"4.square.fill",increment:1,min:0,max:360)
                        TouchControlPlusMinus(value:$l5a,symbolindicator:"5.square.fill",increment:1,min:0,max:360)
                        TouchControlPlusMinus(value:$l6a,symbolindicator:"6.square.fill",increment:1,min:0,max:360)
                    }.padding()
                 
                } else {

                    HStack() {
                        Spacer()

                        TouchControlPlusMinus(value:$l1a,symbolindicator:"x.square.fill",increment:0.005,min:-0.4,max:0.4)
                        Spacer()
                        TouchControlPlusMinus(value:$l3a,symbolindicator:"y.square.fill",increment:0.005,min:-0.4,max:0.4)
                        Spacer()
                        TouchControlPlusMinus(value:$l2a,symbolindicator:"z.square.fill",increment:0.005,min:0.01,max:0.5)
                        Spacer()
                        

                    }.padding()

                    HStack() {
                        Spacer()

                        TouchControlPlusMinus(value:$l4a,symbolindicator:"f.square.fill",increment:1,min:-180,max:180)
                        Spacer()
                        TouchControlPlusMinus(value:$l5a,symbolindicator:"r.square.fill",increment:1,min:-180,max:180)
                        Spacer()
                        TouchControlPlusMinus(value:$l6a,symbolindicator:"e.square.fill",increment:1,min:-180,max:180)
                        Spacer()

                    }.padding()
                }
                
            }
        }
    }
}

