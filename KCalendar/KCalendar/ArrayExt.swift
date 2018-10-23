//
//  ArrayExt.swift
//  KCalendar
//
//  Created by Ken Lâm on 10/23/18.
//  Copyright © 2018 KPU. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
