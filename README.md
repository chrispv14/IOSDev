# 📱 IOSDev – Group Project App

## 🎯 Overview
This iOS application was developed as part of our university group project for the subject **42889 / 41889 – Application Development** at UTS. The goal was to design and implement a functional app that solves a real-world problem using the **Product Design Cycle**, with iterative prototyping, development, and testing.

The concept is a **student-friendly vehicles rental app**, allowing users to easily find and book nearby vehicles with a clean, intuitive UI and efficient time-slot management. All data is stored locally using `UserDefaults` and `.json` files.

## 👥 Team
This project was completed by a group of 3 students under the **Faculty of Engineering and IT, School of Computer Science**.

## 🛠 Features
- Built entirely in **Swift** using **Xcode** and **SwiftUI**.
- **User registration and login** system with duplicate email/license prevention.
    - Required fields including date of birth and license number.
    - Email format validation and minimum password length enforcement.
    - Prevention of duplicate email or license number.
- **Booking system with 30-minute time slots**, including price calculation.
- **Per-user bookings** stored locally in `.json` files.
- Interactive **Map view** for finding nearby cars.
- **Image-based listings** for better UX and recognizability.
- **Authentication gating** (e.g., bookings only when logged in).
- Modern UI with segmented views, forms, modals, and error handling.
- Optimized for both code readability and user experience.

## 📂 Project Structure

```text
IOSDev/
├── Assets.xcassets/            
├── Models/                      # Data models (Booking, Vehicle, User)
│   ├── Booking.swift
│   ├── Vehicle.swift
│   └── User.swift
├── ViewModels/                  # Observable stores for bookings and users
│   ├── BookingStore.swift
│   └── UserStore.swift
├── Views/                       # All SwiftUI view files
│   ├── AuthModalView.swift
│   ├── CarsNearMeView.swift
│   ├── ContentView.swift
│   ├── DateTimePickerSheet.swift
│   ├── MapView.swift
│   ├── MyBookingsView.swift
│   ├── NewBookingView.swift
│   ├── RegisterView.swift
│   ├── SettingsView.swift
│   └── VehicleListView.swift
├── IOSDevApp/
├── IOSDevTests/
├── IOSDevUITests/
└── README.md                  


```
## 🔁 Development Process
This app was developed following an Agile & iterative workflow:
1. **Planning & Ideation**
2. **Wireframing and Task Allocation**
3. **Implementation with Incremental Testing**
4. **User Feedback and Iteration**
5. **Final Polish & Submission**

## 📦 Data Handling
- Users and bookings are persisted using `Codable` and saved as local `.json` files in the app's document directory.
- AppStorage tracks login session data (e.g., isLoggedIn, currentUserEmail).
- Only logged-in users can book, view settings, or access booking history.

## 🧪 Final Submission
The project will be presented in Week 12 during the lab session. A ZIP of the final project folder and this GitHub link are both included in the submission to Canvas.

## 🔗 GitHub Repository
This is the official GitHub repository for our final submission:  
➡️ [https://github.com/chrispv14/IOSDev](https://github.com/chrispv14/IOSDev)
