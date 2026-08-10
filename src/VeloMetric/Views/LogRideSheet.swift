import SwiftUI

struct LogRideSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: GarageViewModel
    
    @State private var title: String = ""
    @State private var distanceText: String = ""
    @State private var date: Date = Date()
    @State private var selectedBikeId: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ride Information").foregroundColor(.green)) {
                    TextField("Title (e.g. Sunday Morning Hills)", text: $title)
                    
                    HStack {
                        Text("Distance")
                        Spacer()
                        TextField("0.0", text: $distanceText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("km").foregroundColor(.gray)
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                }
                
                Section(header: Text("Bike Used").foregroundColor(.green)) {
                    Picker("Select Bike", selection: $selectedBikeId) {
                        ForEach(viewModel.bikes) { bike in
                            Text(bike.name).tag(bike.id)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Log Ride")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.gray)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Ride") {
                        saveRide()
                    }
                    .disabled(title.isEmpty || distanceText.isEmpty || selectedBikeId.isEmpty)
                    .foregroundColor(.green)
                    .bold()
                }
            }
            .onAppear {
                if selectedBikeId.isEmpty, let firstBike = viewModel.bikes.first {
                    selectedBikeId = firstBike.id
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func saveRide() {
        let distance = Double(distanceText) ?? 0
        viewModel.logRide(bikeId: selectedBikeId, title: title, distance: distance, date: date)
        presentationMode.wrappedValue.dismiss()
    }
}
