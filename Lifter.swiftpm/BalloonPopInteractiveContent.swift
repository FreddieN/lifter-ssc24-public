//
//  RoboDanceInteractiveContent.swift
//  Lifter
//
//  Created by Freddie Nicholson on 01/02/2024.
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
private var parentEntity = ModelEntity()
private var balloonEntity = ModelEntity()
private var balloonExplodeEntity = ModelEntity()

private let balloonPopUpdateEvent = PassthroughSubject<Int, Never>()
private let anchorLockEvent = PassthroughSubject<Bool, Never>()
private let outOfBounds = PassthroughSubject<Bool, Never>()
private var lastKnownGood: [Float] = [0.18,0.25,0,0,0,0]

private var score: Int = 0

private func getRandBalloonPosWithinRange() -> SIMD3<Float> {

    var r1 = sqrt(0.004)
    var r2 = sqrt(0.03)
    var theta = Float.random(in: Float(0)..<Float(2 * Float.pi))
    var r = Float.random(in: Float(r1)..<Float(r2))
    var x = r * cos(theta)
    var z = r * sin(theta)
    var y = Float.random(in: Float(0.1)..<Float(0.3))

    
    return SIMD3(x,y,z)
}

private var balloonPos: SIMD3<Float> = getRandBalloonPosWithinRange()


private struct RealityKitView: UIViewRepresentable {
    @Binding var l1a: Float
    @Binding var l2a: Float
    @Binding var l3a: Float
    @Binding var l4a: Float
    @Binding var l5a: Float
    @Binding var l6a: Float
    @Binding var operating_mode: Bool
    @Binding var prev_operating_mode: Bool

  
    
    let anchor1 = AnchorEntity(.plane([.any],
                                  classification: [.any],
                                   minimumBounds: [0.5, 0.5]))
    
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
     
        let view = ARView()
        parentEntity = ModelEntity()
        
        view.addCoaching()
        anchorLockEvent.send(true)

        let session = view.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        

        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
                    config.sceneReconstruction = .meshWithClassification
                }
                
        view.environment.sceneUnderstanding.options.insert(.occlusion)
    
       
        


        
        
        if let modelEntity = try? Entity.load(named: "ActuatorTestWithOriginsBalloonPopper.usdz") {

            parentEntity.addChild(modelEntity)
            anchor1.addChild(parentEntity)
            view.scene.addAnchor(anchor1)
            
            let entityBounds = modelEntity.visualBounds(relativeTo: parentEntity)
                        parentEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
                                   
            view.installGestures(for: parentEntity)


        }
        
        if let modelEntity = try? Entity.load(named: "RedBalloon.usdz") {
            
            balloonEntity.addChild(modelEntity)
            balloonEntity.setPosition(balloonPos, relativeTo: parentEntity)
            parentEntity.addChild(balloonEntity)
      
           

        }
        
        let base = view.scene.findEntity(named: "base")
        if let base {
        }
        let l1 = view.scene.findEntity(named: "link1a")
        
        if let l1 {
        }
        
        let l2 = view.scene.findEntity(named: "link2a")

        if let l2 {

            d1 = l2.position(relativeTo: parentEntity)[1]
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
        
       
 
 
        
       view.session.run(config)

       return view
    }

    func updateUIView(_ view: ARView, context: Context) {
            

            var relative_positions="""
            Relative Joint Positions:
            
            """
            

            var linkangles: [Float] = [0,0,0,0,0,0]
//
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
        sixDofRobotDH.append(fksolver.dh_row(q: q6, d: d6+0.01, a: 0, alpha: 0))
        let targetcoords = fksolver.solveFK2(dh:sixDofRobotDH,to:6)
    
        let inputcoords = [l1a, l2a, l3a]
        let distance_between_target_and_input = sqrt(( pow((targetcoords[0]-inputcoords[0]),2)+pow((targetcoords[1]-inputcoords[1]),2)+pow((targetcoords[2]-inputcoords[2]),2) ))

        if distance_between_target_and_input > 0.1 || distance_between_target_and_input.isNaN {
            outOfBounds.send(true)

    } else {

        let l1 = view.scene.findEntity(named: "link1a")
        
        let l2 = view.scene.findEntity(named: "link2a")

        let l3 = view.scene.findEntity(named: "link3a")
        
        let l4 = view.scene.findEntity(named: "link4a")
        
        let l5 = view.scene.findEntity(named: "link5a")
        
        let l6 = view.scene.findEntity(named: "link6ag")
        
        let attachment = view.scene.findEntity(named: "attachment")
        
            l1?.setOrientation(simd_quatf(angle: (linkangles[0]*(Float.pi))/180, axis: [0, 1, 0]), relativeTo: parentEntity)
            l2?.setOrientation(simd_quatf(angle: (linkangles[1]*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l1)
            l3?.setOrientation(simd_quatf(angle: (linkangles[2]*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l2)
            l4?.setOrientation(simd_quatf(angle: ((linkangles[3])*(Float.pi))/180, axis: [1, 0, 0]),relativeTo: l3)
            l5?.setOrientation(simd_quatf(angle: ((linkangles[4])*(Float.pi))/180, axis: [0, 0, 1]),relativeTo: l4)
            l6?.setOrientation(simd_quatf(angle: ((linkangles[5])*(Float.pi))/180, axis: [1, 0, 0]),relativeTo: l5)
        lastKnownGood = [l1a,l2a,l3a,l4a,l5a,l6a]
        outOfBounds.send(false)

        let inputcoords = [balloonEntity.position[0], balloonEntity.position[1], balloonEntity.position[2]]
        let distance_between_target_and_input = sqrt(( pow((targetcoords[0]-inputcoords[0]),2)+pow((targetcoords[1]-inputcoords[1]),2)+pow((targetcoords[2]-inputcoords[2]),2) ))

        if(distance_between_target_and_input < 0.025) {
            balloonExplodeEntity = ModelEntity()
            
            let explodePos = balloonEntity.position(relativeTo: parentEntity)
            
            if let modelEntity = try? Entity.load(named: "BalloonExplode.usdz") {
                
                parentEntity.addChild(balloonExplodeEntity)
                balloonExplodeEntity.addChild(modelEntity)
                balloonExplodeEntity.setPosition(explodePos, relativeTo: parentEntity)
                   for animation in modelEntity.availableAnimations {
                       modelEntity.playAnimation(animation.repeat(count: 1))
                   }

            }
            balloonPos = getRandBalloonPosWithinRange()
            score += 1
            balloonPopUpdateEvent.send(score)
            
            
        }
        balloonEntity.setPosition(balloonPos, relativeTo: parentEntity)

    }
            
    }
    
    
    
}

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        self.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlay: ARCoachingOverlayView) {
        coachingOverlay.setActive(false, animated:true)

        anchorLockEvent.send(true)
    }
}


 struct BalloonPopInteractiveContent: View {
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
    @State private var displayScore: Int = 0
    @State private var gameTimer: Timer? = nil
    @State private var displayTime = 0
    @State private var gameOver = false
     @State private var outOfBoundsDisp: Bool = false

    var current_transform: [Float] = []
    
    
    var body: some View {
        ZStack() {
            
        HStack {
            ZStack() {
              
                RealityKitView(l1a: $l1a, l2a: $l2a, l3a: $l3a, l4a: $l4a, l5a: $l5a, l6a: $l6a, operating_mode: $operating_mode, prev_operating_mode: $prev_operating_mode).ignoresSafeArea().onAppear() {
                    score = 0
                    displayScore = 0
                    displayTime = 0
                    self.gameTimer?.invalidate()
                    self.gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
                        _ in
                        if(displayTime != 60) {
                            displayTime += 1
                        } else {
                            gameTimer = nil
                            gameOver = true
                        }
                    }
                }.onReceive(anchorLockEvent, perform: { _ in
                    score = 0
                    displayScore = 0
                    displayTime = 0
                    self.gameTimer?.invalidate()
                    self.gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
                        _ in
                        if(displayTime != 60) {
                            displayTime += 1
                        } else {
                            gameTimer = nil
                            gameOver = true
                        }
                    }
                })
                VStack() {
                    HStack() {
                        
                        VStack() {
                            VStack() {
                                Text("🎈Balloons Popped: \(displayScore)").frame(width:200).padding().background(    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.white))
                            }.padding().padding([.top],75).onReceive(balloonPopUpdateEvent, perform: { score in
                                displayScore = score
                            })
                            if let gameTimer {
                                VStack {
                                    Text("⏱️ Time Remaining: \(60-displayTime)").frame(width:200).padding().background(    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.white))
                                }.onAppear() {
                                    
                                }
                            }
                            if outOfBoundsDisp {
                                VStack {
                                    
                                    Text("Out of Bounds. Return to Workspace.").frame(width:200).padding().background(    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.red)).foregroundStyle(.white)
                                }.padding()
                            }
                        }.onReceive(outOfBounds, perform: { isOutOfBounds in
                            outOfBoundsDisp = isOutOfBounds
                            if(isOutOfBounds) {
                                l1a = lastKnownGood[0]
                                l2a = lastKnownGood[1]
                                l3a = lastKnownGood[2]
                                l4a = lastKnownGood[3]
                                l5a = lastKnownGood[4]
                                l6a = lastKnownGood[5]
                            }
                        })
                    Spacer()
                    }
                Spacer()
                }
                if(gameOver) {
                    ZStack() {
                        Rectangle().opacity(0.8).foregroundColor(.black)
                        VStack () {
                            Image("BalloonPopLogo").resizable().aspectRatio(contentMode: .fit)
                            Spacer()
                            Text("Game Over").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                            Text("🎈Balloons Popped: \(displayScore)")
                            Spacer()
                            Text("Press the blue next arrow (bottom right) to proceed.")
                        }.frame(width:600,height:400).padding().background(    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.white))
                    }
                }
            }
            
            VStack() {
                HStack() {
                    
                    Button("Home Position", action: {
                        l1a=0.18
                        l2a=0.25
                        l3a=0
                        l4a=0
                        l5a=0
                        l6a=0
                    }).buttonStyle(.borderedProminent)
                }.padding(30)
               

                    VStack() {

                        TouchControlPlusMinus(value:$l1a,symbolindicator:"x.square.fill",increment:0.005,min:-0.4,max:0.4)
                        TouchControlPlusMinus(value:$l3a,symbolindicator:"y.square.fill",increment:0.005,min:-0.4,max:0.4)
                        TouchControlPlusMinus(value:$l2a,symbolindicator:"z.square.fill",increment:0.005,min:0.01,max:0.5)

                   

                        TouchControlPlusMinus(value:$l4a,symbolindicator:"f.square.fill",increment:1,min:-180,max:180)
                        TouchControlPlusMinus(value:$l5a,symbolindicator:"r.square.fill",increment:1,min:-180,max:180)
                        TouchControlPlusMinus(value:$l6a,symbolindicator:"e.square.fill",increment:1,min:-180,max:180)

                    }.padding()
                Spacer()
                
            }.background(Rectangle().foregroundColor(.white).frame(height: UIScreen.main.nativeBounds.height))
        }
        }
       
    }
}


