//
//  SegmentControlDelegate.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-29.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import UIKit

/// A protocol that lets other views control any view that has this protocol.
///
/// This protocol provides functions for interacting with `SegmentControl` objects.
protocol SegmentControlDelegate: class {
    func updateSegmentControlPosition(delta: CGFloat)
}
