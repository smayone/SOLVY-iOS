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
        print("\n🔐 Testing KeychainService functionality:")
        print("----------------------------------------")
        
        let keychain = KeychainService.shared
        let testKey = "test_key"
        let testValue = "test_value"
        
        // Test saving
        print("\n1. Testing Save Operation")
        switch keychain.save(key: testKey, value: testValue) {
        case .success:
            print("✅ Successfully saved value to keychain")
        case .failure(let error):
            print("❌ Failed to save to keychain: \(error.localizedDescription)")
        }
        
        // Test retrieving
        print("\n2. Testing Retrieve Operation")
        switch keychain.retrieve(key: testKey) {
        case .success(let value):
            print("✅ Successfully retrieved value: \(value)")
            if value == testValue {
                print("✅ Retrieved value matches saved value")
            } else {
                print("❌ Retrieved value does not match saved value")
            }
        case .failure(let error):
            print("❌ Failed to retrieve from keychain: \(error.localizedDescription)")
        }
        
        // Test deleting
        print("\n3. Testing Delete Operation")
        switch keychain.delete(key: testKey) {
        case .success:
            print("✅ Successfully deleted value from keychain")
        case .failure(let error):
            print("❌ Failed to delete from keychain: \(error.localizedDescription)")
        }
        
        // Verify deletion
        print("\n4. Verifying Deletion")
        switch keychain.retrieve(key: testKey) {
        case .success:
            print("❌ Value still exists in keychain after deletion")
        case .failure(let error):
            if case .itemNotFound = error {
                print("✅ Confirmed value was properly deleted")
            } else {
                print("❌ Unexpected error while verifying deletion: \(error.localizedDescription)")
            }
        }
        
        print("\n----------------------------------------")
        print("KeychainService testing completed\n")
    }
}
