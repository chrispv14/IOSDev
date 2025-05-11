import SwiftUI

struct VehicleListView: View {
    let vehicles: [Vehicle]
    let isLoggedIn: Bool
    let bookingStore: BookingStore
    @Binding var selectedVehicle: Vehicle?
    @Binding var showLoginPrompt: Bool

    var body: some View {
        List(vehicles, id: \.id) { vehicle in
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(vehicle.brand) \(vehicle.model)")
                            .font(.headline)
                        Text("Fuel: \(vehicle.fuelPercentage)%")
                            .font(.subheadline)
                    }

                    Spacer()

                    Button("Book") {
                        if isLoggedIn {
                            selectedVehicle = vehicle
                        } else {
                            showLoginPrompt = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 6) {
                        ForEach(generateNext48HSlots(), id: \.self) { slotTime in
                            let endSlot = Calendar.current.date(byAdding: .minute, value: 30, to: slotTime)!
                            let available = bookingStore.isVehicleAvailable(vehicle, from: slotTime, to: endSlot)

                            Text(formatSlot(slotTime))
                                .padding(8)
                                .background(available ? Color.green.opacity(0.6) : Color.red.opacity(0.6))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.vertical, 6)
        }
    }

    private func generateNext48HSlots() -> [Date] {
        var slots: [Date] = []
        let calendar = Calendar.current

        let now = Date()
        let components = calendar.dateComponents([.hour, .minute], from: now)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

        // Round up to next half-hour block
        let roundedMinute = minute < 30 ? 30 : 0
        let roundedHour = minute < 30 ? hour : hour + 1

        var current = calendar.date(bySettingHour: roundedHour, minute: roundedMinute, second: 0, of: now)!

        for _ in 0..<96 {
            slots.append(current)
            current = calendar.date(byAdding: .minute, value: 30, to: current)!
        }

        return slots
    }

    private func roundedNowToNextHalfHour() -> Date {
        let calendar = Calendar.current
        let now = Date()
        let minute = calendar.component(.minute, from: now)
        let nextHalf = minute < 30 ? 30 : 60
        let offset = nextHalf - minute
        return calendar.date(byAdding: .minute, value: offset, to: calendar.date(bySetting: .second, value: 0, of: now)!)!
    }

    private func formatSlot(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E HH:mm"
        return formatter.string(from: date)
    }
}
