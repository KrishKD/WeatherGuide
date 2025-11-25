//
//  HomeView.swift
//  WeatherGuide
//
//  Created by krishna on 6/25/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var viewModel: HomeViewModel
    @State private var searchText: String = ""
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if viewModel.viewState.isDataAvailable {
            List(viewModel.viewState.locations, id: \.id) { location in
                Text(location.locality ?? "NA")
                    .onTapGesture {
                        viewModel.selectedLocation = location
                    }
                    .listRowSeparatorTint(Color("Overlay2"))
                    .listRowBackground(Color("Mauve").opacity(0.1))
            }
            .scrollContentBackground(.hidden)
        } else {
            Text("Please add a location to view weather details")
                .onAppear {
                    Task {
                        await viewModel.fetchLocationFromDB()
                    }
                }
        }
    }
}

#if DEBUG
struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        
        var locations: [WGLocation] {
            let locations: [WGLocation] = Array(
                repeating: location,
                count: 1
            )
            
            return locations
        }
        
        ForEach(ColorScheme.allCases, id: \.self,
                content: HomeView(
                    viewModel: .init(
                        viewState: .init(
                            locations: locations
                        )
                    )
                )
            .preferredColorScheme
        )
    }
}
#endif
