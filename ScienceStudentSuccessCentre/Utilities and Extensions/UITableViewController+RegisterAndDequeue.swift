//
//  UITableViewController+RegisterAndDequeue.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2019-11-16.
//  Copyright © 2019 Avery Vine. All rights reserved.
//

import UIKit

protocol NibLoadableView: AnyObject {}
extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return "\(self)"
    }
}

protocol ReusableView: AnyObject {}
extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}

extension UICollectionReusableView: NibLoadableView, ReusableView {}
extension UITableViewCell: NibLoadableView, ReusableView {}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(for indexPath: IndexPath, kind: String) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue supplementary view with identifier: \(T.reuseIdentifier)")
        }
        return view
    }
}
