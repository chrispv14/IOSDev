import SwiftUI

struct ContentView: View {
    @StateObject private var bookingStore = BookingStore()

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
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    ContentView()
}
