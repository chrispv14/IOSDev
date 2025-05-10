import SwiftUI

struct AuthModalView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("currentUserEmail") private var currentUserEmail = ""
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var showError = false

    @ObservedObject var userStore = UserStore()
    let onLoginSuccess: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    // Login Card
                    VStack(spacing: 20) {
                        Text("Login")
                            .font(.largeTitle.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Image(systemName: "envelope")
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 1)

                        HStack {
                            Image(systemName: "lock")
                            SecureField("Password", text: $password)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 1)

                        Button(action: {
                            if userStore.login(email: email, password: password) {
                                isLoggedIn = true
                                currentUserEmail = email
                                onLoginSuccess()
                                dismiss()
                            } else {
                                showError = true
                            }
                        }) {
                            Text("LOGIN")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .shadow(radius: 5)

                    Spacer()

                    VStack(spacing: 6) {
                        Text("Not yet registered?")
                            .foregroundColor(.secondary)
                            .font(.subheadline)

                        Button("Sign Up Now") {
                            showRegister = true
                        }
                        .font(.headline)
                    }
                    .padding(.bottom, 30)
                }
                .padding()
            }
            .sheet(isPresented: $showRegister) {
                RegisterView(userStore: userStore)
            }
            .alert("Invalid email or password", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}
