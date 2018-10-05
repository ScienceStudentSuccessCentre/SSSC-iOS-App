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
            self.init(hex: "#F44336")
        case .pink:
            self.init(hex: "#E91E63")
        case .purple:
            self.init(hex: "#9C27B0")
        case .deeppurple:
            self.init(hex: "#673AB7")
        case .indigo:
            self.init(hex: "#3F51B5")
        case .blue:
            self.init(hex: "#2196F3")
        case .lightblue:
            self.init(hex: "#03A9F4")
        case .cyan:
            self.init(hex: "#00BCD4")
        case .teal:
            self.init(hex: "#009688")
        case .green:
            self.init(hex: "#4CAF50")
        case .lightgreen:
            self.init(hex: "#8BC34A")
        case .lime:
            self.init(hex: "#CDDC39")
        case .amber:
            self.init(hex: "#FFC107")
        case .orange:
            self.init(hex: "#FF9800")
        case .deeporange:
            self.init(hex: "#FF5722")
        case .brown:
            self.init(hex: "#795548")
        case .grey:
            self.init(hex: "#9E9E9E")
        case .bluegrey:
            self.init(hex: "#607D8B")
        }
    }
    
    enum Material: String, CaseIterable  {
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
        case lime
        case amber
        case orange
        case deeporange
        case brown
        case grey
        case bluegrey
        
        static func fromUIColor(color: UIColor?) -> Material {
            let materialColour = self.allCases.first{ UIColor($0) == color }
            return materialColour ?? Material.red
        }
        
        static func getColourPalette() -> [ColorSpec] {
            var colourPalette = [ColorSpec]()
            for colour in Material.allCases {
                colourPalette.append(ColorSpec(hex: UIColor(colour).hexString(), name: colour.rawValue))
            }
            return colourPalette
        }
    }
    
}
