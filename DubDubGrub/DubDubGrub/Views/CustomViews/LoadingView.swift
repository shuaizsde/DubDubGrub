//
//  LoadingView.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/24/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            // Add a backgrround color to blur previous view while loading
            Color(.systemBackground)
                .opacity(0.9)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .brandPrimary))
                .scaleEffect(2)
                .offset(y: -40)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
