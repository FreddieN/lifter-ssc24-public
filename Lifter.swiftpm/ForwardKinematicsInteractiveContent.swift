//
//  ForwardKinematicsInteractiveContent.swift
//  Lifter
//
//  Created by Freddie Nicholson on 30/01/2024.
//

import SwiftUI
import ARKit
import RealityKit

private var d1:Float = 0
private var d2:Float = 0
private var d4:Float = 0
private var d6:Float = 0
private var a1:Float = 0
private var a2:Float = 0

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

        
        camera.look(at: SIMD3(0,0.2,0), from: SIMD3(0,0.2,0.6), relativeTo: nil)
        
        let joints: [SIMD3<Float>] = [SIMD3(0,0.064,0),SIMD3(0.080028,-0.009,0.065981),SIMD3(0.0,-0.005,0.129936),SIMD3(0.133807,0.024,0.0),SIMD3(0.036193,0.017,0.0)]
        

        if let modelEntity = try? Entity.load(named: "ActuatorTestWithOrigins.usdz") {
            let anchor1 = AnchorEntity(world:.zero)
            anchor1.addChild(modelEntity)
            view.scene.addAnchor(anchor1)

        }
        if let modelEntity = try? Entity.load(named: "RedSphere.usdz") {
            modelEntity.name = "RedSphere"
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
        


        let base = view.scene.findEntity(named: "base")
        if let base {
        }
        let l1 = view.scene.findEntity(named: "link1a")
        l1?.setOrientation(simd_quatf(angle: (l1a*(Float.pi))/180, axis: [0, 1, 0]), relativeTo: nil)
        if let l1 {
        }
        
        let l2 = view.scene.findEntity(named: "link2a")
        l2?.setOrientation(simd_quatf(angle: (l2a*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l1)
        if let l2 {
            d1 = l2.position(relativeTo: base)[1]
            a1 = l2.position(relativeTo: l1)[0]
        }
        let l3 = view.scene.findEntity(named: "link3a")
        l3?.setOrientation(simd_quatf(angle: (l3a*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l2)
        if let l3 {
                a2 = l3.position(relativeTo: l2)[1]

        }
        let l4 = view.scene.findEntity(named: "link4a")
        l4?.setOrientation(simd_quatf(angle: (l4a*(Float.pi))/180, axis: [1, 0, 0]),relativeTo: l3)
        if let l4 {
                d2 = l4.position(relativeTo: l1)[2]

        }
        let l5 = view.scene.findEntity(named: "link5a")
        l5?.setOrientation(simd_quatf(angle: (l5a*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l4)
        if let l5 {
            d4 = l5.position(relativeTo: l3)[0]
        }
        let l6 = view.scene.findEntity(named: "link6ag")
        if let l6 {
            
        }
        l6?.setOrientation(simd_quatf(angle: (l6a*(Float.pi))/180, axis: [1, 0, 0]),relativeTo: l5)
        let attachment = view.scene.findEntity(named: "attachment")
        if let attachment {
            d6 = attachment.position(relativeTo: l5)[0]
        }
        if let attachment {
        }
        let visualBall = view.scene.findEntity(named: "RedSphere")
        var sixDofRobotDH: [fksolver.dh_row] = []
        sixDofRobotDH.append(fksolver.dh_row(q: l1a, d: d1, a: a1, alpha: 90))
        sixDofRobotDH.append(fksolver.dh_row(q: l2a+90, d: d2, a: a2, alpha: 0))
        sixDofRobotDH.append(fksolver.dh_row(q: l3a, d: 0, a: 0, alpha: 90))
        sixDofRobotDH.append(fksolver.dh_row(q: l4a, d: d4, a: 0, alpha: -90))
        sixDofRobotDH.append(fksolver.dh_row(q: l5a, d: 0, a: 0, alpha: 90))
        sixDofRobotDH.append(fksolver.dh_row(q: l6a, d: d6, a: 0, alpha: 0))


        let targetcoords = fksolver.solveFK2(dh:sixDofRobotDH,to:5)
        visualBall?.setPosition(targetcoords, relativeTo: base)

        
    }
    
}

struct ForwardKinematicsInteractiveContent: View {
    @State private var l1a: Float = 0
    @State private var l2a: Float = 0
    @State private var l3a: Float = 0
    @State private var l4a: Float = 0
    @State private var l5a: Float = 0
    @State private var l6a: Float = 0
    @State private var dispX: Float = 0
    @State private var dispY: Float = 0
    @State private var dispZ: Float = 0
    @State var loaded: Bool = true
    @State private var isEditing = false

    func updateDisp() {
        var sixDofRobotDH: [fksolver.dh_row] = []
        sixDofRobotDH.append(fksolver.dh_row(q: l1a, d: d1, a: a1, alpha: 90))
        sixDofRobotDH.append(fksolver.dh_row(q: l2a+90, d: d2, a: a2, alpha: 0))
        sixDofRobotDH.append(fksolver.dh_row(q: l3a, d: 0, a: 0, alpha: 90))
        sixDofRobotDH.append(fksolver.dh_row(q: l4a, d: d4, a: 0, alpha: -90))
        sixDofRobotDH.append(fksolver.dh_row(q: l5a, d: 0, a: 0, alpha: 90))
        sixDofRobotDH.append(fksolver.dh_row(q: l6a, d: d6, a: 0, alpha: 0))


        let targetcoords = fksolver.solveFK2(dh:sixDofRobotDH,to:5)
        dispX = targetcoords[0]
        dispY = targetcoords[1]
        dispZ = targetcoords[2]

    }
    
    var body: some View {
        VStack {
            if(loaded) {
                RealityKitView(l1a: $l1a, l2a: $l2a, l3a: $l3a, l4a: $l4a, l5a: $l5a, l6a: $l6a).ignoresSafeArea().onAppear(perform: {
                    updateDisp()
                })
            } else {
                ProgressView().onAppear(perform: {
                    let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                        loaded = true
                    }
                })
            }
            Text("Forward Kinematics Final Position: X: \(String(format: "%.2f", dispX)) Y: \(String(format: "%.2f", dispY)) Z: \(String(format: "%.2f", dispZ))")
            HStack() {
               
                Button("Home Position", action: {
                    l1a=0
                    l2a=0
                    l3a=0
                    l4a=0
                    l5a=0
                    l6a=0
                }).buttonStyle(.borderedProminent)
            }.padding()
            HStack() {
                VStack() {
                    HStack() {
                        Text("Link 1").padding()
                        Slider(
                            value: $l1a,
                            in: -185...185,
                            onEditingChanged: { editing in
                                isEditing = editing
                                updateDisp()
                            }
                        )
                        Text("\(String(format: "%.2f", l1a))")
                        
                    }.padding()
                    HStack() {
                        Text("Link 2").padding()
                        Slider(
                            value: $l2a,
                            in: -155...35,
                            onEditingChanged: { editing in
                                isEditing = editing
                                updateDisp()
                            }
                        )
                        Text("\(String(format: "%.2f", l2a))")
                    }.padding()
                    HStack() {
                        Text("Link 3").padding()
                        Slider(
                            value: $l3a,
                            in: -130...155,
                            onEditingChanged: { editing in
                                isEditing = editing
                                updateDisp()
                            }
                        )
                        Text("\((String(format: "%.2f", l3a)))")
                    }.padding()
                }
                VStack() {
                    HStack() {
                        Text("Link 4").padding()
                        Slider(
                            value: $l4a,
                            in: -350...350,
                            onEditingChanged: { editing in
                                isEditing = editing
                                updateDisp()
                            }
                        )
                        Text("\((String(format: "%.2f", l4a)))")
                    }.padding()
                    HStack() {
                        Text("Link 5").padding()
                        Slider(
                            value: $l5a,
                            in: -110...130,
                            onEditingChanged: { editing in
                                isEditing = editing
                                updateDisp()
                            }
                        )
                        Text("\((String(format: "%.2f", l5a)))")
                    }.padding()
                    
                    HStack() {
                        Text("Link 6").padding()
                        Slider(
                            value: $l6a,
                            in: -350...350,
                            onEditingChanged: { editing in
                                isEditing = editing
                                updateDisp()
                            }
                        )
                        Text("\((String(format: "%.2f", l6a)))")
                    }.padding()
                }
            }
        }
    }
}



