//
//  UIColor.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-03.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import UIKit
import ColorPickerRow

// MARK: - This extension provides a custom set of named colours, which are grouped under the name `Material`. In order to add a new colour option, add a new case to both the `enum Material` and the `convenience init(_ colorString: Material)` sections.
extension UIColor {
    convenience init(hex:  String) {
        var hexFormatted = hex
        if hexFormatted.hasPrefix("#") {
            hexFormatted.removeFirst()
        }
        
        var hexInt: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&hexInt)
        
        let r = (hexInt & 0xff0000) >> 16
        let g = (hexInt & 0xff00) >> 8
        let b = hexInt & 0xff
        
        self.init(red: CGFloat(r) / 0xff, green: CGFloat(g) / 0xff, blue: CGFloat(b) / 0xff, alpha: 1)
    }
    
    convenience init(_ colorString: Material) {
        switch colorString {
        case .red:
            self.init(hex: "#f44336")
        case .pink:
            self.init(hex: "#ff4081")
        case .purple:
            self.init(hex: "#ab47bc")
        case .deeppurple:
            self.init(hex: "#673ab7")
        case .indigo:
            self.init(hex: "#3f51b5")
        case .blue:
            self.init(hex: "#2196f3")
        case .lightblue:
            self.init(hex: "#29b6f6")
        case .cyan:
            self.init(hex: "#26c6da")
        case .teal:
            self.init(hex: "#26a69a")
        case .green:
            self.init(hex: "#4caf50")
        case .lightgreen:
            self.init(hex: "#8bc34a")
        case .amber:
            self.init(hex: "#ffc107")
        case .orange:
            self.init(hex: "#ff9800")
        case .tangerine:
            self.init(hex: "#ff7043")
        case .steelblue:
            self.init(hex: "#789aa8")
        case .brown:
            self.init(hex: "#79695C")
        case .grey:
            self.init(hex: "#B2B2B2")
        case .bluegrey:
            self.init(hex: "#74919F")
        case .lightgrey:
            self.init(hex: "#EBEBEB")
        }
    }
    
    enum Material: String, CaseIterable, Codable  {
        case red
        case pink
        case purple
        case deeppurple
        case indigo
        case blue
        case lightblue
        case cyan
        case teal
        case green
        case lightgreen
        case amber
        case orange
        case tangerine
        case steelblue
        case brown
        case grey
        case bluegrey
        case lightgrey
        
        static func fromUIColor(color: UIColor?) -> Material {
            return self.allCases.first{ UIColor($0) == color } ?? .red
        }
        
        static func getCourseColourPalette() -> [ColorSpec] {
            let excludedCourseColours: [Material] = [brown, grey, bluegrey, lightgrey]
            var colourPalette = [ColorSpec]()
            for colour in Material.allCases {
                if !excludedCourseColours.contains(colour) {
                    colourPalette.append(ColorSpec(hex: UIColor(colour).hexString(), name: colour.rawValue))
                }
            }
            return colourPalette
        }
    }
}
