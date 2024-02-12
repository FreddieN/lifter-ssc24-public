//
//  SpecificationSlide.swift
//  Lifter
//
//  Created by Freddie Nicholson on 30/01/2024.
//

import SwiftUI

struct SpecificationSlide: View {
    @State var card1: Bool = false
    @State var card2: Bool = false
    @State var card3: Bool = false
    @State var card4: Bool = false

    var body: some View {
        
            
            VStack() {
                HStack() {
                    Text("Robot Arm Characteristics").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding([.leading, .trailing,.top,.bottom])
                    Spacer()
                }
                HStack() {
                    Text("Tap a tile to learn more.").font(.title2).padding(.leading)
                Spacer()
                }.padding([.bottom])
                Spacer()
                HStack() {
                        HStack() {
                            VStack() {
                                    
                                
                                CardView(flip: card1) {
                                            
                                    VStack{
                                        VStack() {
                                            Spacer()
                                            HStack(){
                                                Text("6").font(.title).fontWeight(.bold)
                                                Spacer()}
                                            HStack() {
                                                Text("Degrees of Freedom (DoF)")
                                            Spacer()
                                            }
                                        }.padding(20)
                                        
                                    }.frame(maxWidth:.infinity,maxHeight:.infinity).padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(15)
                                        .padding([.trailing,.bottom], 20)
                                    
                                        } back: {
                                            
                                            VStack{
                                                HStack() {
                                                    Text("Degrees of Freedom (DoF)").fontWeight(.bold)
                                                    Spacer()
                                                }
                                                Spacer()
                                                Text("DoF describes the number of ways in which a robot can be moved.")
                                                Spacer()

                                            }.frame(maxWidth:.infinity,maxHeight:.infinity).padding()
                                                .background(Color(.systemGray6))
                                                .cornerRadius(15)
                                                .padding([.trailing,.bottom], 20)
                                            
                                        }.animation(.linear)
                                    .onTapGesture {
                                        card1.toggle()
                                    }
            
                                
                                Spacer()
                                CardView(flip: card2) {
                                            
                                    VStack{
                                        VStack() {
                                            Spacer()
                                            HStack(){
                                                Image("Workspace").resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                            Spacer()
                                            HStack() {
                                                Text("Workspace")
                                            Spacer()
                                            }
                                        }.padding(20)
                                        
                                    }.frame(maxWidth:.infinity,maxHeight:.infinity).padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(15)
                                        .padding([.trailing], 20)
                                    
                                        } back: {
                                            
                                            VStack{
                                                HStack() {
                                                    Text("Workspace").fontWeight(.bold)
                                                 Spacer()
                                                }
                                                Spacer()

                                                Text("The workspace is the accessible area of the robot.")
                                                Spacer()

                                                
                                            }.frame(maxWidth:.infinity,maxHeight:.infinity).padding()
                                                .background(Color(.systemGray6))
                                                .cornerRadius(15)
                                                .padding([.trailing], 20)
                                            
                                        }.animation(.linear)
                                    .onTapGesture {
                                        card2.toggle()
                                    }
                                
                            }
                            Spacer()
                            VStack() {
                                CardView(flip: card3) {
                                            
                                    VStack{
                                        VStack() {
                                            Spacer()
                                            HStack(){
                                                Text("""
Joint 1: -185° to 180°
Joint 2: -155° to 35°
Joint 3: -130° to 155°
Joint 4: -350° to 350°
Joint 5: -110° to 130°
Joint 6: -350° to 350°
""").fontWeight(.bold).font(.system(size: 500))
                                                    .minimumScaleFactor(0.01)
                                                Spacer()}
                                            Spacer()
                                            HStack() {
                                                Text("Joint Limits")
                                            Spacer()
                                            }
                                        }.padding(20)
                                        
                                    }.frame(maxWidth:.infinity,maxHeight:.infinity).padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(15)
                                        .padding([.trailing,.bottom], 20)
                                    
                                        } back: {
                                            
                                            VStack{
                                                HStack() {
                                                    Text("Joint Limits").fontWeight(.bold)
                                                    Spacer()
                                                }
                                                Spacer()

                                                Text("The joint limits of the robot are in place to prevent damage to the internals of the robot / avoid a collision.")
                                                Spacer()

                                                
                                            }.frame(maxWidth:.infinity,maxHeight:.infinity).padding()
                                                .background(Color(.systemGray6))
                                                .cornerRadius(15)
                                                .padding([.trailing,.bottom], 20)
                                            
                                        }.animation(.linear)
                                    .onTapGesture {
                                        card3.toggle()
                                    }
            
                                
                                Spacer()
                                CardView(flip: card4) {
                                            
                                    VStack{
                                        VStack() {
                                            Spacer()
                                            HStack(){
                                                Text("7").font(.title).fontWeight(.bold)
                                                Spacer()}
                                            HStack() {
                                                Text("Links")
                                                Spacer()
                                            }
                                            HStack {
                                                Text("6").font(.title).fontWeight(.bold)
                                                Spacer()}
                                            HStack() {
                                                Text("Joints")
                                            Spacer()
                                            }
                                        }.padding(20)
                                        
                                    }.frame(maxWidth:.infinity,maxHeight:.infinity).padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(15)
                                        .padding([.trailing], 20)
                                    
                                        } back: {
                                            
                                            VStack{
                                                HStack() {
                                                    Text("Links and Joints").fontWeight(.bold)
                                                    Spacer()
                                                }
                                                Spacer()

                                                Text("The components that make up a robotic manipulator. There is one more link than there are joints for our scenario.")
                                                Spacer()

                                                
                                            }.frame(maxWidth:.infinity,maxHeight:.infinity).padding()
                                                .background(Color(.systemGray6))
                                                .cornerRadius(15)
                                                .padding([.trailing], 20)
                                            
                                        }.animation(.linear)
                                    .onTapGesture {
                                        card4.toggle()
                                    }
                        
                        }
                            Spacer()
                        
                    }.frame()
                    RobotCharacteristicsExploreRobotInteractiveContent().clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }.padding(.bottom, 110).padding([.trailing,.leading], 20)
               
            }.padding(50)
            
    }
}

struct CardView<Front: View, Back: View>: View {
    var flip: Bool
    var front: () -> Front
    var back: () -> Back
    
    var body: some View {
        ZStack {
            front()
                .rotation3DEffect(.degrees(flip ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                .opacity(flip ? 0 : 1)

            back()
                .rotation3DEffect(.degrees(flip ? 0 : -180), axis: (x: 1, y: 0, z: 0))
                .opacity(flip ? 1 : 0)
        }
    }
}
