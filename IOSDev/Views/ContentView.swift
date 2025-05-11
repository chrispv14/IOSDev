import SwiftUI

struct ContentView: View {
    @StateObject private var bookingStore = BookingStore()
    @StateObject private var userStore = UserStore()
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        TabView {
            MyBookingsView()
                .environmentObject(bookingStore)
                .tabItem {
                    Label("My Bookings", systemImage: "calendar")
                }

            CarsNearMeView()
                .environmentObject(bookingStore)
                .tabItem {
                    Label("Cars Near Me", systemImage: "car.fill")
                }

            SettingsView()
                .environmentObject(userStore)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)

    }
}

#Preview {
    ContentView()
}
