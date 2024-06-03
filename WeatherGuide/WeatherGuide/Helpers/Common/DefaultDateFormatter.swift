//
//  DefaultDateFormatter.swift
//  WeatherGuide
//
//  Created by krishna on 6/3/24.
//  Copyright © 2024 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation

class DefaultDateFormatter {
    static let dataformatter = DateFormatter()
    
    static func dateformatterForhhmma() -> DateFormatter {
        self.dataformatter.dateFormat = "hh:mm a"
        return dataformatter
    }
}
