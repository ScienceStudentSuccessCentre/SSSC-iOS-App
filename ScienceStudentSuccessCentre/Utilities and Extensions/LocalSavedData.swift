//
//  LocalSavedData.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2020-08-03.
//  Copyright © 2020 Avery Vine. All rights reserved.
//

import Foundation

struct LocalSavedData {
    @propertyWrapper
    struct Storage<T> {
        let key: String
        let defaultValue: T
        var storage: UserDefaults = .standard
        
        var wrappedValue: T {
            get {
                storage.object(forKey: key) as? T ?? defaultValue
            }
            set {
                if let optional = newValue as? AnyOptional, optional.isNil {
                    storage.removeObject(forKey: key)
                } else {
                    storage.set(newValue, forKey: key)
                }
            }
        }
    }
    
    // User-facing data
    @Storage(key: "respectSystemDarkMode", defaultValue: true) static var respectSystemDarkMode: Bool
    @Storage(key: "permanentDarkMode", defaultValue: false) static var permanentDarkMode: Bool
    @Storage(key: "includeInProgressCourses", defaultValue: true) static var includeInProgressCourses: Bool
    
    // Hidden data
    @Storage(key: "studentName") static var studentName: String?
    @Storage(key: "studentNumber") static var studentNumber: Int?
    @Storage(key: "showTestEvents", defaultValue: false) static var showTestEvents: Bool
}

extension LocalSavedData.Storage where T: ExpressibleByNilLiteral {
    init(key: String, storage: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, storage: storage)
    }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
