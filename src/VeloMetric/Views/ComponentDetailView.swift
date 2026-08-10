import SwiftUI

struct ComponentDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: GarageViewModel
    
    let component: Component
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Large Wear Gauge
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 16)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(component.wearPercentage))
                                .stroke(
                                    component.needsReplacement ? Color.red : Color.green,
                                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                            
                            VStack(spacing: 4) {
                                Text("\(Int(component.wearPercentage * 100))%")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Text(component.needsReplacement ? "REPLACE SOON" : "HEALTHY")
                                    .font(.caption.bold())
                                    .foregroundColor(component.needsReplacement ? .red : .green)
                            }
                        }
                        .frame(width: 180, height: 180)
                        .padding(.top, 20)
                        
                        // Component Info Card
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(component.name)
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                Spacer()
                                Text(component.type.rawValue)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.2))
                                    .foregroundColor(.green)
                                    .cornerRadius(8)
                            }
                            
                            Divider().background(Color.white.opacity(0.1))
                            
                            HStack {
                                Text("Current Distance")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(Int(component.currentMileage)) km")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Text("Estimated Lifespan")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(Int(component.maxLifespanMileage)) km")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Text("Installed On")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(component.dateInstalled, style: .date)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        
                        // Service Button
                        Button(action: { showingResetAlert = true }) {
                            HStack {
                                Image(systemName: "wrench.and.screwdriver.fill")
                                Text("Mark as Replaced / Serviced")
                                    .bold()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(16)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Component Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.gray)
                }
            }
            .alert(isPresented: $showingResetAlert) {
                Alert(
                    title: Text("Reset Component Wear?"),
                    message: Text("This will reset the current mileage for '\(component.name)' to 0 km and update the installation date to today."),
                    primaryButton: .destructive(Text("Reset Mileage")) {
                        viewModel.replaceComponent(component)
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .preferredColorScheme(.dark)
    }
}
