//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/15/23.
//

import MapKit
import SwiftUI

struct LocationMapView: View {
    @State private var region = 
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.331516, 
                longitude: -121.891054),
            span: MKCoordinateSpan(
                latitudeDelta: 0.1, 
                longitudeDelta: 0.1)
        )
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region).ignoresSafeArea()
            VStack {
                LogoView().shadow(radius: 10)
                Spacer()
            }
        }
    }
}

struct LogoView: View {
    var body: some View {
        Image("ddg-map-logo")
            .resizable()
            .scaledToFit()
            .frame(height: 70)
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}
