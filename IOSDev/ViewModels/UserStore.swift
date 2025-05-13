//
//  UserStore.swift
//  IOSDev
//
//  Created by Chris Patrik Balquiedra Veneracion on 10/5/2025.
//


import Foundation

class UserStore: ObservableObject {
    @Published var users: [User] = []
    
    private let fileName = "users.json"

    init() {
        loadUsers()
    }

    private func getFileURL() -> URL {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return url.appendingPathComponent(fileName)
    }

    func loadUsers() {
        let url = getFileURL()
        guard FileManager.default.fileExists(atPath: url.path) else {
            users = []
            return
        }

        do {
            let data = try Data(contentsOf: url)
            users = try JSONDecoder().decode([User].self, from: data)
        } catch {
            print("Failed to load users: \(error)")
        }
    }

    func saveUsers() {
        let url = getFileURL()
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: url)
        } catch {
            print("Failed to save users: \(error)")
        }
    }

    func register(email: String, username: String, password: String, licenseNumber: String, dob: Date) -> Bool {
        let duplicateUser = users.contains {
            $0.email.lowercased() == email.lowercased() ||
            $0.licenseNumber == licenseNumber
        }

        if duplicateUser {
            return false
        }

        let newUser = User(
            email: email,
            username: username,
            password: password,
            licenseNumber: licenseNumber,
            dateOfBirth: dob
        )

        users.append(newUser)
        saveUsers()
        return true
    }



    func login(email: String, password: String) -> Bool {
        return users.contains(where: { $0.email == email && $0.password == password })
    }
    func deleteUser(email: String) {
        users.removeAll { $0.email == email }
        saveUsers()
    }

}
