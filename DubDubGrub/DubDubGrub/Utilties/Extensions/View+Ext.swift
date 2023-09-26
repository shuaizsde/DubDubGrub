//
//  View+Ext.swift
//  DubDubGrub
//
//  Created by Sean Allen on 5/21/21.
//

import SwiftUI

extension View {
    func profileNameStyle() -> some View {
        self.modifier(ProfileNameText())
    }

    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func playHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
//    func embedInScrollView() -> some View {
//        GeometryReader { geometry in
//            ScrollView {
//                self.frame(minHeight: geometry.size.height, maxHeight: .infinity)
//            }
//        }
//    }
}
