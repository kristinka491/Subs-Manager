//
//  DateFormatterHepler.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 17.11.2022.
//
import Foundation

class DateFormatterHepler {

    static func getDateString(from date: Date) -> String {
        return DateFormatterHepler.dateFormatter.string(from: date)
    }

    static func getDate(from string: String) -> Date {
        return DateFormatterHepler.dateFormatter.date(from: string) ?? Date()
    }

    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
}
