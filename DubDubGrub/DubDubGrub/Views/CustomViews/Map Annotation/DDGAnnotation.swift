//
//  DDGAnnotation.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/25/23.
//

import SwiftUI

struct DDGAnnotation: View {

    var location: DDGLocation
    var number: Int
    
    var body: some View {
        VStack {
            ZStack {
                MapBalloon()
                    .frame(width: 100, height: 70)
                    .foregroundColor(Color.brandPrimary)
                Image(uiImage: location.squareImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .offset(y: -11)
                if number > 0 {
                    Text(number > 99 ? "99+" : "\(number)")
                        .font(.system(size: 11, weight: .bold))
                        .frame(width: 26, height: 18)
                        .foregroundColor(.white)
                        .background(Color.grubRed)
                        .clipShape(Capsule())
                        .offset(x: 20, y: -28)
                }
            }
            Text(location.name)
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

struct DDGAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        DDGAnnotation(location: DDGLocation(record: MockData.location), number: 1)
    }
}
