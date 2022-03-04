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
    let shouldShowClearBtn: Bool
    @State var showingAlert = false
    @State var hideBackBtn = true
    
    init(parkingLocation: CLLocation, locatingStatusService: LocatingStatusServiceProtocol, shouldShowClearBtn: Bool = true) {
        self.shouldShowClearBtn = shouldShowClearBtn
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
                if vm.isMapView {
                    mapView
                } else {
                    compassView
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Image(systemName: "car.fill")
                            .font(.title2)
                        Text("My vehicle")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .accessibilityIdentifier("LocatingDetailsView")
                        Spacer()
                    }
                    
                    Text("Location: \(vm.address)")
                    Text("Floor: \(floor)")
                }.padding([.horizontal, .top])
                
                if shouldShowClearBtn {
                    Button {
                        showingAlert = true
                    } label: {
                        Text("Clear")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .accessibilityIdentifier("AlertClearBtn")
                    .background(Color.theme.red)
                    .foregroundStyle(.background)
                    .cornerRadius(12)
                    .padding()
                }
                
            }.padding(.bottom)
        }
        .alert("Confirm to clear?", isPresented: $showingAlert) {
            Button("Clear", role: .destructive) {
                vm.clearSavedParkingLocation()
                dismiss()
            }
            .accessibilityIdentifier("AlertClearBtnConfirmed")
            
            Button("Cancel", role: .cancel, action: {})
                .accessibilityIdentifier("AlertClearBtnCancelled")
        }
        .toolbar{
            // Ignore leaks, dunno how to fix
            LocatingToolbarView(
                isMapView: vm.isMapView,
                headingAvailable: vm.headingAvailable) { [weak vm] isMapView in
                    vm?.changeView(isMap: isMapView)
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.spring()) {
                    self.hideBackBtn = false
                }
            }
        }
        .onDisappear {
            vm.stopSubscribing()
        }
        .navigationBarBackButtonHidden(hideBackBtn)
    }
}

struct LocatingDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LocatingDetailsView(parkingLocation: CLLocation(latitude: 1.49229000, longitude: 103.58795000), locatingStatusService: LocatingStatusService(locationManager: LocationManager(), dataRepository: FirebaseLocationsRepository()))
        }
    }
}

extension LocatingDetailsView {
    
    private var compassView: some View {
        VStack(spacing: 18) {
            if let distance = vm.distance {
                Image(systemName: "arrow.up")
                    .font(.title)
                    .rotationEffect(vm.degrees)
                    .animation(.linear, value: vm.degrees)
                Text("Distance: \(distance.formatted()) km")
                    .font(.largeTitle)
            } else {
                Text("Unable to calculate distance")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var mapView: some View {
        MapView(
            userLocation: $vm.userLocation,
            parkingLocation: parkingLocation
        )
            .frame(maxHeight: .infinity)
            .edgesIgnoringSafeArea(.top)
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
}
