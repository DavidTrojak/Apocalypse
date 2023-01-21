//
//  Date+Extension.swift
//  Apocalypse
//
//  Created by David Trojak on 08.01.2023.
//

import Foundation

extension Date: RawRepresentable {
    
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func daysAgo() -> Int {
        let date = Date()
        return Calendar.current.dateComponents([.day], from: self, to: date).day ?? 0
    }
}
