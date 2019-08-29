//
//  HtmlString.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-09-11.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import UIKit

// MARK: - This extension essentially does some magic to ensure that HTML attributes (such as links and lists) in strings will display properly.
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let attr = try NSMutableAttributedString(data: data,
                                                     options: [.documentType: NSAttributedString.DocumentType.html,
                                                               .characterEncoding: String.Encoding.utf8.rawValue],
                                                     documentAttributes: nil)
            if #available(iOS 13.0, *) {
                attr.addAttribute(.foregroundColor,
                                 value: UIColor.label,
                                 range: NSRange(location: 0, length: attr.length))
            }
            return attr
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
