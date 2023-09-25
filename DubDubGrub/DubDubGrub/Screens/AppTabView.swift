//
//  AppTabView.swift
//  DubDubGrub
//
//  Created by Sean Allen on 5/19/21.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            LocationMapView()
            .tabItem {
                Label("Map", systemImage: "map")
            }

            LocationListView()
            .tabItem {
                Label("Locations", systemImage: "building")
            }

            NavigationView {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
        .accentColor(.brandPrimary)
        .onAppear {
            CloudKitManager.shared.getUserRecord()
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.03)

            // Use this appearance when scrolling behind the TabView:
            UITabBar.appearance().standardAppearance = appearance
            // Use this appearance when scrolled all the way up:
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
