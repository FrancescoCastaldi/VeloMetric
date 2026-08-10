import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: GarageViewModel
    @State private var showingAddComponentSheet = false
    @State private var selectedBikeId: String? = nil
    
    var activeBike: Bike? {
        if let selectedId = selectedBikeId, let bike = viewModel.bikes.first(where: { $0.id == selectedId }) {
            return bike
        }
        return viewModel.bikes.first
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if viewModel.isLoading {
                    ProgressView("Loading Telemetry...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .foregroundColor(.green)
                } else if viewModel.bikes.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "gauge.with.dots.needle.0percent")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("No telemetry data yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Add a bike in your Garage to start tracking component wear.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Bike Selector Menu if multiple bikes
                            if let bike = activeBike {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(bike.name)
                                            .font(.system(size: 28, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                        Text("\(bike.brand) • \(Int(bike.totalMileage)) km")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    
                                    if viewModel.bikes.count > 1 {
                                        Menu {
                                            ForEach(viewModel.bikes) { b in
                                                Button(b.name) {
                                                    selectedBikeId = b.id
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "chevron.down.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                let components = viewModel.components(for: bike)
                                
                                if components.isEmpty {
                                    VStack(spacing: 12) {
                                        Text("No components attached to this bike")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Button(action: { showingAddComponentSheet = true }) {
                                            Label("Add Component", systemImage: "plus")
                                                .font(.caption.bold())
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(Color.green.opacity(0.2))
                                                .foregroundColor(.green)
                                                .cornerRadius(16)
                                        }
                                    }
                                    .padding(.top, 40)
                                } else {
                                    ForEach(components) { component in
                                        ComponentCard(component: component) {
                                            viewModel.deleteComponent(component)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("VeloMetric")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if activeBike != nil {
                        Button(action: { showingAddComponentSheet = true }) {
                            Image(systemName: "plus")
                                .foregroundColor(.green)
                                .font(.title3.bold())
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddComponentSheet) {
                if let bike = activeBike {
                    AddComponentSheet(bikeId: bike.id)
                        .environmentObject(viewModel)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ComponentCard: View {
    let component: Component
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: CGFloat(component.wearPercentage))
                    .stroke(
                        component.needsReplacement ? Color.red : Color.green,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(component.wearPercentage * 100))%")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(component.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(component.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("\(Int(component.currentMileage)) / \(Int(component.maxLifespanMileage)) km")
                    .font(.caption)
                    .foregroundColor(component.needsReplacement ? .red : .green)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal)
        .contextMenu {
            Button(role: .destructive, action: onDelete) {
                Label("Delete Component", systemImage: "trash")
            }
        }
    }
}
