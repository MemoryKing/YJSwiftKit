/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ 
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit
import Foundation

public class DateFormattersManager {
    public static var dateFormatters: SynchronizedDictionary = SynchronizedDictionary<String, DateFormatter>()
}
//MARK: -------   转换
public extension Date {
    ///date --> string
    func yi_toString(_ dateFormat : String = "yyyy-MM-dd HH:mm:ss",_ timeZone : TimeZone = NSTimeZone.system) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        formatter.timeZone = timeZone
        let date = formatter.string(from: self)
        return date
    }
    
    ///  将日期转换为字符串
    func yi_toString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
    
    ///  将日期转换为具有格式的字符串
    func yi_toString(format: String) -> String {
        
        let dateFormatter = yi_getDateFormatter(for: format)
        return dateFormatter.string(from: self)
    }
}

public extension Date {
    
    static let minutesInAWeek = 24 * 60 * 7
    ///  初始化
    init?(fromString string: String,
                 format: String,
                 timezone: TimeZone = TimeZone.autoupdatingCurrent,
                 locale: Locale = Locale.current) {
        if let dateFormatter = DateFormattersManager.dateFormatters.getValue(for: format) {
            if let date = dateFormatter.date(from: string) {
                self = date
            } else {
                return nil
            }
        } else {
            let formatter = DateFormatter()
            formatter.timeZone = timezone
            formatter.locale = locale
            formatter.dateFormat = format
            DateFormattersManager.dateFormatters.setValue(for: format, value: formatter)
            if let date = formatter.date(from: string) {
                self = date
            } else {
                return nil
            }
        }
    }
    
    ///  Initializes Date from string returned from an http response, according to several RFCs / ISO
    init?(httpDateString: String) {
        if let rfc1123 = Date(fromString: httpDateString, format: "EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz") {
            self = rfc1123
            return
        }
        if let rfc850 = Date(fromString: httpDateString, format: "EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z") {
            self = rfc850
            return
        }
        if let asctime = Date(fromString: httpDateString, format: "EEE MMM d HH':'mm':'ss yyyy") {
            self = asctime
            return
        }
        if let iso8601DateOnly = Date(fromString: httpDateString, format: "yyyy-MM-dd") {
            self = iso8601DateOnly
            return
        }
        if let iso8601DateHrMinOnly = Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mmxxxxx") {
            self = iso8601DateHrMinOnly
            return
        }
        if let iso8601DateHrMinSecOnly = Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mm:ssxxxxx") {
            self = iso8601DateHrMinSecOnly
            return
        }
        if let iso8601DateHrMinSecMs = Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mm:ss.SSSxxxxx") {
            self = iso8601DateHrMinSecMs
            return
        }
        return nil
    }
    
    ///  格式化
    private func yi_getDateFormatter(for format: String) -> DateFormatter {
        
        var dateFormatter: DateFormatter?
        if let _dateFormatter = DateFormattersManager.dateFormatters.getValue(for: format) {
             dateFormatter = _dateFormatter
        } else {
            dateFormatter = yi_createDateFormatter(for: format)
        }
        
        return dateFormatter!
    }
    
    /// 格式化
    private func yi_createDateFormatter(for format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        DateFormattersManager.dateFormatters.setValue(for: format, value: formatter)
        return formatter
    }
    
    //MARK: -------   计算
    ///  计算从现在经过了多少天
    func yi_daysInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff/86400)
        return diff
    }
    
    ///  计算从现在经过了多少小时
    func yi_hoursInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff/3600)
        return diff
    }
    
    ///  计算从现在经过了多少分钟
    func yi_minutesInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff/60)
        return diff
    }
    
    ///  计算从现在经过了多少秒
    func yi_secondsInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff)
        return diff
    }
    
    ///  Easy creation of time passed String. Can be Years, Months, days, hours, minutes or seconds
    func yi_timePassed() -> String {
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self, to: date, options: [])
        var str: String
        
        if components.year! >= 1 {
            components.year == 1 ? (str = "year") : (str = "years")
            return "\(components.year!) \(str) ago"
        } else if components.month! >= 1 {
            components.month == 1 ? (str = "month") : (str = "months")
            return "\(components.month!) \(str) ago"
        } else if components.day! >= 1 {
            components.day == 1 ? (str = "day") : (str = "days")
            return "\(components.day!) \(str) ago"
        } else if components.hour! >= 1 {
            components.hour == 1 ? (str = "hour") : (str = "hours")
            return "\(components.hour!) \(str) ago"
        } else if components.minute! >= 1 {
            components.minute == 1 ? (str = "minute") : (str = "minutes")
            return "\(components.minute!) \(str) ago"
        } else if components.second! >= 1 {
            components.second == 1 ? (str = "second") : (str = "seconds")
            return "\(components.second!) \(str) ago"
        } else {
            return "Just now"
        }
    }
    
    ///  Easy creation of time passed String. Can be Years, Months, days, hours, minutes or seconds. Useful for localization
    func yi_timePassed() -> TimePassed {
        
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self, to: date, options: [])
        
        if components.year! >= 1 {
            return TimePassed.year(components.year!)
        } else if components.month! >= 1 {
            return TimePassed.month(components.month!)
        } else if components.day! >= 1 {
            return TimePassed.day(components.day!)
        } else if components.hour! >= 1 {
            return TimePassed.hour(components.hour!)
        } else if components.minute! >= 1 {
            return TimePassed.minute(components.minute!)
        } else if components.second! >= 1 {
            return TimePassed.second(components.second!)
        } else {
            return TimePassed.now
        }
    }
    
    //MARK: -------   检测
    ///  是否未来
    var yi_isFuture: Bool {
        return self > Date()
    }
    
    ///  是否过去
    var yi_isPast: Bool {
        return self < Date()
    }
    
    //  今天
    var yi_isToday: Bool {
        let format = "yyyy-MM-dd"
        let dateFormatter = yi_getDateFormatter(for: format)
        return dateFormatter.string(from: self) == dateFormatter.string(from: Date())
    }
    
    ///  昨天
    var yi_isYesterday: Bool {
        let format = "yyyy-MM-dd"
        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let dateFormatter = yi_getDateFormatter(for: format)
        return dateFormatter.string(from: self) == dateFormatter.string(from: yesterDay!)
    }
    
    ///  明天
    var yi_isTomorrow: Bool {
        let format = "yyyy-MM-dd"
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let dateFormatter = yi_getDateFormatter(for: format)
        
        return dateFormatter.string(from: self) == dateFormatter.string(from: tomorrow!)
    }
    
    ///  在本月内
    var yi_isThisMonth: Bool {
        let today = Date()
        return self.yi_month == today.yi_month && self.yi_year == today.yi_year
    }
    
    ///  在本周内
    var yi_isThisWeek: Bool {
        return self.yi_minutesInBetweenDate(Date()) <= Double(Date.minutesInAWeek)
    }
    
    ///  era
    var yi_era: Int {
        return Calendar.current.component(Calendar.Component.era, from: self)
    }
    
    ///  年
    var yi_year: Int {
        return Calendar.current.component(Calendar.Component.year, from: self)
    }
    
    ///  月
    var yi_month: Int {
        return Calendar.current.component(Calendar.Component.month, from: self)
    }
    
    ///  工作日
    var yi_weekdayString: String {
        let format = "EEEE"
        let dateFormatter = yi_getDateFormatter(for: format)
        return dateFormatter.string(from: self)
    }
    
    ///  月
    var yi_monthString: String {
        let format = "MMMM"
        let dateFormatter = yi_getDateFormatter(for: format)
        return dateFormatter.string(from: self)
    }
    
    ///  天
    var yi_day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    ///  时
    var yi_hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    ///  分钟
    var yi_minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    ///  秒
    var yi_second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    ///  纳秒
    var yi_nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self)
    }
    
}

public enum TimePassed {
    case year(Int)
    case month(Int)
    case day(Int)
    case hour(Int)
    case minute(Int)
    case second(Int)
    case now
}

extension TimePassed: Equatable {
    
    public static func ==(lhs: TimePassed, rhs: TimePassed) -> Bool {
        
        switch(lhs, rhs) {
            
        case (.year(let a), .year(let b)):
            return a == b
            
        case (.month(let a), .month(let b)):
            return a == b
            
        case (.day(let a), .day(let b)):
            return a == b
            
        case (.hour(let a), .hour(let b)):
            return a == b
            
        case (.minute(let a), .minute(let b)):
            return a == b
            
        case (.second(let a), .second(let b)):
            return a == b
            
        case (.now, .now):
            return true
            
        default:
            return false
        }
    }
}

public class SynchronizedDictionary <Key: Hashable, Value> {
    
    fileprivate let queue = DispatchQueue(label: "SynchronizedDictionary", attributes: .concurrent)
    fileprivate var dict = [Key: Value]()
    
    public func getValue(for key: Key) -> Value? {
        var value: Value?
        queue.sync {
            value = dict[key]
        }
        return value
    }
    
    public func setValue(for key: Key, value: Value) {
        queue.sync {
            dict[key] = value
        }
    }
    public func getSize() -> Int {
        return dict.count
    }
    
    public func containValue(for key: Key) -> Bool {
        return (dict.index(forKey: key) != nil)
    }
    
}

//MARK: -------   前后时间
public extension Date {
    ///加几天
    func yi_addingDay(_ days: Int) -> Date {
        var c = DateComponents()
        c.day = days
        let calender = Calendar(identifier: .chinese)
        
        return calender.date(byAdding: c, to: self)!
    }
    ///减几天
    func yi_subtractingDay(_ days: Int) -> Date {
        var c = DateComponents()
        c.day = days * -1
        let calender = Calendar(identifier: .chinese)
        
        return calender.date(byAdding: c, to: self)!
    }
    ///增加几小时
    func yi_addingHours(_ dHours: Int) -> Date {
        let aTimeInterval = TimeInterval(timeIntervalSinceReferenceDate + Double(60 * 60 * dHours))
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    ///减少几小时
    func yi_subtractingHours(_ dHours: Int) -> Date {
        let aTimeInterval = TimeInterval(timeIntervalSinceReferenceDate - Double(60 * 60 * dHours))
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
}
