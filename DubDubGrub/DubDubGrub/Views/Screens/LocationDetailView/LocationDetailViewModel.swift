//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Shuai Zhang on 9/24/23.
//

import MapKit
import SwiftUI

final class LocationDetailViewModel: NSObject, ObservableObject {
    
    @Published var alertItem: AlertItem?
    
    var location: DDGLocation
    
    
    let columns = [GridItem(.flexible()),
                   GridItem(.flexible()),
                   GridItem(.flexible())]
    
    init(location: DDGLocation) {
        self.location = location
    }
     
    // MARK: Actions for Buttons
    func getDirectionsToLocation() {
        let placeMark = MKPlacemark(coordinate: location.location.coordinate)
        
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = location.name
        // MKMapItem.openMaps(with: <#T##[MKMapItem]#>)  pass an array with start and end point
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        
    }
    
    func callLocation() {
        // guard let url = URL(string: "tel://832-366-1190") else {return}
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
            
        }
        UIApplication.shared.open(url)
    }
}
