import SwiftUI

struct StravaConnectSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: GarageViewModel
    @StateObject private var stravaService = StravaService()
    @State private var syncSuccessMessage: String? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Image(systemName: "figure.outdoor.cycle")
                            .font(.system(size: 54))
                            .foregroundColor(Color(red: 0.98, green: 0.31, blue: 0.08))
                        
                        Text("Strava Integration")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        
                        Text("Automatically sync your rides from Strava to track wear on your bike components without manual entry.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        if stravaService.isConnected {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Connected as \(stravaService.athleteName ?? "Athlete")")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: syncRides) {
                                HStack {
                                    if stravaService.isSyncing {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    } else {
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                        Text("Sync Latest Strava Activities")
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.black)
                                .cornerRadius(16)
                                .bold()
                            }
                            .disabled(stravaService.isSyncing || viewModel.bikes.isEmpty)
                            
                            Button("Disconnect Account") {
                                stravaService.disconnectAccount()
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        } else {
                            Button(action: { stravaService.connectAccount() }) {
                                HStack {
                                    Image(systemName: "link")
                                    Text("Connect with Strava")
                                        .bold()
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.98, green: 0.31, blue: 0.08))
                                .foregroundColor(.white)
                                .cornerRadius(16)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    if let message = syncSuccessMessage {
                        Text(message)
                            .font(.caption.bold())
                            .foregroundColor(.green)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.gray)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func syncRides() {
        guard let firstBike = viewModel.bikes.first else { return }
        stravaService.fetchLatestActivities { rides in
            for var ride in rides {
                ride.bikeId = firstBike.id
                viewModel.logRide(bikeId: ride.bikeId, title: ride.title, distance: ride.distance, date: ride.date)
            }
            syncSuccessMessage = "Successfully imported \(rides.count) rides from Strava!"
        }
    }
}
