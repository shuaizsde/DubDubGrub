//
//  AvatarView.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/16/23.
//

import SwiftUI

struct AvatarView: View {
    
    var size: CGFloat
    
    var body: some View {
        Image("default-avatar")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}


struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(size: 35)
    }
}
