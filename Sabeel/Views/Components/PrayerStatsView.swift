//
//  PrayerStatsView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-08.
//

import SwiftUI

struct PrayerStatsView: View {
    @State var prayerStats: PrayerStats?
    @State private var hideStats = true
    var body: some View {
        VStack (alignment: .leading){
            // prayer stats
            PrayerStatsHeaderView(hideStats: $hideStats)
            if let prayerStats {
                if !hideStats {
                    ZStack{
                        SecondaryBackgroundView()
                        ProgressView(value: prayerStats.fajrAttended, total: prayerStats.fajrAttended + prayerStats.fajrMissed) {
                            HStack {
                                Text("Fajr")
                                Spacer ()
                                Text("\(Int(prayerStats.fajrAttended)) / \(Int(prayerStats.fajrAttended + prayerStats.fajrMissed))")
                            }
                            .padding()
                        }
                        .padding()
                    }
                    ZStack{
                        SecondaryBackgroundView()
                        ProgressView(value: prayerStats.dhuhrAttended, total: prayerStats.dhuhrAttended + prayerStats.dhuhrMissed) {
                            HStack {
                                Text("Dhuhr")
                                Spacer ()
                                Text("\(Int(prayerStats.dhuhrAttended)) / \(Int(prayerStats.dhuhrAttended + prayerStats.dhuhrMissed))")
                            }
                            .padding()
                        }
                        .padding()
                    }
                    ZStack{
                        SecondaryBackgroundView()
                        ProgressView(value: prayerStats.asrAttended, total: prayerStats.asrAttended + prayerStats.asrMissed) {
                            HStack {
                                Text("Asr")
                                Spacer ()
                                Text("\(Int(prayerStats.asrAttended)) / \(Int(prayerStats.asrAttended + prayerStats.asrMissed))")
                            }
                            .padding()
                        }
                        .padding()
                    }
                    ZStack{
                        SecondaryBackgroundView()
                        ProgressView(value: prayerStats.maghribAttended, total: prayerStats.maghribAttended + prayerStats.maghribMissed) {
                            HStack {
                                Text("Maghrib")
                                Spacer ()
                                Text("\(Int(prayerStats.maghribAttended)) / \(Int(prayerStats.maghribAttended + prayerStats.maghribMissed))")
                            }
                            .padding()
                        }
                        .padding()
                    }
                    ZStack{
                        SecondaryBackgroundView()
                        ProgressView(value: prayerStats.ishaAttended, total: prayerStats.ishaAttended + prayerStats.ishaMissed) {
                            HStack {
                                Text("Isha")
                                Spacer ()
                                Text("\(Int(prayerStats.ishaAttended)) / \(Int(prayerStats.ishaAttended + prayerStats.ishaMissed))")
                            }
                            .padding()
                        }
                        .padding()
                    }
                }
            }
        }
        .tint(.brandPrimary)
        .onAppear {
            
        }
    }
}

struct PrayerStatsHeaderView: View {
    @Binding var hideStats: Bool
    
    var body: some View {
        HStack{
            Text("Prayer Stats")
                .bold()
            Spacer()
            Button {
                hideStats.toggle()
            } label: {
                Text(hideStats ? "SHOW" : "HIDE")
                    .font(.callout)
            }
            .foregroundColor(.brandSecondary)
        }
    }
}

struct PrayerStatsView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PrayerStatsView(prayerStats: PrayerStats(record: MockData.prayerStats))
        }
    }
}
