//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/15/23.
//


import SwiftUI

struct LocationListView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<10) { item in
                    NavigationLink(destination: LocationDetailView()) {
                        LocationCell()
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Grub Spots")
        }
    }
}


struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}
