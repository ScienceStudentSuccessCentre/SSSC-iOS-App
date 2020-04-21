//
//  MentorLoader.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-11-07.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import Foundation
import PromiseKit

/// Utility class that retrieves SSSC mentors from the server and parses them into proper `Mentor` objects.
class MentorLoader {
    private static let serverUrl = URL(string: "http://sssc-carleton-app-server.herokuapp.com/mentors")
    
    /// Gathers mentor data from the server and passes it on to be deserialized.
    ///
    /// - Returns: The newly parsed mentors in the form of a promise.
    static func loadMentors() -> Promise<[Mentor]> {
        return Promise { seal in
            if let url = serverUrl {
                URLSession.shared.dataTask(with: url) { result in
                    switch result {
                    case .success((_, let data)):
                        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                            seal.reject(URLError(.badServerResponse))
                            return
                        }
                        let mentors = deserializeMentors(json: json)
                        let sortedMentors = sortMentors(mentors)
                        seal.fulfill(sortedMentors)
                    case .failure(let error):
                        seal.reject(error)
                    }
                }.resume()
            } else {
                seal.reject(URLError(.badURL))
            }
        }
    }
    
    /// Converts JSON data into a list of SSSC mentors.
    ///
    /// - Parameter json: JSON data retrieved from the server.
    /// - Returns: The list of mentors, parsed and sorted.
    private static func deserializeMentors(json: Any) -> [Mentor] {
        var mentors = [Mentor]()
        if let jsonMentors = json as? NSArray {
            for jsonMentor in jsonMentors {
//                print(jsonMentors)
                if let mentorData = jsonMentor as? NSDictionary,
                    let mentor = Mentor(mentorData: mentorData) {
                    mentors.append(mentor)
                } else {
                    print("Failed to generate mentor...")
                }
            }
        } else {
            print("JSON data is invalid")
        }
        return mentors
    }
    
    /// Sorts the list of SSSC mentors into alphabetical order by first name.
    ///
    /// - Parameter mentors: The list of mentors to sort.
    /// - Returns: The list of mentors in alphabetical order.
    private static func sortMentors(_ mentors: [Mentor]) -> [Mentor] {
        return mentors.sorted {
            $0.name < $1.name
        }
    }
}
