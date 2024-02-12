//
//  ThankYouSlide.swift
//  Lifter
//
//  Created by Freddie Nicholson on 30/01/2024.
//

import SwiftUI

struct ThankYouSlide: View {
    
    var body: some View {
        
        HStack() {
            VStack() {
                ThankYouInteractiveContent().frame(width:(UIScreen.main.bounds.height/4)*3)
                               
                               
            }
            VStack() {
                HStack() {
                    Text("Thank you").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding([.leading, .trailing,.top])
                    Spacer()
                }
                HStack() {
                    ScrollView() {
                        Text("""
Thank you for walking through my playground! I hope you learned something new and you are excited to explore more about Robotics.

Beyond the methods we used, there are more complex methods that are used in modern robotics to make more complex movements however they can get quite advanced.

**Freddie Nicholson**

I am a second year student in the Design Engineering Department at Imperial College London. We cover a broad range of engineering including Robotics which is where my inspiration for this playground came from.
""")
                
                    }.padding([.leading, .trailing])
                    Spacer()
                }
            }
            
        }
    }
}
