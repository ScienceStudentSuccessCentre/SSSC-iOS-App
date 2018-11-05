//
//  SegmentControlDelegate.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-29.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import UIKit

protocol SegmentControlDelegate: class {
    func updateSegmentControlPosition(delta: CGFloat)
}
