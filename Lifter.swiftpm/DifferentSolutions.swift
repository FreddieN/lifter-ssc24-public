//
//  DifferentSolutions.swift
//  Denavit–Hartenberg
//
//  Created by Freddie Nicholson on 21/01/2024.
//

import SwiftUI


struct DifferentSolutions: View {
 
    @State private var isEditing = false
    @State private var showPopover = false
    @State private var l1a: Float = -0.08
    @State private var l2a: Float = 0.24
    @State private var l3a: Float = 0.09
    @State private var l4a: Float = 16.0
    @State private var l5a: Float = 148.0
    @State private var l6a: Float = 0.0
    
    var body: some View {
        VStack() {
            Button("Show Controls") {
                showPopover = true
            }.buttonStyle(.borderedProminent)
            .popover(isPresented: $showPopover) {
                
                VStack {

                        TouchControlPlusMinus(value:$l1a,symbolindicator:"x.square.fill",increment:0.005,min:-0.4,max:0.4)
                    TouchControlPlusMinus(value:$l3a,symbolindicator:"y.square.fill",increment:0.005,min:-0.25,max:0.25)
                    TouchControlPlusMinus(value:$l2a,symbolindicator:"z.square.fill",increment:0.005,min:0.01,max:0.4)
                        TouchControlPlusMinus(value:$l4a,symbolindicator:"f.square.fill",increment:1,min:-180,max:180)
                        TouchControlPlusMinus(value:$l5a,symbolindicator:"r.square.fill",increment:1,min:-180,max:180)
                        TouchControlPlusMinus(value:$l6a,symbolindicator:"e.square.fill",increment:1,min:-180,max:180)

                }
                .padding()
            }
            
            ScrollView() {
                HStack() {
                    VStack{
                        MultipleRobotRenderTest(shoulder: true, elbow: true, wrist: true,solNo:1,l1a:$l1a,l2a:$l2a,l3a:$l3a,l4a:$l4a,l5a:$l5a,l6a:$l6a)
                        //                    Text("ShoulderForwardsElbowUpWristUp")
                        MultipleRobotRenderTest(shoulder: true, elbow: true, wrist: false,solNo:2,l1a:$l1a,l2a:$l2a,l3a:$l3a,l4a:$l4a,l5a:$l5a,l6a:$l6a)
                        //                    Text("ShoulderForwardsElbowUpWristDown")
                        MultipleRobotRenderTest(shoulder: true, elbow: false, wrist: true,solNo:3,l1a:$l1a,l2a:$l2a,l3a:$l3a,l4a:$l4a,l5a:$l5a,l6a:$l6a)
                        //                    Text("ShoulderForwardsElbowDownWristUp")
                        MultipleRobotRenderTest(shoulder: true, elbow: false, wrist: false,solNo:4,l1a:$l1a,l2a:$l2a,l3a:$l3a,l4a:$l4a,l5a:$l5a,l6a:$l6a)
                        //                    Text("ShoulderForwardsElbowDownWristDown")
                        
                    }
                    VStack{
                        MultipleRobotRenderTest(shoulder: false, elbow: true, wrist: true,solNo:5,l1a:$l1a,l2a:$l2a,l3a:$l3a,l4a:$l4a,l5a:$l5a,l6a:$l6a)
                        //                    Text("ShoulderBackwardsElbowUpWristUp")
                        MultipleRobotRenderTest(shoulder: false, elbow: true, wrist: false,solNo:6,l1a:$l1a,l2a:$l2a,l3a:$l3a,l4a:$l4a,l5a:$l5a,l6a:$l6a)
                        //                    Text("ShoulderBackwardsElbowUpWristDown")
                        MultipleRobotRenderTest(shoulder: false, elbow: false, wrist: true,solNo:7,l1a:$l1a,l2a:$l2a,l3a:$l3a,l4a:$l4a,l5a:$l5a,l6a:$l6a)
                        //                    Text("ShoulderBackwardsElbowDownWristUp")
                        MultipleRobotRenderTest(shoulder: false, elbow: false, wrist: false,solNo:8,l1a:$l1a,l2a:$l2a,l3a:$l3a,l4a:$l4a,l5a:$l5a,l6a:$l6a)
                        //                    Text("ShoulderBackwardsElbowDownWristDown")
                        
                    }
                }
            }
        }.padding([.top,.bottom],100)
    }
}
