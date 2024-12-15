import Foundation

enum Environment {
    case development
    case staging
    case production
    
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        // You can customize this based on your build configuration
        return .production
        #endif
    }
}

struct AppConfig {
    static let shared = AppConfig()
    
    // API Configuration
    var apiBaseURL: URL {
        switch Environment.current {
        case .development:
            return URL(string: "https://dev-api.solvy.app")!
        case .staging:
            return URL(string: "https://staging-api.solvy.app")!
        case .production:
            return URL(string: "https://api.solvy.app")!
        }
    }
    
    // Feature Flags
    struct FeatureFlags {
        static let enableBlockchainFeatures = true
        static let enableBiometricAuth = true
        static let enablePushNotifications = true
        static let enableAnalytics = Environment.current != .development
    }
    
    // App Settings
    struct Settings {
        static let maximumTransactionAmount: Double = 10000.0
        static let minimumTransactionAmount: Double = 0.01
        static let transactionTimeoutSeconds: TimeInterval = 30.0
        static let sessionTimeoutMinutes: TimeInterval = 30.0
        static let maxRetryAttempts: Int = 3
        static let cacheExpirationHours: TimeInterval = 24.0
    }
    
    // UI Configuration
    struct UI {
        static let animationDuration: TimeInterval = 0.3
        static let cornerRadius: CGFloat = 12.0
        static let shadowRadius: CGFloat = 4.0
        static let defaultPadding: CGFloat = 16.0
        static let maximumCardWidth: CGFloat = 400.0
        
        struct Colors {
            static let primary = "007AFF"
            static let secondary = "5856D6"
            static let success = "34C759"
            static let warning = "FF9500"
            static let error = "FF3B30"
        }
        
        struct Fonts {
            static let titleSize: CGFloat = 28.0
            static let headlineSize: CGFloat = 20.0
            static let bodySize: CGFloat = 16.0
            static let captionSize: CGFloat = 12.0
        }
    }
    
    // Analytics Configuration
    struct Analytics {
        static let enabled = FeatureFlags.enableAnalytics
        static let sessionTimeout: TimeInterval = 1800 // 30 minutes
        static let maxEventsPerBatch = 100
        static let batchUploadInterval: TimeInterval = 60 // 1 minute
    }
    
    // Error Messages
    struct ErrorMessages {
        static let networkError = "Unable to connect to the server. Please check your internet connection."
        static let authenticationError = "Authentication failed. Please try again."
        static let transactionError = "Transaction failed. Please try again later."
        static let validationError = "Please check your input and try again."
        static let blockchainError = "Blockchain connection error. Please try again."
    }
}

// Extension for color conversion
extension AppConfig.UI.Colors {
    static func color(fromHex hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
