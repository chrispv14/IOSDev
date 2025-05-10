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

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    VStack(spacing: 16) {
                        Text("Register")
                            .font(.largeTitle.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Group {
                            IconTextField(icon: "envelope", placeholder: "Email", text: $email, isSecure: false)
                            IconTextField(icon: "person", placeholder: "Username", text: $username, isSecure: false)
                            IconTextField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                            IconTextField(icon: "doc.text", placeholder: "Licence Number", text: $licenseNumber, isSecure: false)
                            
                            HStack {
                                Image(systemName: "calendar")
                                DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                        }

                        Button("REGISTER") {
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
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding()
                    .background(Color.white)
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
}
struct IconTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}
