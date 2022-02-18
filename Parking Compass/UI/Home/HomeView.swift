//
//  HomeView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 07/02/2022.
//

import SwiftUI
import CoreLocationUI

struct HomeView: View {
    
    @StateObject private var vm: HomeViewModel
    
    init(locatingStatusService: LocatingStatusServiceProtocol) {
        _vm = StateObject(wrappedValue: HomeViewModel(locatingStatusService: locatingStatusService))
    }
    
    var body: some View {
        VStack {
            NavigationLink(tag: "Details", selection: $vm.tag) {
                LocatingDetailsView(parkingLocation: vm.savedLocation, locatingStatusService: vm.locatingStatusService)
            } label: {
                EmptyView()
            }
            
            if vm.currentAddress.isNotEmpty {
                savedParkingLocation
            }
            permissionList
            details
            
            Spacer()
            
            if vm.currentAddress.isEmpty {
                LocationButton(.currentLocation) {
                    vm.save()
                }
                .foregroundColor(.white)
                .tint(Color.theme.primary)
                .symbolVariant(.fill)
                .labelStyle(.titleAndIcon)
                .cornerRadius(10)
            }
        }
        .padding([.vertical])
    }
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(locatingStatusService: LocatingStatusService(locationManager: LocationManager()))
    }
}

extension HomeView {
    
    //    private var recentParkingList: some View {
    //        VStack(alignment: .leading, spacing: 18) {
    //            Text("Recent parking")
    //                .font(.subheadline)
    //                .foregroundColor(Color.theme.secondaryText)
    //
    //            VStack(spacing: 16) {
    //                HStack {
    //                    VStack(alignment: .leading, spacing: 10) {
    //                        Text("123 Jalan Sutera Utama")
    //                            .font(.headline)
    //                            .fontWeight(.medium)
    //                        Text("3 mins ago")
    //                            .font(.subheadline)
    //                            .foregroundColor(Color.theme.secondaryText)
    //                    }
    //                    Spacer()
    //                }
    //            }
    //            .padding()
    //            .background(Color.theme.background.opacity(0.7))
    //            .cornerRadius(12)
    //        }.padding()
    //    }
    
    
    private var savedParkingLocation: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center) {
                Image(systemName: "hand.tap.fill")
                    .font(.title)
                    .padding(.trailing)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Back to vehicle")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(vm.currentAddress)
                        .font(.caption)
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth:.infinity, alignment: .leading)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            vm.locate()
        }
        .padding(.horizontal)
        .foregroundStyle(.background)
        .background(Color.theme.primary)
        .cornerRadius(16)
        .shadow(color: Color.theme.primary.opacity(0.5), radius: 50, x: 0, y: 6)
        .padding()
    }
    
    private var permissionList: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Permissions")
                .font(.subheadline)
                .foregroundColor(Color.theme.secondaryText)
            
            VStack(alignment:.leading, spacing: 16) {
                //                HStack {
                //                    Image(systemName: "sensor.tag.radiowaves.forward.fill")
                //                    Text("Bluetooth")
                //                    Spacer()
                //                    Button("Enabled") {}
                //                    .foregroundColor(Color.theme.primary)
                //                }
                //                Divider()
                
                HStack {
                    Image(systemName: "location.fill")
                    Text("Location")
                    Spacer()
                    Button(vm.isLocationEnabled ? "Enabled" : "Disabled") {}
                    .foregroundColor(vm.isLocationEnabled ? Color.theme.primary : Color.theme.secondaryText)
                }
            }
            .padding()
            .background(Color.theme.background.opacity(0.7))
            .cornerRadius(12)
            
            //            if !vm.isLocationEnabled {
            //                HStack(spacing: 18) {
            //                    Image(systemName: "exclamationmark.triangle.fill")
            //                        .font(.subheadline)
            //                    Text("You have to enable location access to save parking location.")
            //                        .font(.subheadline)
            //                        .fontWeight(.medium)
            //                    Spacer()
            //                }.foregroundColor(Color.theme.red)
            //            }
            
        }.padding()
    }
    
    private var details: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About Parking Compass")
                .font(.subheadline)
                .foregroundColor(Color.theme.secondaryText)
            Text("Parking Compass will use Bluetooth or Location to help you record down where you parked. Using low-battery consumption bluetooth will allow you to record your vehicle location broadly. To have a more precise result, use Location instead.")
                .font(.footnote)
        }.padding()
    }
    
}
