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
    
    struct Material {
        static var red: UIColor  { return UIColor(hex: "#F44336") }
        static var pink: UIColor  { return UIColor(hex: "#E91E63") }
        static var purple: UIColor  { return UIColor(hex: "#9C27B0") }
        static var deepPurple: UIColor  { return UIColor(hex: "#673AB7") }
        static var indigo: UIColor  { return UIColor(hex: "#3F51B5") }
        static var blue: UIColor  { return UIColor(hex: "#2196F3") }
        static var lightBlue: UIColor  { return UIColor(hex: "#03A9F4") }
        static var cyan: UIColor  { return UIColor(hex: "#00BCD4") }
        static var teal: UIColor  { return UIColor(hex: "#009688") }
        static var green: UIColor  { return UIColor(hex: "#4CAF50") }
        static var lightGreen: UIColor  { return UIColor(hex: "#8BC34A") }
        static var lime: UIColor  { return UIColor(hex: "#CDDC39") }
        static var amber: UIColor  { return UIColor(hex: "#FFC107") }
        static var orange: UIColor  { return UIColor(hex: "#FF9800") }
        static var deepOrange: UIColor  { return UIColor(hex: "#FF5722") }
        static var brown: UIColor  { return UIColor(hex: "#795548") }
        static var grey: UIColor  { return UIColor(hex: "#9E9E9E") }
        static var blueGrey: UIColor  { return UIColor(hex: "#607D8B") }
        
        static func getColourPalette() -> [ColorSpec] {
            return [ColorSpec(hex:  red.hexString(), name: "red"),
                    ColorSpec(hex:  pink.hexString(), name: "pink"),
                    ColorSpec(hex:  purple.hexString(), name: "purple"),
                    ColorSpec(hex:  deepPurple.hexString(), name: "deep purple"),
                    ColorSpec(hex:  indigo.hexString(), name: "indigo"),
                    ColorSpec(hex:  blue.hexString(), name: "blue"),
                    ColorSpec(hex:  lightBlue.hexString(), name: "light blue"),
                    ColorSpec(hex:  cyan.hexString(), name: "cyan"),
                    ColorSpec(hex:  teal.hexString(), name: "teal"),
                    ColorSpec(hex:  green.hexString(), name: "green"),
                    ColorSpec(hex:  lightGreen.hexString(), name: "lightGreen"),
                    ColorSpec(hex:  lime.hexString(), name: "lime"),
                    ColorSpec(hex:  amber.hexString(), name: "amber"),
                    ColorSpec(hex:  orange.hexString(), name: "orange"),
                    ColorSpec(hex:  deepOrange.hexString(), name: "deepOrange"),
                    ColorSpec(hex:  brown.hexString(), name: "brown"),
                    ColorSpec(hex:  grey.hexString(), name: "grey"),
                    ColorSpec(hex:  blueGrey.hexString(), name: "blue grey")]
        }
        
        static func fromHexString(hex:  String) -> UIColor {
            return UIColor(hex: hex)
        }
    }
}
