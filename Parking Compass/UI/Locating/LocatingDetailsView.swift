//
//  LocatingDetailsView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 11/02/2022.
//

import SwiftUI
import MapKit

struct LocatingDetailsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: LocatingDetailsViewModel
    let parkingLocation: CLLocation
    
    init(parkingLocation: CLLocation, locatingStatusService: LocatingStatusServiceProtocol) {
        self.parkingLocation = parkingLocation
        _vm = StateObject(wrappedValue: LocatingDetailsViewModel(parkingLocation: parkingLocation, locatingStatusService: locatingStatusService))
    }
    
    private var floor: String {
        if parkingLocation.floor == nil {
            return "Unknown"
        }
        else {
            return String(parkingLocation.floor!.level)
        }
    }
    
    var body: some View {
        ZStack {
            
            VStack {
                mapView
                    .edgesIgnoringSafeArea(.top)
                
                Spacer()
                
                Text(floor)
                
                Button {
                    //
                    vm.stopSubscribing()
                    dismiss()
                } label: {
                    Text("Clear")
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.theme.red)
                .foregroundStyle(.background)
                .cornerRadius(12)
                .padding()

            }.padding(.bottom)
        }
    }
}

struct LocatingDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LocatingDetailsView(parkingLocation: CLLocation(latitude: 1.49229000, longitude: 103.58795000), locatingStatusService: LocatingStatusService(locationManager: LocationManager()))
    }
}

extension LocatingDetailsView {
    private var mapView: some View {
        MapView(
            userLocation: vm.userLocation,
            parkingLocation: parkingLocation
        ).frame(maxHeight: .infinity)
        //        Map(
        //            coordinateRegion: $vm.region,
        //            interactionModes: .all,
        //            showsUserLocation: true,
        //            userTrackingMode: $vm.userTrackingMode,
        //            annotationItems: vm.places
        //        ) { place in
        //            MapAnnotation(
        //                coordinate: place.coordinate
        //            ) {
        //                Circle()
        //                    .stroke(Color.green)
        //                    .frame(width: 44, height: 44)
        //            }
        //        }
    }
    
    //    private var toolbarItems: some ToolbarContent {
    //        Group {
    //            ToolbarItem(placement: .navigationBarTrailing) {
    //                Button(action: {
    //                    vm.changeView(isMap: true)
    //                }) {
    //                    Image(systemName: "map.fill")
    //                }
    //                .tint(vm.isMapView ? Color.theme.primary : Color.theme.secondaryText)
    //                .opacity(vm.locatingStatusService.locatingStatus == .locating ? 1 : 0)
    //            }
    //            ToolbarItem(placement: .navigationBarTrailing) {
    //                Button(action: {
    //                    vm.changeView(isMap: false)} ) {
    //                        Image(systemName: "figure.walk.circle.fill")
    //                    }
    //                    .tint(!vm.isMapView ? Color.theme.primary : Color.theme.secondaryText)
    //                    .opacity(vm.locatingStatusService.locatingStatus == .locating ? 1 : 0)
    //            }
    //        }
    //    }
}
