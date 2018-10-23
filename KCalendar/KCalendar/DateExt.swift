//
//  DateExt.swift
//  KCalendar
//
//  Created by Ken Lâm on 10/23/18.
//  Copyright © 2018 KPU. All rights reserved.
//

import Foundation

extension String {
    func date(format: String, timeZone: TimeZone = .current) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        return formatter.date(from: self)!
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
