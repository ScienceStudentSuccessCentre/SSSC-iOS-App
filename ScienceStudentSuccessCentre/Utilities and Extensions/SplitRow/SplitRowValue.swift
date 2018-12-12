//
//  SplitRowValue.swift
//  ScienceStudentSuccessCentre
//
//  Created by Avery Vine on 2018-11-25.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Eureka

/// This is not my code... good luck trying to debug it.
public struct SplitRowValue<L: Equatable, R: Equatable> {
    public var left: L?
    public var right: R?
    
    public init(left: L?, right: R?, id: String?) {
        self.left = left
        self.right = right
    }
    
    public init() {}
}

extension SplitRowValue: Equatable {
    public static func == (lhs: SplitRowValue, rhs: SplitRowValue) -> Bool {
        return lhs.left == rhs.left && lhs.right == rhs.right
    }
}
