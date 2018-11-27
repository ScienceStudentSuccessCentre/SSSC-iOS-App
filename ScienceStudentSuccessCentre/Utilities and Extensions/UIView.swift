//
//  UIView.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-30.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import UIKit

//extension UIView {
//
//    public enum ViewSide {
//        case top
//        case right
//        case bottom
//        case left
//    }
//
//    public func createBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> CALayer {
//
//        switch side {
//        case .top:
//            // Bottom Offset Has No Effect
//            // Subtract the bottomOffset from the height and the thickness to get our final y position.
//            // Add a left offset to our x to get our x position.
//            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
//            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                    y: 0 + topOffset,
//                                                    width: self.frame.size.width - leftOffset - rightOffset,
//                                                    height: thickness), color: color)
//        case .right:
//            // Left Has No Effect
//            // Subtract bottomOffset from the height to get our end.
//            return _getOneSidedBorder(frame: CGRect(x: self.frame.size.width - thickness - rightOffset,
//                                                    y: 0 + topOffset,
//                                                    width: thickness,
//                                                    height: self.frame.size.height), color: color)
//        case .bottom:
//            // Top has No Effect
//            // Subtract the bottomOffset from the height and the thickness to get our final y position.
//            // Add a left offset to our x to get our x position.
//            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
//            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                    y: self.frame.size.height-thickness-bottomOffset,
//                                                    width: self.frame.size.width - leftOffset - rightOffset,
//                                                    height: thickness), color: color)
//        case .left:
//            // Right Has No Effect
//            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                    y: 0 + topOffset,
//                                                    width: thickness,
//                                                    height: self.frame.size.height - topOffset - bottomOffset), color: color)
//        }
//    }
//
//    public func createViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> UIView {
//
//        switch side {
//        case .top:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                            y: 0 + topOffset,
//                                                                            width: self.frame.size.width - leftOffset - rightOffset,
//                                                                            height: thickness), color: color)
//            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
//            return border
//
//        case .right:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
//                                                                            y: 0 + topOffset, width: thickness,
//                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
//            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
//            return border
//
//        case .bottom:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                            y: self.frame.size.height-thickness-bottomOffset,
//                                                                            width: self.frame.size.width - leftOffset - rightOffset,
//                                                                            height: thickness), color: color)
//            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
//            return border
//
//        case .left:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                            y: 0 + topOffset,
//                                                                            width: thickness,
//                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
//            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
//            return border
//        }
//    }
//
//    public func addBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
//
//        switch side {
//        case .top:
//            // Add leftOffset to our X to get start X position.
//            // Add topOffset to Y to get start Y position
//            // Subtract left offset from width to negate shifting from leftOffset.
//            // Subtract rightoffset from width to set end X and Width.
//            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                   y: 0 + topOffset,
//                                                                   width: self.frame.size.width - leftOffset - rightOffset,
//                                                                   height: thickness), color: color)
//            self.layer.addSublayer(border)
//        case .right:
//            // Subtract the rightOffset from our width + thickness to get our final x position.
//            // Add topOffset to our y to get our start y position.
//            // Subtract topOffset from our height, so our border doesn't extend past teh view.
//            // Subtract bottomOffset from the height to get our end.
//            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
//                                                                   y: 0 + topOffset, width: thickness,
//                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
//            self.layer.addSublayer(border)
//        case .bottom:
//            // Subtract the bottomOffset from the height and the thickness to get our final y position.
//            // Add a left offset to our x to get our x position.
//            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
//            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                   y: self.frame.size.height-thickness-bottomOffset,
//                                                                   width: self.frame.size.width - leftOffset - rightOffset, height: thickness), color: color)
//            self.layer.addSublayer(border)
//        case .left:
//            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                   y: 0 + topOffset,
//                                                                   width: thickness,
//                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
//            self.layer.addSublayer(border)
//        }
//    }
//
//    public func addViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
//
//        switch side {
//        case .top:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                            y: 0 + topOffset,
//                                                                            width: self.frame.size.width - leftOffset - rightOffset,
//                                                                            height: thickness), color: color)
//            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
//            self.addSubview(border)
//
//        case .right:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
//                                                                            y: 0 + topOffset, width: thickness,
//                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
//            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
//            self.addSubview(border)
//
//        case .bottom:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                            y: self.frame.size.height-thickness-bottomOffset,
//                                                                            width: self.frame.size.width - leftOffset - rightOffset,
//                                                                            height: thickness), color: color)
//            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
//            self.addSubview(border)
//        case .left:
//            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
//                                                                            y: 0 + topOffset,
//                                                                            width: thickness,
//                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
//            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
//            self.addSubview(border)
//        }
//    }
//
//    //////////
//    // Private: Our methods call these to add their borders.
//    //////////
//
//
//    fileprivate func _getOneSidedBorder(frame: CGRect, color: UIColor) -> CALayer {
//        let border:CALayer = CALayer()
//        border.frame = frame
//        border.backgroundColor = color.cgColor
//        return border
//    }
//
//    fileprivate func _getViewBackedOneSidedBorder(frame: CGRect, color: UIColor) -> UIView {
//        let border:UIView = UIView.init(frame: frame)
//        border.backgroundColor = color
//        return border
//    }
//
//}

extension UIView {

    func addBorders(edges: UIRectEdge = .all, color: UIColor = .black, width: CGFloat = 1.0) {

        func createBorder() -> UIView {
            let borderView = UIView(frame: CGRect.zero)
            borderView.translatesAutoresizingMaskIntoConstraints = false
            borderView.backgroundColor = color
            return borderView
        }

        if (edges.contains(.all) || edges.contains(.top)) {
            let topBorder = createBorder()
            self.addSubview(topBorder)
            NSLayoutConstraint.activate([
                topBorder.topAnchor.constraint(equalTo: self.topAnchor),
                topBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                topBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                topBorder.heightAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.left)) {
            let leftBorder = createBorder()
            self.addSubview(leftBorder)
            NSLayoutConstraint.activate([
                leftBorder.topAnchor.constraint(equalTo: self.topAnchor),
                leftBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                leftBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                leftBorder.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.right)) {
            let rightBorder = createBorder()
            self.addSubview(rightBorder)
            NSLayoutConstraint.activate([
                rightBorder.topAnchor.constraint(equalTo: self.topAnchor),
                rightBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                rightBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                rightBorder.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.bottom)) {
            let bottomBorder = createBorder()
            self.addSubview(bottomBorder)
            NSLayoutConstraint.activate([
                bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                bottomBorder.heightAnchor.constraint(equalToConstant: width)
                ])
        }
    }
}
