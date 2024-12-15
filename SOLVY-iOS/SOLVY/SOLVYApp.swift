import SwiftUI

@main
struct SOLVYApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            LoadingView("Initializing...")
                .onAppear {
                    // Test KeychainService functionality
                    testKeychainService()
                }
        }
    }
    
    private func testKeychainService() {
        let keychain = KeychainService.shared
        
        // Test saving
        let testKey = "test_key"
        let testValue = "test_value"
        
        let saveResult = keychain.save(key: testKey, value: testValue)
        print("Save result: \(saveResult)")
        
        // Test retrieving
        let retrieveResult = keychain.retrieve(key: testKey)
        print("Retrieve result: \(retrieveResult)")
        
        // Test deleting
        let deleteResult = keychain.delete(key: testKey)
        print("Delete result: \(deleteResult)")
        
        // Verify deletion
        let verifyResult = keychain.retrieve(key: testKey)
        print("Verify deletion result: \(verifyResult)")
    }
}
