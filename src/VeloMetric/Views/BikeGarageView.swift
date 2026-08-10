import SwiftUI

struct BikeGarageView: View {
    @EnvironmentObject var viewModel: GarageViewModel
    @State private var showingAddBikeSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                } else if viewModel.bikes.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bicycle")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("No bikes in your garage yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Button(action: { showingAddBikeSheet = true }) {
                            Label("Add Your First Bike", systemImage: "plus")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.black)
                                .cornerRadius(24)
                                .bold()
                        }
                    }
                } else {
                    List {
                        ForEach(viewModel.bikes) { bike in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(bike.name)
                                        .font(.title3.bold())
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text(bike.type.rawValue)
                                        .font(.caption.bold())
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.green.opacity(0.2))
                                        .foregroundColor(.green)
                                        .cornerRadius(8)
                                }
                                Text(bike.brand)
                                    .foregroundColor(.gray)
                                Text("Total Mileage: \(Int(bike.totalMileage)) km")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            .padding(.vertical, 8)
                            .listRowBackground(Color.white.opacity(0.05))
                        }
                        .onDelete(perform: viewModel.deleteBike)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("My Garage")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 4) {
                        Image(systemName: viewModel.isSyncedWithCloud ? "cloud.fill" : "cloud.slash")
                            .foregroundColor(viewModel.isSyncedWithCloud ? .green : .gray)
                        Text(viewModel.isSyncedWithCloud ? "Synced" : "Local")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddBikeSheet = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.green)
                            .font(.title3.bold())
                    }
                }
            }
            .sheet(isPresented: $showingAddBikeSheet) {
                AddBikeSheet()
                    .environmentObject(viewModel)
            }
        }
        .preferredColorScheme(.dark)
    }
}
