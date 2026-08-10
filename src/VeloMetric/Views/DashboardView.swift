import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = GarageViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dark mode premium background
                Color.black.edgesIgnoringSafeArea(.all)
                
                if viewModel.isLoading {
                    ProgressView("Loading Garage...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .foregroundColor(.green)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            if let firstBike = viewModel.bikes.first {
                                Text(firstBike.name)
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                
                                let components = viewModel.components(for: firstBike)
                                
                                ForEach(components) { component in
                                    ComponentCard(component: component)
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
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ComponentCard: View {
    let component: Component
    
    var body: some View {
        HStack(spacing: 16) {
            // Circular Progress Ring
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: component.wearPercentage)
                    .stroke(
                        component.needsReplacement ? Color.red : Color.green,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    // .animation(.easeInOut(duration: 1.0), value: component.wearPercentage)
                
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
        // Glassmorphism effect
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
