//
//  CurrentWeatherView.swift
//  WeatherGuide
//
//  Created by krishna on 5/31/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import SwiftUI
import WGSwiftUI

struct CurrentWeatherView: View {
    @ObservedObject var viewModel: CurrentWeatherViewModel
    
    var body: some View {
        ZStack {
            Color("Mauve")
                .opacity(0.1)
            
            ViewThatFits(in: .horizontal) {
                HStack {
                    VStack {
                        currentWeatherConditionStack
                        
                        minMaxTemperatureStack
                    }
                    .padding(WGSpacer.extraLarge)
                    
                    HStack {
                        sunRiseSet
                        
                        weatherCondition
                    }
                }
                
                VStack {
                    VStack {
                        currentWeatherConditionStack
                        
                        minMaxTemperatureStack
                    }
                    .padding(WGSpacer.extraLarge)
                    
                    Spacer()
                    
                    HStack {
                        sunRiseSet
                        
                        weatherCondition
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: WGSpacer.medium, trailing: 0))
                }
            }
        }
        .task {
            do {
                try await viewModel.getWeatherData()
            } catch {
                Text("Error Fetching Weather Data")
            }
        }
    }
    
    var currentWeatherConditionStack: some View {
        HStack {
            weatherStatusImageView
            
            currentTemperatureLabel
        }
    }
    
    var minMaxTemperatureStack: some View {
        VStack {
            Text("\(viewModel.viewState.maximumTemperature) / \( viewModel.viewState.minimumTemperature)")
                .font(.body)
                .foregroundStyle(Color("Text", bundle: Bundle.main))
        }
    }
    
    var weatherStatusImageView: some View {
        Image(systemName: viewModel.viewState.weatherStatusImageName)
            .font(.largeTitle)
    }
    
    var currentTemperatureLabel: some View {
        Text(viewModel.viewState.currentTemperature)
            .font(.largeTitle)
            .foregroundStyle(Color("Text", bundle: Bundle.main))
    }
    
    var sunRiseSet: some View {
        WeatherEffectInfoView(
            symbol1: "sunrise",
            value1: viewModel.viewState.sunriseTime,
            symbol2: "sunset",
            value2: viewModel.viewState.sunsetTime,
            textColor: Color("Text", bundle: Bundle.main)
        )
    }
    
    var weatherCondition: some View {
        WeatherEffectInfoView(
            symbol1: "humidity",
            value1: viewModel.viewState.humidity,
            symbol2: "wind",
            value2: viewModel.viewState.windSpeed,
            textColor: Color("Text", bundle: Bundle.main)
        )
    }
}

struct CurrentWeatherView_Preview: PreviewProvider {
    static var previews: some View {
        let weatherResponse = """
            {"lat":37.7858,"lon":-122.4064,"timezone":"America/Los_Angeles","timezone_offset":-25200,"current":{"dt":1717417974,"sunrise":1717418920,"sunset":1717471646,"temp":57.18,"feels_like":56.82,"pressure":1014,"humidity":90,"dew_point":54.28,"uvi":0,"clouds":75,"visibility":10000,"wind_speed":26.46,"wind_deg":280,"wind_gust":33.38,"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}]},"daily":[{"dt":1717444800,"sunrise":1717418920,"sunset":1717471646,"moonrise":1717410960,"moonset":1717461900,"moon_phase":0.9,"summary":"There will be partly cloudy today","temp":{"day":59.47,"min":53.89,"max":59.68,"night":53.89,"eve":55.24,"morn":56.68},"feels_like":{"day":59.11,"night":52.74,"eve":54.27,"morn":56.37},"pressure":1016,"humidity":85,"dew_point":54.77,"wind_speed":15.77,"wind_deg":270,"wind_gust":23.33,"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":100,"pop":0,"uvi":8.25},{"dt":1717531200,"sunrise":1717505304,"sunset":1717558083,"moonrise":1717499280,"moonset":1717552800,"moon_phase":0.94,"summary":"Expect a day of partly cloudy with clear spells","temp":{"day":65.62,"min":54.1,"max":69.93,"night":60.15,"eve":66.27,"morn":55.71},"feels_like":{"day":64.62,"night":59.34,"eve":65.43,"morn":54.45},"pressure":1013,"humidity":58,"dew_point":49.86,"wind_speed":13.06,"wind_deg":278,"wind_gust":21.92,"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"clouds":6,"pop":0,"uvi":10.09},{"dt":1717617600,"sunrise":1717591689,"sunset":1717644519,"moonrise":1717588020,"moonset":1717643580,"moon_phase":0.97,"summary":"The day will start with clear sky through the late morning hours, transitioning to partly cloudy","temp":{"day":63.41,"min":54.3,"max":63.55,"night":54.3,"eve":57.52,"morn":57.2},"feels_like":{"day":62.55,"night":53.29,"eve":56.5,"morn":56.37},"pressure":1011,"humidity":66,"dew_point":51.01,"wind_speed":11.21,"wind_deg":239,"wind_gust":12.84,"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":100,"pop":0,"uvi":9.12},{"dt":1717704000,"sunrise":1717678075,"sunset":1717730953,"moonrise":1717677180,"moonset":1717734120,"moon_phase":0,"summary":"Expect a day of partly cloudy with clear spells","temp":{"day":59.67,"min":52.36,"max":59.67,"night":53.1,"eve":54.01,"morn":53.92},"feels_like":{"day":58.57,"night":52.14,"eve":53.06,"morn":52.86},"pressure":1010,"humidity":69,"dew_point":49.05,"wind_speed":15.68,"wind_deg":246,"wind_gust":17.87,"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"clouds":24,"pop":0,"uvi":9.53},{"dt":1717790400,"sunrise":1717764464,"sunset":1717817386,"moonrise":1717766820,"moonset":1717824000,"moon_phase":0.04,"summary":"There will be clear sky until morning, then partly cloudy","temp":{"day":57.94,"min":51.67,"max":57.94,"night":52.5,"eve":53.67,"morn":53.08},"feels_like":{"day":56.86,"night":51.67,"eve":52.83,"morn":52.03},"pressure":1012,"humidity":73,"dew_point":49.35,"wind_speed":14.85,"wind_deg":252,"wind_gust":18.48,"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":91,"pop":0,"uvi":10},{"dt":1717876800,"sunrise":1717850854,"sunset":1717903818,"moonrise":1717857000,"moonset":1717913400,"moon_phase":0.08,"summary":"There will be partly cloudy today","temp":{"day":59.16,"min":51.89,"max":60.22,"night":54.63,"eve":56.91,"morn":53.26},"feels_like":{"day":57.92,"night":53.31,"eve":55.51,"morn":52.29},"pressure":1013,"humidity":67,"dew_point":47.89,"wind_speed":13.58,"wind_deg":244,"wind_gust":18.57,"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"clouds":13,"pop":0,"uvi":10},{"dt":1717963200,"sunrise":1717937246,"sunset":1717990248,"moonrise":1717947240,"moonset":1718002140,"moon_phase":0.11,"summary":"Expect a day of partly cloudy with clear spells","temp":{"day":59.58,"min":53.04,"max":59.58,"night":53.64,"eve":54.61,"morn":54.1},"feels_like":{"day":58.42,"night":52.88,"eve":53.85,"morn":52.88},"pressure":1012,"humidity":68,"dew_point":48.83,"wind_speed":16.55,"wind_deg":254,"wind_gust":22.77,"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"clouds":1,"pop":0,"uvi":10},{"dt":1718049600,"sunrise":1718023640,"sunset":1718076677,"moonrise":1718037600,"moonset":0,"moon_phase":0.14,"summary":"You can expect partly cloudy in the morning, with clearing in the afternoon","temp":{"day":62.02,"min":52.66,"max":62.02,"night":56.43,"eve":57.45,"morn":55.22},"feels_like":{"day":61.03,"night":55.06,"eve":56.05,"morn":54.25},"pressure":1012,"humidity":66,"dew_point":49.98,"wind_speed":12.21,"wind_deg":251,"wind_gust":13.76,"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"clouds":20,"pop":0,"uvi":10}]}
        """
        let weather = try! JSONDecoder().decode(WGWeather.self, from: Data(weatherResponse.utf8))
        let location = WGLocation(
            with: 37.7749,
            longitude: -122.4194,
            locality: "San Francisco",
            administrativeArea: "CA",
            dateModified: Date()
        )
        
        let viewModel = CurrentWeatherViewModel(location: location, viewState: .init(currentTemperature: "", maximumTemperature: "", minimumTemperature: "", sunriseTime: "", sunsetTime: "", humidity: "", weatherStatusImageName: "", windSpeed: ""))
        
        ForEach(
            ColorScheme.allCases,
            id: \.self,
            content: CurrentWeatherView(viewModel: viewModel).preferredColorScheme
        )
    }
}
