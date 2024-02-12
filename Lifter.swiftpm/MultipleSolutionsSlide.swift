//
//  MultipleSolutionsSlide.swift
//  Lifter
//
//  Created by Freddie Nicholson on 30/01/2024.
//

import SwiftUI

struct MultipleSolutionsSlide: View {
    
    var body: some View {
        
        HStack() {
            VStack() {
                DifferentSolutions().frame(width:(UIScreen.main.bounds.height/4)*3)
                               
                               
            }
            VStack() {
                HStack() {
                    Text("Multiple Solutions").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding([.leading, .trailing,.top])
                    Spacer()
                }
                HStack() {
                    ScrollView() {
                        Text("""
                             When we calculate inverse kinematics there are multiple ways we can achieve the target end effector position.
                             
                             The robot arm has several components: a shoulder, an elbow and a wrist.
                             """)
                             Image("RobotComponents").resizable()
                            .aspectRatio(contentMode: .fit).frame(maxHeight:300)
                             Text(
                                """
                             These parts can be rotated in different ways to achieve the same final end effector position.
                             
                             To the left you can see an interactive solution set for all the possible solutions to get to a certain position and orientation. Some solutions might be invalid due to a joint limit being reached or a collision with a link. Additional logic needs to be added to the controller in order to take this into account.
                             
                             **Why might this be useful?** Robot arms often follow paths and considerations need to be made about energy, component lifetime and efficiency.
                             
                             We know there will always be 8 possible solutions for this specific design. This is not the case for all robots.
                             """)
                        
                        Spacer()
                    }.padding([.leading, .trailing]).padding(.bottom,125)
                    Spacer()

                }
            }
            
        }
    }
}
