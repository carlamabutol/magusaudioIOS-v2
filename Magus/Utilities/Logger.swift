//
//  Logger.swift
//  Magus
//
//  Created by Jomz on 6/19/23.
//

import Foundation

struct Logger {
    
    private static var reportableLogLevels: Set<Log.Level> = [.error]
    
    private static func log(level: Log.Level, topic: Log.Topic, message: String) {
        let log = Log(level: level, topic: topic, message: message)
        if level.shouldPrintLog {
            print(log.output)
        }
        if reportableLogLevels.contains(level) {
            let error = NSError(domain: "Logger", code: 0, userInfo: log.userInfo)
            // TODO: Crashlytics
        }
    }
    
    static func fatal(_ message: String, topic: Log.Topic) -> Never {
        log(level: .fatal, topic: topic, message: message)
        let log = Log(level: .fatal, topic: topic, message: message)
        fatalError(String(describing: log.userInfo))
    }
    
    static func error(_ message: String, topic: Log.Topic) {
        log(level: .error, topic: topic, message: message)
    }
    
    static func warning(_ message: String, topic: Log.Topic) {
        log(level: .warning, topic: topic, message: message)
    }
    
    static func info(_ message: String, topic: Log.Topic) {
        log(level: .info, topic: topic, message: message)
    }
    
    static func verbose(_ message: String, topic: Log.Topic) {
        log(level: .verbose, topic: topic, message: message)
    }
    
}

// MARK: - Log

struct Log {
    
    private static let dateFormatter = DateFormatter()
    
    let timestamp = Date()
    let level: Level
    let topic: Topic
    let message: String
    
    var output: String {
        Self.dateFormatter.dateFormat = "dd-MM-yy HH:mm:ss.SSS"
        let date = Self.dateFormatter.string(from: timestamp)
        return "LOGGDER: [\(date)] [\(level.rawValue)] \(topic.rawValue): \(message)"
    }
    
    var userInfo: [String: Any] {
        [
            "level": level.rawValue,
            "topic": topic.rawValue,
            "message": message
        ]
    }
    
    enum Topic: String {
        case appState = "App State"
        case configuration = "Configuration"
        case other = "Other"
        case debug = "Debug"
        case domain = "Domain"
        case network = "Network"
        case presentation = "Presentation"
    }
    
    enum Level: String {
        case fatal = " Fatal "
        case error = " Error "
        case warning = " Warning "
        case info = " Info "
        case verbose = " Verbose "
        
        var shouldPrintLog: Bool {
            // TODO: - add condition release
            return true
        }
    }
    
}
