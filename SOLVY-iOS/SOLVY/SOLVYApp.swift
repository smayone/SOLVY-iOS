import SwiftUI

@main
struct SOLVYApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                DashboardView()
            } else {
                LoginView()
            }
        }
    }
}
