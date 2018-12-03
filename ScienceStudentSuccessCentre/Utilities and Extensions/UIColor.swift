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
            self.init(hex: "#FF574A")
        case .pink:
            self.init(hex: "#FD3277")
        case .purple:
            self.init(hex: "#BD66C7")
        case .deeppurple:
            self.init(hex: "#7B4ECB")
        case .indigo:
            self.init(hex: "#5365C9")
        case .blue:
            self.init(hex: "#35AAFF")
        case .lightblue:
            self.init(hex: "#17BDFF")
        case .cyan:
            self.init(hex: "#14D0E8")
        case .teal:
            self.init(hex: "#14AA9C")
        case .green:
            self.init(hex: "#60C364")
        case .lightgreen:
            self.init(hex: "#9FD75E")
        case .lime:
            self.init(hex: "#E1F04D")
        case .amber:
            self.init(hex: "#FFD51B")
        case .orange:
            self.init(hex: "#FFAC14")
        case .deeporange:
            self.init(hex: "#FF6B36")
        case .brown:
            self.init(hex: "#79695C")
        case .grey:
            self.init(hex: "#B2B2B2")
        case .bluegrey:
            self.init(hex: "#74919F")
        case .navbar:
            self.init(hex: "#779AA9")
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
        case navbar
        
        static func fromUIColor(color: UIColor?) -> Material {
            return self.allCases.first{ UIColor($0) == color } ?? .red
        }
        
        static func getColourPalette() -> [ColorSpec] {
            var colourPalette = [ColorSpec]()
            for colour in Material.allCases {
                colourPalette.append(ColorSpec(hex: UIColor(colour).hexString(), name: colour.rawValue))
            }
            return colourPalette
        }
    }
    
    func adjustedForNavController() -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: max(((r * 255) - 20) / 255, 0.0), green: max(((g * 255) - 20) / 255, 0.0), blue: max(((b * 255) - 20) / 255, 0.0), alpha: 1)
        }
        return self
    }
    
}
