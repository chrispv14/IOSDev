//
//  ContentView.swift
//  IOSDev
//
//  Created by Chris Patrik Balquiedra Veneracion on 2/5/2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        TabView {
            MyBookingsView()
                .tabItem {
                    Label("My Bookings", systemImage: "calendar")
                }
            
            CarsNearMeView()
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

struct MyBookingsView: View {
    var body: some View {
        NavigationView {
            Text("Your future bookings will appear here")
                .navigationTitle(Text("My Car Bookings"))
        }
    }
}

struct CarsNearMeView: View {
    @State private var camPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -33.88357, longitude: 151.20060),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
    )
    
    var body: some View {
        NavigationView {
            Map(position: $camPosition) {
                UserAnnotation()
                Marker("Red Car", coordinate: CLLocationCoordinate2D(latitude: -33.88334, longitude: 151.19954))
            }
        }
    }
}

struct SettingsView: View {
    @AppStorage("username") private var username = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Settings")) {
                    TextField("Username", text: $username)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
}
