//
//  ProfileModalView.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/24/23.
//

import SwiftUI

struct ProfileModalView: View {
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 60)
                Text("First Last")
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text("company name")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                Text("doubleclick.net was prevented from profiling you across 4 websites profiling you across 4 websites")
                    .lineLimit(3)
                    .padding()
            }
            .frame(width: 300, height: 230)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .overlay(
                Button {
                    
                } label: {
                    XDismissButton()
                },
                alignment: .topTrailing
            )
            Image(uiImage: PlaceholderImage.avatar)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 110)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.5),radius: 4, x: 0, y: 6)
                .offset(y: -120)
        }
    }
}

struct ProfileModalView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModalView()
    }
}
