//
//  TouchControlPlusMinus.swift
//  Lifter
//
//  Created by Freddie Nicholson on 07/02/2024.
//

import Foundation
import SwiftUI

public struct TouchControlPlusMinus: View {
    @Binding var value: Float
    let symbolindicator: String
    let increment: Float
    let min: Float
    let max: Float
    
    @State private var timer: Timer? = nil
    
    public var body: some View {
        HStack() {
            VStack() {
                Image(systemName: symbolindicator)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
                HStack() {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                if(self.timer == nil) {
                                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                                        if(value > min) {
                                            value -= increment
                                        }
                                        }
                                }
                            }
                            .onEnded { _ in
                                self.timer?.invalidate()
                                self.timer = nil
                            }
                    )
                    
                    Text(String(format: "%.2f",value)).frame(width:50)
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                    }
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                if(self.timer == nil) {
                                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                                        if(value < max) {
                                            value += increment
                                        }
                                    }
                                }
                            }
                            .onEnded { _ in
                                self.timer?.invalidate()
                                self.timer = nil
                            }
                    )
                }
            }
        }
    }
}
