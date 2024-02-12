//
//  SideView.swift
//  Lifter
//
//  Created by Freddie Nicholson on 28/01/2024.
//

import SwiftUI

struct SideView: View {
    var title: String
    
    var body: some View {
        
        HStack() {
            VStack() {
                Rectangle().frame(width:(UIScreen.main.bounds.height/4)*3)
                               
                               
            }
            VStack() {
                HStack() {
                    Text(title).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding([.leading, .trailing,.top])
                    Spacer()
                }
                HStack() {
                    ScrollView() {
                        Text("Hello").padding([.leading, .trailing])
                    }
                    Spacer()
                }
            }
            
        }
    }
}

