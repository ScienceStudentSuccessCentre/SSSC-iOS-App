//
//  Observer.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-02-09.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import UIKit

protocol EventObserver {
    func update()
    func presentAlert(alert: UIAlertController)
}
