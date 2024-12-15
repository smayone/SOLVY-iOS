import Foundation

enum Chain: String {
    case testnet
    case mainnet
    
    var endpoint: URL {
        switch self {
        case .testnet:
            return URL(string: "https://testnet.solvy.chain/endpoint")!
        case .mainnet:
            return URL(string: "https://solvy.chain/endpoint")!
        }
    }
    
    var chainId: Int {
        switch self {
        case .testnet:
            return 3 // Example testnet chain ID
        case .mainnet:
            return 1 // Example mainnet chain ID
        }
    }
    
    var explorerURL: URL {
        switch self {
        case .testnet:
            return URL(string: "https://explorer.testnet.solvy.chain")!
        case .mainnet:
            return URL(string: "https://explorer.solvy.chain")!
        }
    }
    
    var websocketEndpoint: URL {
        switch self {
        case .testnet:
            return URL(string: "wss://testnet.solvy.chain/ws")!
        case .mainnet:
            return URL(string: "wss://solvy.chain/ws")!
        }
    }
}

struct ChainConfig {
    #if DEBUG
    static let current: Chain = .testnet
    #else
    static let current: Chain = .mainnet
    #endif
    
    static var endpoint: URL {
        current.endpoint
    }
    
    static var chainId: Int {
        current.chainId
    }
    
    static var explorerURL: URL {
        current.explorerURL
    }
}
enum ChainConfig {
    static let endpoint = URL(string: "https://solvy.chain/endpoint")!
    static let chainId = 1 // Replace with actual chain ID
    
    #if DEBUG
    static let isTestnet = true
    #else
    static let isTestnet = false
    #endif
}
