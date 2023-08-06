//
//  SMapView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI
import MapKit
struct PrayerTimes {
    var fajr: String = "5:30 pm"
    var dhuhr: String = "5:30 pm"
    var asr: String = "5:30 pm"
    var maghrib: String = "5:30 pm"
    var isha: String = "5:30 pm"
    var juma: [String] = ["5:30 pm", "5:30 pm", "5:30 pm", "5:30 pm", "5:30 pm"]
}
struct Masjid {
    var name: String = "Oshawa Masjid"
    var email: String?
    var address: String = "1234 Address Dr, Oshawa, ON, Canada, A1A 1A1"
    var phoneNumber : String? = "2899438996"
    var website : String? = "www.google.com"
    var prayerTimes: PrayerTimes = PrayerTimes()
    var changeRequest: MasjidChangeRequest?
}
struct MasjidChangeRequest {
    var name: String = "Oshawa Masjid"
    var email: String?
    var address: String = "1234 Address Dr, Oshawa, ON, Canada, A1A 1A1"
    var phoneNumber : String? = "2899438996"
    var website : String? = "www.google.com"
    var prayerTimes: PrayerTimes = PrayerTimes()
    var yesVotes: Int
    var noVotes: Int
    var votesToPass: Int
}

struct SMapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.8924901, longitude: -78.8649466), span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)) // TODO: Ideally we want the users location
    @State private var selectedMasjid: Masjid?
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $region)
                .ignoresSafeArea(edges: .top)
            VStack {
                // TODO: add logo .resizable.scaledtofit.frame with height 20% of screen
                Text("Sabeel - سبيل")
                    .font(.largeTitle)
                    .padding()
                    .shadow(color: .brandPrimary, radius: 5)
                Button ("Open Masjid") {
                    self.selectedMasjid = Masjid()
                }
                .buttonStyle(.bordered)

                Spacer()
                
                if $selectedMasjid.wrappedValue != nil {
                    // But it will not show unless this variable is true
                    MasjidDetail(selectedMasjid: $selectedMasjid)
                }
            }
        }
    }
}

struct SMapView_Previews: PreviewProvider {
    static var previews: some View {
        SMapView()
    }
}
