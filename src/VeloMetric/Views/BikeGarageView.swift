import SwiftUI

struct BikeGarageView: View {
    @StateObject private var viewModel = GarageViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                } else {
                    List(viewModel.bikes) { bike in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(bike.name)
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            Text("\(bike.brand) - \(bike.type.rawValue)")
                                .foregroundColor(.gray)
                            Text("Total Mileage: \(Int(bike.totalMileage)) km")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color.white.opacity(0.05))
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("My Garage")
            .navigationBarTitleDisplayMode(.large)
        }
        .preferredColorScheme(.dark)
    }
}

struct BikeGarageView_Previews: PreviewProvider {
    static var previews: some View {
        BikeGarageView()
    }
}
