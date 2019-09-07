//
//  EurekaFormProtocol.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-10-02.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

protocol EurekaFormProtocol {
    func createForm()
    func validateForm()
    
    var underlyingController: UIViewController? { get set }
}
