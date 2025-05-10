import SwiftUI

struct SettingsView: View {
    @AppStorage("username") private var username = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Settings")) {
                    TextField("Username", text: $username)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
