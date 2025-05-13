//
//  DateTimePickerSheet.swift
//  IOSDev
//
//  Created by Chris Patrik Balquiedra Veneracion on 11/5/2025.
//
import SwiftUI

struct DateTimePickerSheet: View {
    let title: String
    @Binding var date: Date
    @Binding var timeSlot: String
    let timeSlots: [String]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(title, selection: $date, in: Date()..., displayedComponents: [.date])

                    .datePickerStyle(.graphical)
                    .padding()

                Picker("Time", selection: $timeSlot) {
                    ForEach(timeSlots, id: \.self) {
                        Text($0).tag($0)
                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
