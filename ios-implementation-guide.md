# SOLVY iOS Implementation Guide

## API Endpoints

### Authentication
- POST `/api/register`
  - Request Body: `{ username: string, password: string }`
  - Response: `{ message: string, user: { id: number, username: string } }`

- POST `/api/login`
  - Request Body: `{ username: string, password: string }`
  - Response: `{ message: string, user: { id: number, username: string } }`

- POST `/api/logout`
  - Response: `{ message: string }`

- GET `/api/user`
  - Response: User object or 401 if not authenticated

### Transactions
- GET `/api/transactions`
  - Authentication: Required
  - Response: Array of transaction objects

- POST `/api/transactions`
  - Authentication: Required
  - Request Body: `{ amount: number, type: "deposit" | "withdrawal" | "transfer", description?: string }`
  - Response: Transaction object

## Data Models

### User
```swift
struct User: Codable {
    let id: Int
    let username: String
    let createdAt: Date
}
```

### Transaction
```swift
enum TransactionType: String, Codable {
    case deposit
    case withdrawal
    case transfer
}

enum TransactionStatus: String, Codable {
    case pending
    case completed
    case failed
}

struct Transaction: Codable {
    let id: Int
    let userId: Int
    let amount: Decimal
    let type: TransactionType
    let status: TransactionStatus
    let description: String?
    let createdAt: Date
}
```

## Implementation Steps

1. Project Setup
   - Create new Xcode project with App ID: "XC S A -Nathan SS-sub-Project (S.A.-Nathan.SS-sub-Project)"
   - Set up SwiftUI as the UI framework
   - Configure API client using URLSession

2. Authentication Flow
   - Implement login/register screens
   - Set up secure token storage using Keychain
   - Handle session management

3. Main Features
   - Dashboard with transaction summary
   - Transaction list with filtering
   - New transaction creation
   - Charts and analytics

4. iOS-Specific Considerations
   - Use SwiftUI for modern UI development
   - Implement biometric authentication
   - Handle offline mode
   - Push notifications for transaction updates

5. Web3 Integration
   - Prepare for integration with solvy.chain domain
   - Consider wallet connectivity options

## Required Dependencies

1. Charts
   - SwiftUICharts or Charts framework for transaction visualization

2. Networking
   - URLSession for API calls
   - Combine for reactive programming

3. Security
   - Keychain for secure storage
   - CryptoKit for encryption

4. Additional
   - SwiftDate for date handling
   - SDWebImage for image caching
   - KeychainAccess for keychain wrapper

## Design Guidelines

1. Follow iOS Human Interface Guidelines
2. Maintain SOLVY brand identity
3. Support both light and dark mode
4. Implement dynamic type for accessibility

## Web3 Integration Guide
This guide will help you understand how to connect your SOLVY app to the blockchain world. We'll explain everything step by step, in simple terms.

### What You Need to Know First

#### What is Web3? 🌐
Think of Web3 as a new kind of internet where:
- You own your data (like your profile and transactions)
- No single company controls everything
- Everything is more secure and transparent
- You can prove you own digital things (like your account)

#### What is solvy.chain? 🔗
- It's like a website address (like www.google.com) but for blockchain
- Instead of .com, it ends with .chain
- It's YOUR special address for the SOLVY app
- It's more secure than regular website addresses

### How We'll Add This to Your App

#### Step 1: Getting Started 📱
First, we'll add the tools we need:
```swift
// This helps us talk to the blockchain
import Web3Swift

// Your basic setup will look like this:
class BlockchainHelper {
    // This will hold your app's connection to the blockchain
    let web3 = Web3.init()
    
    // More code will be added here as we build features
}
```

#### Step 2: Connecting to solvy.chain 🔌
We'll create simple functions to use your domain:
```swift
class DomainManager {
    // This checks if solvy.chain is working
    func checkDomain() {
        // We'll add the actual code here later
        // It will be explained step by step
        print("Checking solvy.chain connection...")
    }
}
```

#### Step 3: Adding a Wallet 👛
A wallet is like a bank account for blockchain. Here's how we'll add it:
```swift
class WalletManager {
    // This will let users connect their wallet
    func connectWallet() {
        // We'll add more code here later
        // It will handle connecting to wallets
        print("Connecting to wallet...")
    }
}
```

### When We'll Build Each Part 📅

1. First Week:
   - Add the basic tools
   - Make sure we can connect to blockchain
   - Test that solvy.chain works

2. Second Week:
   - Add the wallet connection
   - Let users sign in with their wallet
   - Make sure everything is secure

3. Final Week:
   - Connect everything together
   - Test that it all works
   - Make sure it's ready for the App Store

### Helpful Resources 📚

#### For Beginners:
1. Start Here:
   - Watch "Intro to Web3" videos on YouTube
   - Read the Web3Swift getting started guide
   - Try some basic blockchain apps

2. Next Steps:
   - Learn about wallets
   - Understand basic blockchain security
   - Practice with test networks (they're free and safe to use)

### Keeping Everything Safe 🔒

1. Protecting User Data:
   - We'll store sensitive information securely
   - Everything will be encrypted
   - We'll follow Apple's security guidelines

2. Testing:
   - We'll test everything thoroughly
   - Start with test networks (no real money involved)
   - Move to real networks only when everything is perfect

Remember: We'll take this step by step, and you can ask questions anytime! 😊

## Required Dependencies

1. Charts
   - SwiftUICharts or Charts framework for transaction visualization

2. Networking
   - URLSession for API calls
   - Combine for reactive programming

3. Security
   - Keychain for secure storage
   - CryptoKit for encryption

4. Additional
   - SwiftDate for date handling
   - SDWebImage for image caching
   - KeychainAccess for keychain wrapper

## Design Guidelines

1. Follow iOS Human Interface Guidelines
2. Maintain SOLVY brand identity
3. Support both light and dark mode
4. Implement dynamic type for accessibility

## Development Plan (Step by Step) 🚀

### Week 1: Basic Setup and Structure
1. Day 1-2: Project Setup
   - Create new Xcode project
     * Bundle ID: "XC S A -Nathan SS-sub-Project (S.A.-Nathan.SS-sub-Project)"
     * iOS Deployment Target: iOS 15.0 or later
     * Interface: SwiftUI
     * Language: Swift
     * Core Data: Yes (for offline support)
     * Include Tests: Yes
   - Project Structure:
     * /Models (Data models and CoreData entities)
        - Transaction.swift (Transaction model)
        - User.swift (User model)
        - CoreDataModels.xcdatamodeld (Core Data schema)
     * /Views (SwiftUI views)
        - Authentication
          - LoginView.swift (Login screen)
          - RegisterView.swift (Registration screen)
        - Dashboard
          - DashboardView.swift (Main dashboard)
          - TransactionListView.swift (List of transactions)
          - TransactionDetailView.swift (Transaction details)
        - Components
          - ChartView.swift (Reusable chart component)
          - LoadingView.swift (Loading indicator)
          - ErrorView.swift (Error handling view)
          - EmptyStateView.swift (Empty state placeholder)
     * /ViewModels (Business logic)
        - AuthViewModel.swift (Authentication logic)
        - TransactionViewModel.swift (Transaction management)
        - DashboardViewModel.swift (Dashboard data)
        - AppStateViewModel.swift (Global app state)
     * /Services (API and Web3 services)
        - NetworkService.swift (API client)
        - Web3Service.swift (Blockchain integration)
        - CoreDataService.swift (Local storage)
        - KeychainService.swift (Secure storage)
        - AnalyticsService.swift (Usage tracking)
     * /Utilities (Helper functions)
        - Constants.swift (App-wide constants)
        - Extensions.swift (Swift extensions)
        - Formatters.swift (Date and number formatting)
        - Logger.swift (Custom logging)
        - Environment.swift (Environment configuration)
     * /Resources (Assets and configuration)
        - Assets.xcassets (Images and colors)
        - Info.plist (App configuration)
        - Colors.xcassets (Custom color palette)
        - Localizable.strings (Localization)
   - Configure core dependencies:
     * SwiftUI for UI
     * Combine for reactive programming
     * CoreData for local storage
     * URLSession for networking
### Blockchain Integration Guide (solvy.chain)

#### 1. Web3 Setup
1. Dependencies:
   - Web3Swift for Ethereum interactions
   - KeychainAccess for secure key storage
   ```swift
   // Add via Swift Package Manager
   .package(url: "https://github.com/web3swift-team/web3swift.git", from: "3.0.0")
   .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2")
   ```

2. Configuration:
   ```swift
   class Web3Service {
       private let web3: web3
       private let chainURL: String = "https://solvy.chain/rpc"  // Replace with actual RPC endpoint
       
       init() {
           guard let url = URL(string: chainURL) else {
               fatalError("Invalid chain URL")
           }
           web3 = try! Web3.new(url)
       }
   }
   ```

#### 2. Connection Methods
1. Establish Connection:
   ```swift
   func connect() async throws {
       // Verify chain connection
       let networkID = try await web3.net.version()
       guard networkID == "solvy" else {  // Replace with actual chain ID
           throw Web3Error.wrongNetwork
       }
   }
   ```

2. Wallet Integration:
   ```swift
   func createWallet() throws -> Wallet {
       let keystore = try! EthereumKeystoreV3(password: "user_password")
       let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
       
       // Store securely in Keychain
       let keychain = Keychain(service: "com.solvy.keystore")
       keychain["wallet"] = String(data: keyData, encoding: .utf8)
       
       return Wallet(keystore: keystore)
   }
   ```

#### 3. Transaction Handling
1. Send Transaction:
   ```swift
   func sendTransaction(to: String, amount: BigUInt) async throws -> String {
       let wallet = try loadWallet()
       let transaction = try await web3.eth.sendTransaction(
           to: EthereumAddress(to)!,
           value: amount,
           from: wallet.address
       )
       return transaction.hash
   }
   ```

2. Monitor Transaction:
   ```swift
   func monitorTransaction(hash: String) async throws -> TransactionStatus {
       let receipt = try await web3.eth.getTransactionReceipt(hash)
       return receipt.status ? .success : .failed
   }
   ```

#### 4. Security Considerations
1. Private Key Storage:
   - Use Keychain for secure storage
   - Never store private keys in UserDefaults or plain text
   - Implement biometric authentication

2. Transaction Security:
   - Verify all transaction parameters
   - Implement transaction signing confirmation
   - Add rate limiting for sensitive operations

3. Error Handling:
   ```swift
   enum Web3Error: Error {
       case wrongNetwork
       case transactionFailed
       case insufficientFunds
       case unauthorized
   }
   ```

#### 5. Integration Points
1. Dashboard Integration:
   ```swift
   class DashboardViewModel: ObservableObject {
       private let web3Service: Web3Service
       
       @Published var balance: String = "0"
       @Published var transactions: [Transaction] = []
       
       func refreshBalance() async {
           let balanceWei = try? await web3Service.getBalance()
           balance = Web3.Utils.formatToEth(balanceWei ?? 0)
       }
   }
   ```

2. Transaction Flow:
   ```swift
   class TransactionViewModel: ObservableObject {
       private let web3Service: Web3Service
       
       func executeTransaction(amount: String, to: String) async throws {
           guard let wei = Web3.Utils.parseToBigUInt(amount, units: .eth) else {
               throw Web3Error.invalidAmount
           }
           
           let hash = try await web3Service.sendTransaction(to: to, amount: wei)
           try await monitorAndUpdateTransaction(hash: hash)
       }
   }
   ```

Remember:
- Always test on a test network first
- Implement proper error handling
- Keep sensitive data secure
- Monitor transaction status
- Provide clear user feedback
3. Initial Setup Steps:
   a. Prerequisites:
      1. Install Latest Xcode from Mac App Store
      2. Apple Developer Account (Free or Paid)
      3. macOS Ventura or later
      4. At least 20GB free disk space

   b. Create Xcode Project:
      1. Open Xcode
      2. Choose "Create a new Xcode project"
      3. Select "App" under iOS
      4. Fill in project details:
#### 5. Blockchain Integration - Connecting to solvy.chain

1. Web3 Service Setup:
   ```swift
   class Web3Service {
       private let chainURL = "https://solvy.chain/endpoint"
       private var provider: Web3Provider
       
       init() {
           self.provider = Web3Provider(url: chainURL)
       }
       
       func connect() async throws {
           // Establish connection to solvy.chain
           try await provider.connect()
       }
       
       func sendTransaction(to: String, amount: Double) async throws -> String {
           // Create and sign transaction
           let transaction = Transaction(
               to: to,
               value: amount,
               chainId: Chain.solvy.id
           )
           
           return try await provider.sendTransaction(transaction)
       }
       
       func monitorTransaction(hash: String) async throws -> TransactionStatus {
           // Monitor transaction status
           let receipt = try await provider.getTransactionReceipt(hash)
           return receipt.status
       }
   }
   ```

2. Integration Points:
   ```swift
   class TransactionViewModel {
       private let web3Service: Web3Service
       
       init(web3Service: Web3Service = Web3Service()) {
           self.web3Service = web3Service
       }
       
       func executeTransaction(amount: String, to: String) async throws {
           // Validate input
           guard let value = Double(amount) else {
               throw TransactionError.invalidAmount
           }
           
           // Send to blockchain
           let hash = try await web3Service.sendTransaction(
               to: to,
               amount: value
           )
           
           // Monitor status
           let status = try await web3Service.monitorTransaction(hash: hash)
           self.updateTransactionStatus(status)
       }
   }
   ```

3. Key Components:
   - Chain Configuration
     ```swift
     enum Chain {
         case solvy
         
         var id: Int {
             switch self {
             case .solvy:
                 return 1 // Replace with actual chain ID
             }
         }
         
         var endpoint: URL {
             switch self {
             case .solvy:
                 return URL(string: "https://solvy.chain/endpoint")!
             }
         }
     }
     ```

   - Error Handling
     ```swift
     enum BlockchainError: Error {
         case connectionFailed
         case transactionFailed
         case invalidAddress
         case insufficientFunds
     }
     ```

4. Security Considerations:
   - Store private keys in Keychain
   - Use secure connections (HTTPS)
   - Implement proper error handling
   - Validate all inputs
   - Use testnet for development

5. Best Practices:
   - Cache blockchain data when possible
   - Implement retry mechanisms
   - Show loading states during blockchain operations
   - Provide clear feedback to users
   - Log important events

6. Testing:
   ```swift
   class BlockchainTests: XCTestCase {
       var web3Service: Web3Service!
       
       override func setUp() {
           web3Service = Web3Service()
       }
       
       func testConnection() async throws {
           XCTAssertNoThrow(try await web3Service.connect())
       }
       
       func testTransaction() async throws {
           let hash = try await web3Service.sendTransaction(
               to: "test_address",
               amount: 1.0
           )
           XCTAssertNotNil(hash)
       }
   }
   ```

Remember:
- Always test on testnet first
- Handle network errors gracefully
- Monitor transaction status
- Keep private keys secure
- Document all blockchain interactions
#### 6. Testing Integration

1. Unit Tests:
   ```swift
   class Web3ServiceTests: XCTestCase {
       var web3Service: Web3Service!
       
       override func setUp() {
           web3Service = Web3Service()
       }
       
       func testConnection() async throws {
           // Test chain connection
           XCTAssertNoThrow(try await web3Service.connect())
       }
       
       func testTransactionFlow() async throws {
           // Test complete transaction flow
           let hash = try await web3Service.sendTransaction(
               to: "test_address",
               amount: 1000000
           )
           let status = try await web3Service.monitorTransaction(hash: hash)
           XCTAssertEqual(status, .success)
       }
   }
   ```

2. Integration Tests:
   ```swift
   class BlockchainIntegrationTests: XCTestCase {
       func testEndToEndTransaction() async throws {
           // Test complete flow from UI to blockchain
           let viewModel = TransactionViewModel()
           try await viewModel.executeTransaction(
               amount: "0.1",
               to: "test_recipient"
           )
           
           // Verify transaction status
           XCTAssertEqual(viewModel.status, .completed)
       }
   }
   ```

Remember:
- Use test networks for development
- Mock blockchain responses in unit tests
- Test error scenarios
- Verify transaction confirmation
- Test UI feedback during transactions
         - Product Name: "SOLVY"
         - Team: Your Apple Developer Team
         - Organization Identifier: "com.solvy"
         - Bundle Identifier: "XC S A -Nathan SS-sub-Project (S.A.-Nathan.SS-sub-Project)"
         - Interface: SwiftUI
         - Language: Swift
         - Storage: Use Core Data
         - Include Tests: Yes
      5. Choose project location: Create a new folder named "SOLVY-iOS"
      6. After project creation:
         - Open the project navigator (⌘1)
         - Review the project settings
         - Set deployment target to iOS 15.0

2. Development Best Practices:
   - Follow MVVM architecture pattern
   - Use Swift Package Manager for dependencies
   - Implement error handling and loading states
   - Support offline functionality
   - Follow Apple's Human Interface Guidelines
   - Write unit tests for business logic
   - Document code with clear comments

3. Initial Setup Steps:
   a. Prerequisites:
      1. Install Latest Xcode from Mac App Store
      2. Apple Developer Account (Free or Paid)
      3. macOS Ventura or later
      4. At least 20GB free disk space

   b. Create Xcode Project:
      1. Open Xcode
      2. Choose "Create a new Xcode project"
      3. Select "App" under iOS
      4. Fill in project details:
         - Product Name: "SOLVY"
         - Team: Your Apple Developer Team
         - Organization Identifier: "com.solvy"
         - Bundle Identifier: "XC S A -Nathan SS-sub-Project (S.A.-Nathan.SS-sub-Project)"
         - Interface: SwiftUI
         - Language: Swift
         - Storage: Use Core Data
         - Include Tests: Yes
      5. Choose project location: Create a new folder named "SOLVY-iOS"
      6. After project creation:
         - Open the project navigator (⌘1)
         - Review the project settings
         - Set deployment target to iOS 15.0

   b. Configure Git:
      1. Initialize Git repository
      2. Create .gitignore for Xcode
      3. Make initial commit

   c. Set Up Dependencies:
      1. File > Add Packages
      2. Add required packages:
         - Charts for visualization
         - Web3Swift for blockchain
         - KeychainAccess for secure storage

2. Day 3-4: Core Features
   - Set up networking layer
   - Create basic models
   - Add authentication screens

3. Day 5: Basic UI
   - Create main dashboard
   - Add navigation
   - Test basic flow

### Week 2: Main Features
1. Day 1-3: Transactions
   - Add transaction list
   - Create new transaction form
   - Show transaction details

2. Day 4-5: Charts and Stats
   - Add transaction charts
   - Show statistics
   - Polish UI

### Week 3: Web3 and Polish
1. Day 1-3: Web3 Setup
   - Add Web3Swift
   - Connect to solvy.chain
   - Test blockchain features

2. Day 4-5: Final Steps
   - Add error handling
   - Polish animations
   - Prepare for App Store

### Understanding the Architecture 🏗️

#### 1. Data Flow
- User interacts with Views
- Views notify ViewModels
- ViewModels process data and update Models
- Services handle external communication
- Models update and Views reflect changes

#### 2. Component Responsibilities
1. Views (SwiftUI)
   - Display data to user
   - Handle user input
   - Show loading states
   - Display error messages

2. ViewModels
   - Process user actions
   - Format data for display
   - Handle business logic
   - Manage state

3. Models
   - Define data structure
   - Store application data
   - Handle data validation

4. Services
   - API communication
   - Local data storage
   - Blockchain interaction
   - Error handling

### Testing the Blockchain Integration:

1. Opening the Project:
   - Open Xcode
   - Navigate to the "SOLVY-iOS" folder
   - Double-click "SOLVY.xcodeproj"
   - Wait for project indexing to complete

2. Running the Preview:
   - In the Navigator (left sidebar), open Views > Dashboard > DashboardView.swift
   - Click the "Resume" button in the preview canvas on the right
   - You should see:
     * A red/green status dot indicating blockchain connection
     * A "Test Chain" button
     * Transaction metrics and charts

3. Testing the Integration:
   - Click the "Test Chain" button
   - Watch the console for transaction hash output
   - The status indicator should turn green when connected
   - Check transaction history for the test transaction

4. Troubleshooting:
   - If preview doesn't load: Clean build folder (Shift + Cmd + K)
   - If connection fails: Check console for detailed error messages
   - For API key issues: Verify KeychainService configuration

Remember:
- We're using the testnet configuration for development
- All transactions are test transactions
- Check the console log for detailed feedback
- Ask questions if you need help! 😊
