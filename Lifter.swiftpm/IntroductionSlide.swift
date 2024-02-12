//
//  IntroductionSlide.swift
//  Lifter
//
//  Created by Freddie Nicholson on 30/01/2024.
//

import SwiftUI

struct IntroductionSlide: View {
    
    var body: some View {
        VStack() {
            HStack() {
                Text("Welcome to my SSC24 Entry.").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding([.leading, .trailing,.top])
                Spacer()
            }
            Image("IntroLogo").resizable()
           .aspectRatio(contentMode: .fit).frame(maxHeight:300)
            HStack() {
                ScrollView() {
                    Text("""
In this playground, you will learn about how robots move! The types of robots we will be investigating are incredibly useful in our everyday lives. From recycling old phones to making super smooth camera footage.
""")
                    
                    VStack(alignment: .leading, spacing: 10) {
                                Text("You will learn a bit about the following topics in Robotics:")
                                    .font(.headline)
                                
                                    Text("• Robot Arm Characteristics")
                                    Text("• Denavit-Hartenberg Parameters")
                                    Text("• Forward Kinematics")
                                    Text("• Inverse Kinematics")
                                    Text("• Solving for Multiple Solutions")

                    }.frame(width:(UIScreen.main.bounds.height/4)*3).padding()
                    
                }.padding([.leading, .trailing])
            }
            Text("Press the blue arrow button to proceed.")

        }.padding(50)
    
    }
}
