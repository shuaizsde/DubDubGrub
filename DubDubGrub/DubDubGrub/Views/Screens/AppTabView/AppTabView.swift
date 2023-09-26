//
//  AppTabView.swift
//  DubDubGrub
//
//  Created by Simon Zhang on 5/19/23.
//

import SwiftUI

struct AppTabView: View {

    @StateObject var viewModel = AppTabViewModel()

    var body: some View {
        TabView {
            LocationMapView()
                .tabItem { Label("Map", systemImage: "map") }

            LocationListView()
                .tabItem { Label("Locations", systemImage: "building") }

            NavigationView { ProfileView() }
                .tabItem { Label("Profile", systemImage: "person") }
        }
            .onAppear {
                viewModel.runStartupChecks()
                CloudKitManager.shared.getUserRecord()
                tabBarIOS15Fix()
            }
            .accentColor(.brandPrimary)
            .sheet(
                isPresented: $viewModel.isShowingOnboardView,
                onDismiss: viewModel.checkIfLocationServicesIsEnabled
            ) { OnboardView() }
    }

    func tabBarIOS15Fix() {
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

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
