import SwiftUI

struct ContentView: View {
    @State private var page: Int  = 0
    private let totalpage: Int = 7
    @State var skippable: Bool = false
    @State var pageInFrame: Bool = false
    
    var body: some View {
        ZStack() {
            switch page {
                case 0:
                    IntroductionSlide()
                case 1:
                    SpecificationSlide()
                case 2:
                    DenavitHartenbergSlide()
                case 3:
                    ForwardKinematicsSlide()
                case 4:
                    InverseKinematicsSlide()
                case 5:
                    MultipleSolutionsSlide()
                case 6:
                    BalloonPop()
                case 7:
                    ThankYouSlide()
                default:
                    Text("Error with slides: page \(page) does not exist.")
            }
           
            
            VStack() {
             Spacer()
                HStack() {
                    Spacer()
                    VStack() {
                        if(page != totalpage) {
                            Button(action: {
                                if(page != totalpage) {
                                    page += 1
                                }
                            }) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .resizable()
                                    .frame(width: 75, height: 75)
                                    .foregroundColor(.blue)
                            }.padding([.leading], 25)
                        }
                            
                      
                        if(skippable) {
                            Button(action: {
                                page += 1
                            }) {
                                Text("Skip")
                            }.padding().buttonStyle(.bordered).foregroundColor(.black)
                        }

                            HStack() {
                                Text("\(Int((Double(page)/Double(totalpage))*100))%")
                                ProgressView(value: Double(page)/Double(totalpage)).frame(maxWidth: 100)
                            }
                    }.padding()
                }
            }
            
            if(page != 0) {
                VStack() {
                    HStack() {
                            Button(action: {
                                if(page != 0) {
                                    
                                    page -= 1
                                }
                            }) {
                                Text("Back")
                            }.buttonStyle(.bordered).padding()
                        
                        Spacer()
                    }
                    Spacer()
                }
            }
            
        }
    }
}
