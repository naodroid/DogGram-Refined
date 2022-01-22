//
//  CarouselView.swift
//  DogGram
//
//  Created by naodroid on 2021/11/21.
//

import SwiftUI

struct CarouselView: View {
    @State var selection: Int = 1
    @State var timerAdded: Bool = false
    private let imageCount = 8
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(1..<imageCount) {(i) in
                Image("dog\(i)")
                    .resizable()
                    .scaledToFill()
                    .tag(i)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 300)
        .animation(.default)
        .onAppear {
            if !timerAdded {
                addTimer()
            }
        }
    }
    
    //MARK: Functions
    func addTimer() {
        timerAdded = true
        let timer = Timer.scheduledTimer(
            withTimeInterval: 5.0,
            repeats: true) { (_) in
                if selection == imageCount {
                    selection = 1
                } else {
                    selection += 1
                }
        }
        timer.fire()
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
            .previewLayout(.sizeThatFits)
    }
}
