//
//  RoboDance.swift
//  Lifter
//
//  Created by Freddie Nicholson on 01/02/2024.
//

import SwiftUI

struct BalloonPop: View {
    @State var ingame = false;

    var body: some View {
        
        if(ingame) {
            BalloonPopInteractiveContent().ignoresSafeArea().onDisappear(perform: {
                ingame = false
            })
        } else {
            VStack() {
                HStack() {
//                    Text("BalloonPop Minigame").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding([.leading, .trailing,.top])
                    Spacer()
                }
                Image("BalloonPopLogo").resizable()
               .aspectRatio(contentMode: .fit).frame(maxHeight:500)
                HStack() {
                    ScrollView() {
                        Text("""
    In this minigame, the robot arm has been fitted with a specialised balloon popper. Your goal is to try and pop as many balloons as possible within the robot workspace in 60 seconds!
    
    You are able to scale the robot using gestures in order to play in table top mode or to real scale. The robot will automatically be placed on the closest horizontal surface so ensure you are pointing where you wish the minigame to be played.
    
    Press the green play button to proceed.
    """)
                 Spacer()
                
                        Button(action: {
                            ingame=true
                        }) {
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: 75, height: 75)
                                .foregroundColor(.green)
                        }
Spacer()
                            VStack() {
                                Text("""
    This activity will require AR. Ensure you are in a clear space and have enabled camera permission.
    """)
                                Spacer()

//                                Image(systemName: "arkit")
//                                    .resizable()
//                                    .frame(width: 40, height: 43)
//                                    .foregroundColor(.yellow).padding()

                            }.padding()
    //                    }.padding([.top,.bottom])
                       
                    }.padding([.leading, .trailing])
                }
//                Text("")

            }.padding(50)
            
        }
    }
}

