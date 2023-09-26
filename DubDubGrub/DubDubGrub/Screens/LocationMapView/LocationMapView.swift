//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Sean Allen on 5/19/21.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationMapViewModel()

    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                annotationItems: locationManager.locations) { location in
                    MapAnnotation(
                        coordinate: location.location.coordinate,
                        anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                            DDGAnnotation(
                                location: location,
                                number: viewModel.checkedInProfiles[location.id, default: 0]
                            )
                                .onTapGesture {
                                    locationManager.selectedLocation = location
                                    if locationManager.selectedLocation != nil {
                                        viewModel.isShowingDetailView = true
                                    }
                                }
                    }
                }
                    .accentColor(.grubRed)
                    .ignoresSafeArea()

            VStack {
                LogoView(frameWidth: 125)
                    .shadow(radius: 10)
                Spacer()
            }
        }
            .sheet(
                isPresented: $viewModel.isShowingDetailView
            ) {
                NavigationView {
                    LocationDetailView(viewModel:
                        LocationDetailViewModel(location: locationManager.selectedLocation!)
                    )
                    .toolbar {
                        Button {
                            viewModel.isShowingDetailView = false
                        } label: {
                            Text("Dismiss").foregroundColor(Color.brandPrimary)
                        }
                    }
                }
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            .onAppear {
                viewModel.getCheckedInCounts()
                if locationManager.locations.isEmpty {
                    viewModel.getLocations(for: locationManager)
                }
            }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}
