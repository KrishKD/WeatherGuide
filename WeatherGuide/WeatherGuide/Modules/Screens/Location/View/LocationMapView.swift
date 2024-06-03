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
    var viewModel: LocationMapViewModel
    
    var body: some View {
        map
            .overlay(alignment: .bottom) {
                addLocationButton
            }
    }
    
    var map: some View {
        Map(
            coordinateRegion: viewModel.viewState.$coordinateRegion,
            showsUserLocation: true,
            annotationItems: viewModel.viewState.annotations) { item in
                MapMarker(coordinate: item.coordinates, tint: Color("Mauve", bundle: Bundle.main))
            }
    }
    
    @ViewBuilder
    var addLocationButton: some View {
        Button {
            
        } label: {
            Text("Add Location")
                .bold()
                .font(.title3)
                .foregroundStyle(Color("Text", bundle: Bundle.main))
        }
        .padding()
        .background(Color("Blue", bundle: Bundle.main))
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .padding(.init(top: 0, leading: 0, bottom: 20.0, trailing: 0))
    }
}

struct LocationMapView_Preview: PreviewProvider {
    static var previews: some View {
        let region: MKCoordinateRegion = .init(
            center: .init(latitude: 37.6193, longitude: 122.3816),
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        
        let annotation: [PinAnnotation] = [
            PinAnnotation(coordinates: .init(
                latitude: 37.6193, longitude: 122.3816)
            )
        ]
        
        let viewModel = LocationMapViewModel(viewState: .init(coordinateRegion: region, annotations: annotation))
        
        ForEach(ColorScheme.allCases,
                id: \.self,
                content:
            LocationMapView(viewModel: viewModel)
                .preferredColorScheme
        )
    }
}
