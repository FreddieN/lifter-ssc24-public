//
//  DenavitHartenbergSlide.swift
//  Lifter
//
//  Created by Freddie Nicholson on 30/01/2024.
//

import SwiftUI

struct DenavitHartenbergSlide: View {
    
    var body: some View {
        
        HStack() {
            VStack() {
                DenavitHartenbergInteractiveContent().frame(width:(UIScreen.main.bounds.height/4)*3)
                               
                               
            }
            VStack() {
                HStack() {
                    Text("Denavit-Hartenberg").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding([.leading, .trailing,.top])
                    Spacer()
                }
                HStack() {
                    ScrollView() {
                        VStack(alignment: .center) {
                                           Image("DiagramRobotDistancesJoints").resizable()
                                               .aspectRatio(contentMode: .fit).frame(maxHeight:300)
                                           Text("Robot Arm Diagram of Links and Joints").padding(.horizontal,40).padding(.top, 10).font(.caption)
                                       }
                       
                        Text("""

You can see a diagram of the robot we are working with above and interact with the 3D model to the left.

Engineers use a convention called Denavit-Hartenberg to represent the robot as a simple table. This table allows us to calculate the position of the end of the robot from the angles of the joints (in yellow).
""")
                        DisclosureGroup("What does each parameter mean?") {
                            Text("""
    • q: offset along previous z to the common normal
    • d: angle about previous z from old x to new x
    • a: length of the common normal
    • α: angle about common normal, from old z axis to new z axis
    Source: Wikipedia (Feb 2023)
""")
                        }
                        VStack(alignment: .center) {
                                           Image("SymbolicDH").resizable()
                                               .aspectRatio(contentMode: .fit).frame(maxHeight:300)
                                           Text("Symbolic Denavit-Hartenberg Table").padding(.horizontal,40).padding([.top,.bottom], 10).font(.caption)
                                       }
                        
                        VStack(alignment: .center) {
                                           Image("AbsoluteDH").resizable()
                                               .aspectRatio(contentMode: .fit).frame(maxHeight:300)
                            Text("Absolute Denavit-Hartenberg Table (Data from 3D model)").padding(.horizontal,40).padding([.top,.bottom], 10).font(.caption)
                                       }
                    }.padding([.leading, .trailing]).padding(.bottom,125)
                    Spacer()
                }
            }
            
        }
    }
}
