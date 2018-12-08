//
//  Observer.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-02-09.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import UIKit

/// An observer that watches the EventParser to know when events are ready to be retrieved.
protocol EventObserver {
    func update()
    func presentAlert(alert: UIAlertController)
}
