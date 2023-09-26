//
//  LogoView.swift
//  DubDubGrub
//
//  Created by Simon Zhang on 5/31/23.
//

import SwiftUI

struct LogoView: View {

    var frameWidth: CGFloat

    var body: some View {
        Image(decorative: "ddg-map-logo")
            .resizable()
            .scaledToFit()
            .frame(width: frameWidth)
//
//        Image("ddg-map-logo")
//            .resizable()
//            .scaledToFit()
//            .frame(width: frameWidth)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView(frameWidth: 250)
    }
}
