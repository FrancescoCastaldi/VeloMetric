import SwiftUI

struct AddBikeSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: GarageViewModel
    
    @State private var name: String = ""
    @State private var brand: String = ""
    @State private var type: Bike.BikeType = .road
    @State private var totalMileageText: String = "0"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bike Details").foregroundColor(.green)) {
                    TextField("Name (e.g. Madone SLR 9)", text: $name)
                    TextField("Brand (e.g. Trek, Specialized)", text: $brand)
                    
                    Picker("Type", selection: $type) {
                        ForEach(Bike.BikeType.allCases, id: \.self) { bikeType in
                            Text(bikeType.rawValue).tag(bikeType)
                        }
                    }
                }
                
                Section(header: Text("Initial Odometer").foregroundColor(.green)) {
                    HStack {
                        TextField("Mileage", text: $totalMileageText)
                            .keyboardType(.decimalPad)
                        Text("km")
                            .foregroundColor(.gray)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Add New Bike")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.gray)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveBike()
                    }
                    .disabled(name.isEmpty || brand.isEmpty)
                    .foregroundColor(.green)
                    .bold()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func saveBike() {
        let mileage = Double(totalMileageText) ?? 0
        viewModel.addBike(name: name, brand: brand, type: type, totalMileage: mileage)
        presentationMode.wrappedValue.dismiss()
    }
}
