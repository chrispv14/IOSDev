import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    var userStore: UserStore

    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var licenseNumber = ""
    @State private var dateOfBirth = Date()
    @State private var showError = false
    @State private var errorMessage = ""

    private var isFormValid: Bool {
        !email.isEmpty &&
        isValidEmail(email) &&
        !username.isEmpty &&
        password.count >= 6 &&
        !licenseNumber.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    VStack(spacing: 16) {
                        Text("Register")
                            .font(.largeTitle.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Group {
                            IconTextField(icon: "envelope", placeholder: "Email", text: $email, isSecure: false)
                            IconTextField(icon: "person", placeholder: "Username", text: $username, isSecure: false)
                            IconTextField(icon: "lock", placeholder: "Password (min. 6 chars)", text: $password, isSecure: true)
                            IconTextField(icon: "doc.text", placeholder: "Licence Number", text: $licenseNumber, isSecure: false)

                            HStack {
                                Image(systemName: "calendar")
                                DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 1)
                        }

                        Button("REGISTER") {
                            guard isFormValid else {
                                errorMessage = validationMessage()
                                showError = true
                                return
                            }

                            let success = userStore.register(
                                email: email,
                                username: username,
                                password: password,
                                licenseNumber: licenseNumber,
                                dob: dateOfBirth
                            )

                            if success {
                                dismiss()
                            } else {
                                errorMessage = "Registration Failed: User with this email or licence number already exists."
                                showError = true
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(12)
                        .disabled(!isFormValid)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .shadow(radius: 5)

                    Spacer()
                }
                .padding()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    private func validationMessage() -> String {
        if email.isEmpty || username.isEmpty || password.isEmpty || licenseNumber.isEmpty {
            return "Please fill in all required fields."
        } else if !isValidEmail(email) {
            return "Please enter a valid email address."
        } else if password.count < 6 {
            return "Password must be at least 6 characters long."
        } else {
            return "Unknown validation error."
        }
    }
}

struct IconTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.primary)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.primary)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.primary)
                    .textInputAutocapitalization(.never)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}
