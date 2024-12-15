# SOLVY iOS App Directory Structure

## Models/
Core data models and structures:
1. `User.swift`
   - User model with authentication properties
   - Balance tracking
   - Core Data integration

2. `Transaction.swift`
   - Transaction model
   - Transaction types (deposit, withdrawal, transfer)
   - Status tracking

3. `BlockchainModels.swift`
   - Transaction request/response structures
   - Chain-specific models
   - Error types

## Views/
UI components organized by feature:

### Authentication/
1. `LoginView.swift`
   - User login interface
   - Error handling
   - Loading states

2. `RegisterView.swift`
   - New user registration
   - Form validation
   - Success/failure handling

### Dashboard/
1. `DashboardView.swift`
   - Main app interface
   - Navigation structure
   - Overview of user's status

2. `TransactionListView.swift`
   - List of transactions
   - Filtering options
   - Transaction details

3. `MetricsCardsView.swift`
   - Financial metrics display
   - Summary statistics
   - Visual indicators

### Components/
1. `TransactionRow.swift`
   - Individual transaction display
   - Status indicators
   - Action buttons

2. `ChartView.swift`
   - Transaction visualization
   - Time-based analytics
   - Interactive elements

3. `LoadingView.swift`
   - Loading states
   - Progress indicators
   - Error messages

## ViewModels/
Business logic and data management:

1. `AuthViewModel.swift`
   - Login/logout logic
   - User session management
   - Authentication state

2. `TransactionViewModel.swift`
   - Transaction operations
   - Data formatting
   - Business rules

3. `DashboardViewModel.swift`
   - Dashboard data management
   - Metrics calculations
   - State updates

## Services/
Backend and external service integration:

1. `NetworkService.swift`
   - API communication
   - Request/response handling
   - Error management

2. `Web3Service.swift`
   - Blockchain integration
   - Transaction signing
   - Chain communication

3. `KeychainService.swift`
   - Secure storage
   - Credentials management
   - Private key handling

## Config/
Configuration and environment settings:

1. `ChainConfig.swift`
   - Blockchain endpoints
   - Network configuration
   - Environment-specific settings

2. `AppConfig.swift`
   - App-wide constants
   - Feature flags
   - Environment variables

## Utilities/
Helper functions and extensions:

1. `CryptoUtils.swift`
   - Cryptographic operations
   - Hash functions
   - Signature verification

2. `DateFormatter.swift`
   - Date formatting
   - Timezone handling
   - Localization support

3. `NumberFormatter.swift`
   - Currency formatting
   - Unit conversion
   - Localization support

Each file should follow Swift best practices:
- Clear documentation
- Proper error handling
- Unit test coverage
- SwiftUI/Combine integration where appropriate
