//
//  ChangePasswordView.swift
//  IOSDev
//
//  Created by Chris Patrik Balquiedra Veneracion on 11/5/2025.
//


import SwiftUI

struct ChangePasswordView: View {
    @ObservedObject var userStore: UserStore
    @AppStorage("currentUserEmail") private var currentUserEmail = ""
    @Environment(\.dismiss) private var dismiss

    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Current Password")) {
                    SecureField("Old Password", text: $oldPassword)
                }

                Section(header: Text("New Password")) {
                    SecureField("New Password", text: $newPassword)
                    SecureField("Confirm Password", text: $confirmPassword)
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button("Change Password") {
                    if let userIndex = userStore.users.firstIndex(where: { $0.email == currentUserEmail }) {
                        if userStore.users[userIndex].password != oldPassword {
                            errorMessage = "Old password is incorrect"
                        } else if newPassword != confirmPassword {
                            errorMessage = "New passwords do not match"
                        } else {
                            userStore.users[userIndex].password = newPassword
                            userStore.saveUsers()
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Change Password")
        }
    }
}
