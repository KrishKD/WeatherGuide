//
//  HomeView.swift
//  WeatherGuide
//
//  Created by krishna on 6/25/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self, content: HomeView()
            .preferredColorScheme
        )
    }
}
