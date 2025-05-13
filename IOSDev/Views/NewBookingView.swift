import SwiftUI

struct NewBookingView: View {
    let vehicle: Vehicle
    let onConfirm: (Booking) -> Void

    @AppStorage("currentUserEmail") private var currentUserEmail = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var bookingStore: BookingStore

    @State private var pickupDateOnly = Date()
    @State private var pickupTimeSlot = ""
    @State private var returnDateOnly = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
    @State private var returnTimeSlot = ""

    @State private var bookingConflict = false
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

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    vehicleCard

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
                        if bookingStore.isVehicleAvailable(vehicle, from: pickupDate, to: returnDate) {
                            let booking = Booking(
                                userEmail: currentUserEmail,
                                vehicle: vehicle,
                                pickupDate: pickupDate,
                                returnDate: returnDate
                            )
                            onConfirm(booking)
                            showConfirmation = true
                        } else {
                            bookingConflict = true
                        }
                    } label: {
                        Text("Confirm Booking")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background((pickupTimeSlot.isEmpty || returnTimeSlot.isEmpty) ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(pickupTimeSlot.isEmpty || returnTimeSlot.isEmpty)
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

            .alert("Booking Conflict", isPresented: $bookingConflict) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("This vehicle is already booked for the selected time range.")
            }

            .sheet(isPresented: $isPickupSelectorPresented) {
                let filteredSlots = generateTimeSlots(for: pickupDateOnly)

                DateTimePickerSheet(
                    title: "Select Pickup",
                    date: $pickupDateOnly,
                    timeSlot: $pickupTimeSlot,
                    timeSlots: filteredSlots
                )
                .onAppear {
                    if pickupTimeSlot.isEmpty {
                        pickupTimeSlot = filteredSlots.first ?? ""
                    }
                }
            }

            .sheet(isPresented: $isReturnSelectorPresented) {
                let filteredReturnSlots = getValidReturnSlots()

                DateTimePickerSheet(
                    title: "Select Return",
                    date: $returnDateOnly,
                    timeSlot: $returnTimeSlot,
                    timeSlots: filteredReturnSlots
                )
                .onAppear {
                    if returnTimeSlot.isEmpty {
                        returnTimeSlot = filteredReturnSlots.first ?? ""
                    }
                }
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

    // MARK: - Helpers

    private var vehicleCard: some View {
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
    }

    private func getValidReturnSlots() -> [String] {
        let pickupDateStr = formattedDate(pickupDateOnly)
        let returnDateStr = formattedDate(returnDateOnly)
        let pickupMinutes = timeStringToMinutes(pickupTimeSlot)

        let baseSlots = generateTimeSlots(for: returnDateOnly)

        if pickupDateStr == returnDateStr {
            return baseSlots.filter { timeStringToMinutes($0) > pickupMinutes }
        } else {
            return baseSlots
        }
    }

    private func generateTimeSlots(for date: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let calendar = Calendar.current
        let isToday = calendar.isDateInToday(date)
        let now = Date()
        let startTime: Date = isToday ? roundedNowToNextHalfHour() : calendar.startOfDay(for: date)
        
        var slots: [String] = []
        for i in 0..<48 {
            guard let slot = calendar.date(byAdding: .minute, value: i * 30, to: startTime),
                  calendar.isDate(slot, inSameDayAs: date)
            else { continue }
            
            // Check availability
            let endSlot = calendar.date(byAdding: .minute, value: 30, to: slot)!
            if bookingStore.isVehicleAvailable(vehicle, from: slot, to: endSlot) {
                let rounded = roundDateToHalfHour(slot)
                slots.append(formatter.string(from: rounded))
            }
        }

        return Array(Set(slots)).sorted()
    }

    private func roundDateToHalfHour(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

        let roundedMinute = minute < 15 ? 0 : (minute < 45 ? 30 : 0)
        let roundedHour = (minute >= 45) ? (hour + 1) : hour

        return calendar.date(bySettingHour: roundedHour, minute: roundedMinute, second: 0, of: date)!
    }


    private func dateTimeButton(title: String, date: Date, time: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Button(action: action) {
                HStack {
                    Text("\(formattedDate(date)) at \(time.isEmpty ? "..." : time)")
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
        let now = Date()
        let minute = calendar.component(.minute, from: now)
        let nextHalfHour = minute < 30 ? 30 : 60
        let addMinutes = nextHalfHour - minute
        return calendar.date(byAdding: .minute, value: addMinutes, to: calendar.date(bySetting: .second, value: 0, of: now)!)!
    }
}
