//
//  Features.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2020-08-03.
//  Copyright © 2020 Avery Vine. All rights reserved.
//

import Foundation

struct Features: Codable {
    private static let featuresUrl = URL(string: "http://sssc-carleton-app-server.herokuapp.com/features")
    private(set) static var shared = Features()
    
    private init() {
        // Provide acceptable defaults for each feature toggle, should the feature list fail to load
        enableEmailEventRegistration = false
        enableEmailMentorRegistration = false
    }
    
    // Name all features *exactly* as they appear at the /features endpoint
    let enableEmailEventRegistration: Bool
    let enableEmailMentorRegistration: Bool
    
    static func fetch() {
        guard let featuresUrl = featuresUrl else { return }
        URLSession.shared.dataTask(with: featuresUrl) { result in
            switch result {
            case .success((_, let data)):
                do {
                    shared = try JSONDecoder().decode(Features.self, from: data)
                } catch let error {
                    print("Failed to decode features:\n\(error)")
                }
            case .failure(let error):
                print("Failed to load features:\n\(error)")
            }
        }.resume()
    }
}
