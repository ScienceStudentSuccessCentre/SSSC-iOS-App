//
//  Double.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-07.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

// MARK: - This extention provides an easy way to round a double to a certain number of decimal places.
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
