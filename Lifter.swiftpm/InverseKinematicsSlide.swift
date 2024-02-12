//
//  InverseKinematicsSlide.swift
//  Lifter
//
//  Created by Freddie Nicholson on 30/01/2024.
//

import SwiftUI

struct InverseKinematicsSlide: View {
    
    var body: some View {
        
        HStack() {
            VStack() {
                InverseKinematicsInteractiveContent().frame(width:(UIScreen.main.bounds.height/4)*3)
                
                
            }
            VStack() {
                HStack() {
                    Text("Inverse Kinematics").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding([.leading, .trailing,.top])
                    Spacer()
                }
                HStack() {
                    ScrollView() {
                        Text("""
                             Inverse Kinematics is the reverse of Forward Kinematics and is much more useful. It is also much harder to work out.
                             
                             It allows us to work out the joint angles of the robot to achieve a specific position and orientation. This is great when working in 3D as it allows us to program in certain paths for precise tasks such as welding and pick-place operations.
                             """)
                             Image("IKDiagram").resizable()
                            .aspectRatio(contentMode: .fit).frame(maxHeight:300)
                             Text(
                                """
                             For the robot in this playground, It has been specifically designed based on common industrial robot design patterns that feature a ‘spherical wrist’. This means that the 3 joints on the wrist all rotate around the same point allowing us to simplify the calculation using a method called ‘kinematic decoupling’. In this example we are using geometry to find a solution however for more advanced robots, other methods would be required.
                             
                             Try using the simplified robot controller in the bottom left, hold down a control to change its value. You have control of the position of the wrist. You also have control of the wrist using the 'F-R-E' rotation system. You can see how the end effector rotates around a single point.
                             
                             Don't forget the robot has an operating workspace! If you leave this workspace the motors will lock.
                             """)
                        
                        Spacer()
                    }.padding([.leading, .trailing]).padding(.bottom,125)
                    Spacer()
                }
                
            }
        }
    }
}
