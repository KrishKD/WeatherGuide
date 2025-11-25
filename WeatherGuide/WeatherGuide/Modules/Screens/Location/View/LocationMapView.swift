//
//  LocationMapView.swift
//  WeatherGuide
//
//  Created by krishna on 6/3/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @ObservedObject var viewModel: LocationMapViewModel
    @State var region: MKCoordinateRegion
    
    init(with viewModel: LocationMapViewModel) {
        self.viewModel = viewModel
        _region = State(initialValue: .init(
            center: .init(latitude: 34.13024, longitude: -84.22762),
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        ))
    }
    
    var body: some View {
        MapReader { reader in
            map
                .onTapGesture(perform: { touchPoint in
                    if let coordinates = reader.convert(touchPoint, from: .local) {
                        viewModel.updateAnnotation(with: coordinates)
                    }
                })
                .overlay(alignment: .bottom) {
                    addLocationButton
                }
                .onAppear {
                    viewModel.fetchCurrentLocation()
                }
        }
    }
    
    var map: some View { 
        Map(position: viewModel.binding) {
            ForEach(viewModel.annotations, id: \.id) { item in
                Marker("", coordinate: item.coordinates)
                    .tint(Color("Mauve", bundle: Bundle.main))
            }
        }
    }
    
    @ViewBuilder
    var addLocationButton: some View {
        Button {
            viewModel.addLocation()
        } label: {
            Text("Add Location")
                .bold()
                .font(.body)
                .foregroundStyle(.white)
        }
        .padding()
        .background(.blue.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
    }
}

struct LocationMapView_Preview: PreviewProvider {
    static var previews: some View {
        
        ForEach(ColorScheme.allCases,
                id: \.self,
                content:
                    LocationMapView(with: .init())
                .preferredColorScheme
        )
    }
}
