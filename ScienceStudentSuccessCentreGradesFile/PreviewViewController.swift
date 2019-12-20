//
//  PreviewViewController.swift
//  ScienceStudentSuccessCentreGradesFile
//
//  Created by Avery Vine on 2019-12-20.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit
import QuickLook

class PreviewViewController: UIViewController, QLPreviewingController {
    @IBOutlet weak var ssscIcon: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        ssscIcon.layer.masksToBounds = true
        ssscIcon.layer.cornerRadius = 15
    }
    
    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        handler(nil)
    }

}
