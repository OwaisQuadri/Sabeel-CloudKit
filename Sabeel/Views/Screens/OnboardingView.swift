//
//  OnboardingView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isShowingOnboarding: Bool
    
    var body: some View {
        VStack{
            XButton {
                isShowingOnboarding = false
            }
            ScrollView {
                Spacer()
                Group {
                    Logo()
                        .scaledToFit()
                        .frame(width: .relativeToScreen(.width), height: .relativeToScreen(.height, ratio: 0.3))
                }.padding(.bottom)
                Group  {
                    Text("Overview").masjidTitle()
                    OnboardingNewsView(image: Image(systemName: "location.viewfinder"), headlineText: "Find Masjids in your Area", bodyText: "Get notified when to leave your house to make it in time for the next prayer!" )
                    OnboardingNewsView(image: Image(systemName: "square.and.arrow.down.on.square"), headlineText: "Get the latest updates", bodyText: "Anyone can submit a request to keep the prayer times up to date!" )
                    OnboardingNewsView(image: Image(systemName: "person.3.fill"), headlineText: "No Muslim left behind", bodyText: "Connect with your communities and motivate each other to come to the masjid." )
                    Text("What's New in v1.0.0 ?").masjidTitle()
                    OnboardingNewsView(image: Image(systemName: "bell.and.waves.left.and.right"), headlineText: "Notifications", bodyText: "Recieve notifications for ideal departure times. configured in Profile > Notification Settings" )
                    OnboardingNewsView(image: Image(systemName: "doc.richtext.ar"), headlineText: "Masjid Details", bodyText: "View any masjid's prayer times for today, as well as call, email, or visit their website." )
                    OnboardingNewsView(image: Image(systemName: "arrow.triangle.2.circlepath.doc.on.clipboard"), headlineText: "Masjid Change Request", bodyText: "Submit a change request that will be reviewed by the community." )
                }
                .foregroundColor(.brandSecondary)
                Spacer()
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isShowingOnboarding: .constant(true))
    }
}

struct OnboardingNewsView: View {
    var image       : Image?
    var headlineText: String?
    var bodyText    : String?
    
    var body: some View {
        HStack(spacing: 10) {
            Spacer()
            image?
                .resizable()
                .scaledToFit()
                .frame(width: .relativeToScreen(.height, ratio: 0.08) ,height: .relativeToScreen(.height, ratio: 0.08))
            VStack(alignment: .leading){
                Spacer()
                HStack {
                    Text(headlineText ?? "")
                        .font(.title3)
                        .foregroundColor(.brandPrimary)
                        .lineLimit(1)
                    Spacer()
                }
                Text(bodyText ?? "")
                    .font(.callout)
                    .lineLimit(3)
                Spacer()
            }
            Spacer()
        }
        .frame(width: .relativeToScreen(.width,ratio: 0.8), height: .relativeToScreen(.height, ratio: 0.12))
    }
}

struct XButton: View {
    var action: () -> Void
    var body: some View {
        HStack {
            Spacer()
            Button {
                action()
            } label: {
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .frame(width: .relativeToScreen(.width, ratio: 0.05),height: .relativeToScreen(.width, ratio: 0.05))
                    .tint(.brandSecondary)
            }
            .padding()
        }
    }
}
