import SwiftUI

struct AddComponentSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: GarageViewModel
    
    let bikeId: String
    
    @State private var name: String = ""
    @State private var type: Component.ComponentType = .chain
    @State private var currentMileageText: String = "0"
    @State private var maxLifespanMileageText: String = "3000"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Component Information").foregroundColor(.green)) {
                    TextField("Name (e.g. Dura-Ace 12v)", text: $name)
                    
                    Picker("Type", selection: $type) {
                        ForEach(Component.ComponentType.allCases, id: \.self) { compType in
                            Text(compType.rawValue).tag(compType)
                        }
                    }
                    .onChange(of: type) { newType in
                        updateDefaultLifespan(for: newType)
                    }
                }
                
                Section(header: Text("Lifespan & Wear").foregroundColor(.green)) {
                    HStack {
                        Text("Current Mileage")
                        Spacer()
                        TextField("0", text: $currentMileageText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("km").foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Max Lifespan")
                        Spacer()
                        TextField("3000", text: $maxLifespanMileageText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("km").foregroundColor(.gray)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Add Component")
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
                        saveComponent()
                    }
                    .disabled(name.isEmpty)
                    .foregroundColor(.green)
                    .bold()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func updateDefaultLifespan(for type: Component.ComponentType) {
        switch type {
        case .chain: maxLifespanMileageText = "3000"
        case .cassette: maxLifespanMileageText = "12000"
        case .frontTire, .rearTire: maxLifespanMileageText = "4500"
        case .brakePads: maxLifespanMileageText = "5000"
        case .bottomBracket: maxLifespanMileageText = "15000"
        }
    }
    
    private func saveComponent() {
        let current = Double(currentMileageText) ?? 0
        let maxLife = Double(maxLifespanMileageText) ?? 3000
        viewModel.addComponent(bikeId: bikeId, name: name, type: type, currentMileage: current, maxLifespanMileage: maxLife)
        presentationMode.wrappedValue.dismiss()
    }
}
