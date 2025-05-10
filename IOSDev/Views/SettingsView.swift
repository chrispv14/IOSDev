import SwiftUI

struct SettingsView: View {
    @AppStorage("username") private var username = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("currentUserEmail") private var currentUserEmail = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Logged in as")) {
                    if currentUserEmail.isEmpty {
                        Text("Not logged in")
                    } else {
                        Text(currentUserEmail)
                            .fontWeight(.medium)
                    }
                }

              
                if isLoggedIn {
                    Section {
                        Button("Log Out") {
                            isLoggedIn = false
                            currentUserEmail = ""
                            username = ""
                        }
                        .foregroundColor(.red)
                    }
                }

            }
            .navigationTitle("Settings")
        }
    }
}
