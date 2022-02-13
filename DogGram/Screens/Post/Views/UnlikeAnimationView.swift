//
//  UnlikeAnimationView.swift
//  DogGram
//
//  Created by naodroid on 2022/01/08.
//

import SwiftUI

private enum UnlikeAnimateStatus: Int {
    case gone
    case startAnim
    case endAnim
    
    var color: Color {
        switch self {
        case .gone, .startAnim:
            return Color.red.opacity(0.6)
        case .endAnim:
            return Color.gray.opacity(0.6)
        }
    }
    var scale: CGFloat {
        switch self {
        case .gone, .startAnim: return 1.0
        case .endAnim: return 0.0
        }
    }
    var opacity: CGFloat {
        switch self {
        case .gone, .endAnim: return 0.0
        case .startAnim: return 1.0
        }
    }
}


struct UnlikeAnimationView: View {
    @Binding var animate: Bool
    @State private var animStatus: UnlikeAnimateStatus = .gone
    
    var body: some View {
        ZStack {
            Image(systemName: "heart.fill")
                .foregroundColor(animStatus.color)
                .font(.system(size: 150))
                .opacity(animStatus.opacity)
                .scaleEffect(animStatus.scale)

            Image(systemName: "heart")
                .foregroundColor(animStatus.color)
                .font(.system(size: 150))
                .opacity(animStatus.opacity)
                .scaleEffect(1.0)
        }
        .onChange(of: animate, perform: { value in
            switch animStatus {
            case .gone:
                if value {
                    withAnimation(.easeIn(duration: 0.1)) {
                        animStatus = .startAnim
                    }
                    withAnimation(.easeIn(duration: 0.4).delay(0.1)) {
                        animStatus = .endAnim
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        animStatus = .gone
                    }
                }
            case .startAnim, .endAnim:
                break
            }
        })
        
    }
}

struct UnlikeAnimationView_Previews: PreviewProvider {
    @State static var animate: Bool = true
    
    static var previews: some View {
        Button {
            animate.toggle()
        } label: {
            UnlikeAnimationView(animate: $animate)
        }
        .previewLayout(.fixed(width: 200, height: 200))
    }
}
