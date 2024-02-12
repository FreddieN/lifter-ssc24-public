//
//  ForwardKinematicsSlide.swift
//  Lifter
//
//  Created by Freddie Nicholson on 30/01/2024.
//

import Foundation

import SwiftUI

struct ForwardKinematicsSlide: View {
    
    var body: some View {
        
        HStack() {
            VStack() {
                ForwardKinematicsInteractiveContent().frame(width:(UIScreen.main.bounds.height/4)*3)
                               
                               
            }
            VStack() {
                HStack() {
                    Text("Forward Kinematics").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding([.leading, .trailing,.top])
                    Spacer()
                }
                HStack() {
                    ScrollView() {
                        Text("""
Forward Kinematics is what we use for the calculation of the position of the end of the robot arm (end effector) from the joint angles of the robot.
""")
                             VStack(alignment: .center) {
                                                Image("FKDiagram").resizable()
                                                    .aspectRatio(contentMode: .fit).frame(maxHeight:300)
                             }.padding([.top,.bottom])
                             Text("""
This is where our D-H parameters come in helpful! Using the table we gained from our data we can put the numbers into a “homogeneous transformation matrix” for each joint. Multiplying each matrix together allows us to calculate the position and orientation of the end effector (which is shown by the orange sphere).

""")
                        VStack(alignment: .center) {
                            Image("DHTransformMatrix").resizable()
                                .aspectRatio(contentMode: .fit).frame(maxHeight:60).padding(.bottom)
                                           Image("FullTransformFK").resizable()
                                               .aspectRatio(contentMode: .fit).frame(maxHeight:20)
       
                                           
                                       }
                        Text("""
Try changing some of the sliders to see how it affects the end effector. You can also see a readout of the final position calculated.

""").padding([.top,.bottom])
                        
                    }.padding([.leading, .trailing]).padding(.bottom,125)
                    Spacer()
                }
            }
            
        }
    }
}
