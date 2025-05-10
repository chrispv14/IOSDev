import SwiftUI

struct NewBookingView: View {
    let vehicle: Vehicle
    let onConfirm: (Booking) -> Void

    @AppStorage("currentUserEmail") private var currentUserEmail = ""
    @Environment(\.dismiss) private var dismiss

    @State private var pickupDateOnly = Date()
    @State private var pickupTimeSlot = ""
    @State private var returnDateOnly = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
    @State private var returnTimeSlot = ""

    @State private var showConfirmation = false
    @State private var isPickupSelectorPresented = false
    @State private var isReturnSelectorPresented = false

    private var pickupDate: Date {
        combine(date: pickupDateOnly, time: pickupTimeSlot)
    }

    private var returnDate: Date {
        combine(date: returnDateOnly, time: returnTimeSlot)
    }

    private var durationInHoursDecimal: Double {
        let interval = returnDate.timeIntervalSince(pickupDate)
        return max(interval / 3600, 0.5)
    }

    private var estimatedCost: Double {
        durationInHoursDecimal * 10
    }

    private var timeSlots: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var slots: [String] = []
        let base = Calendar.current.startOfDay(for: Date())
        for i in 0..<48 {
            if let time = Calendar.current.date(byAdding: .minute, value: i * 30, to: base) {
                slots.append(formatter.string(from: time))
            }
        }
        return slots
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 10) {
                        Image(vehicle.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 160)
                            .cornerRadius(10)
                            .shadow(radius: 4)

                        Text("\(vehicle.brand) \(vehicle.model)")
                            .font(.title2)
                            .bold()

                        Text("Fuel: \(vehicle.fuelPercentage)%")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    dateTimeButton(title: "Pickup Date & Time", date: pickupDateOnly, time: pickupTimeSlot) {
                        isPickupSelectorPresented = true
                    }

                    dateTimeButton(title: "Return Date & Time", date: returnDateOnly, time: returnTimeSlot) {
                        isReturnSelectorPresented = true
                    }

                    VStack(spacing: 4) {
                        Text("Duration: \(String(format: "%.1f", durationInHoursDecimal)) hour(s)")
                        Text("Estimated Cost: $\(String(format: "%.2f", estimatedCost))")
                            .fontWeight(.medium)
                    }

                    Button {
                        let booking = Booking(
                            userEmail: currentUserEmail,
                            vehicle: vehicle,
                            pickupDate: pickupDate,
                            returnDate: returnDate
                        )
                        onConfirm(booking)
                        showConfirmation = true
                    } label: {
                        Text("Confirm Booking")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .padding(.top)
            }
            .navigationTitle("New Booking")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Booking Confirmed", isPresented: $showConfirmation) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your booking for \(vehicle.brand) is confirmed.")
            }

            .sheet(isPresented: $isPickupSelectorPresented) {
                let now = roundedNowToNextHalfHour()
                let isToday = Calendar.current.isDate(pickupDateOnly, inSameDayAs: now)
                let minMinutes = timeStringToMinutes(formatTime(now))

                let filteredSlots = isToday
                    ? timeSlots.filter { timeStringToMinutes($0) >= minMinutes }
                    : timeSlots

                DateTimePickerSheet(
                    title: "Select Pickup",
                    date: $pickupDateOnly,
                    timeSlot: $pickupTimeSlot,
                    timeSlots: filteredSlots
                )
            }

            .sheet(isPresented: $isReturnSelectorPresented) {
                DateTimePickerSheet(
                    title: "Select Return",
                    date: $returnDateOnly,
                    timeSlot: $returnTimeSlot,
                    timeSlots: getValidReturnSlots()
                )
            }

            .onChange(of: pickupDate) { _ in
                if returnDate <= pickupDate {
                    if let newReturn = Calendar.current.date(byAdding: .minute, value: 30, to: pickupDate) {
                        returnDateOnly = newReturn
                        returnTimeSlot = formatTime(newReturn)
                    }
                }
            }
            .onChange(of: returnDate) { _ in
                if returnDate <= pickupDate {
                    if let newPickup = Calendar.current.date(byAdding: .minute, value: -30, to: returnDate) {
                        pickupDateOnly = newPickup
                        pickupTimeSlot = formatTime(newPickup)
                    }
                }
            }
            .onChange(of: isPickupSelectorPresented) { isPresented in
                if isPresented {
                    let now = roundedNowToNextHalfHour()
                    let isToday = Calendar.current.isDate(pickupDateOnly, inSameDayAs: now)
                    let minMinutes = timeStringToMinutes(formatTime(now))
                    let validSlots = isToday
                        ? timeSlots.filter { timeStringToMinutes($0) >= minMinutes }
                        : timeSlots
                    if !validSlots.contains(pickupTimeSlot), let first = validSlots.first {
                        pickupTimeSlot = first
                    }
                }
            }
            .onChange(of: isReturnSelectorPresented) { isPresented in
                if isPresented {
                    let validSlots = getValidReturnSlots()
                    if !validSlots.contains(returnTimeSlot), let first = validSlots.first {
                        returnTimeSlot = first
                    }
                }
            }
        }
    }

    private func getValidReturnSlots() -> [String] {
        if Calendar.current.isDate(pickupDateOnly, inSameDayAs: returnDateOnly) {
            let pickupMinutes = timeStringToMinutes(pickupTimeSlot)
            return timeSlots.filter { timeStringToMinutes($0) > pickupMinutes }
        } else {
            return timeSlots
        }
    }

    private func dateTimeButton(title: String, date: Date, time: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Button(action: action) {
                HStack {
                    Text("\(formattedDate(date)) at \(time)")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "calendar")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func combine(date: Date, time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let baseDate = Calendar.current.startOfDay(for: date)
        guard let timeDate = formatter.date(from: time) else { return date }
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: timeDate)
        return Calendar.current.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: 0, of: baseDate) ?? date
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private func timeStringToMinutes(_ time: String) -> Int {
        let parts = time.split(separator: ":").compactMap { Int($0) }
        return (parts.first ?? 0) * 60 + (parts.last ?? 0)
    }

    private func roundedNowToNextHalfHour() -> Date {
        let calendar = Calendar.current
        var date = Date()
        let minute = calendar.component(.minute, from: date)
        if minute < 30 {
            date = calendar.date(bySetting: .minute, value: 30, of: date)!
        } else {
            date = calendar.date(byAdding: .hour, value: 1, to: date)!
            date = calendar.date(bySetting: .minute, value: 0, of: date)!
        }
        return calendar.date(bySetting: .second, value: 0, of: date)!
    }
}


