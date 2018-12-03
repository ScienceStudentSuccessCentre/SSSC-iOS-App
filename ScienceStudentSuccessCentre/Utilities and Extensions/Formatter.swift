//
//  Formatter.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-24.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
