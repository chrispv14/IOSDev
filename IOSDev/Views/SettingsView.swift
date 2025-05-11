import SwiftUI

struct SettingsView: View {
    @AppStorage("username") private var username = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("currentUserEmail") private var currentUserEmail = ""
    @AppStorage("isDarkMode") private var isDarkMode = false

    @ObservedObject var userStore = UserStore()

    @State private var showChangePassword = false
    @State private var showDeleteConfirmation = false

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
                    Section(header: Text("Manage Account")) {
                        Button("Change Password") {
                            showChangePassword = true
                        }

                        Button("Delete Account") {
                            showDeleteConfirmation = true
                        }
                        .foregroundColor(.red)
                    }

                    Section {
                        Button("Log Out") {
                            isLoggedIn = false
                            currentUserEmail = ""
                            username = ""
                        }
                        .foregroundColor(.red)
                    }
                }

                Section(header: Text("Preferences")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showChangePassword) {
                ChangePasswordView(userStore: userStore)
            }
            .alert("Delete Account?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    userStore.deleteUser(email: currentUserEmail)
                    isLoggedIn = false
                    currentUserEmail = ""
                    username = ""
                }
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
}
