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
            ScrollView{
                Spacer()
                Group {
                    BrandLargeBanner()
                        .scaledToFit()
                        .frame(width: .relativeToScreen(.width))
                        .foregroundColor(.brandPrimary)// remove when you get an image
                        .bold()// remove when you get an image
                        .frame(height: .relativeToScreen(.height, ratio: 0.2))
                        .background(Color.brandSecondary) // remove when you get an image
                }.padding(.bottom)
                Group  {
                    Text("Overview").masjidTitle()
                    OnboardingNewsView(image: Image(systemName: "location.viewfinder"), headlineText: "test", bodyText: "other" )
                    OnboardingNewsView(image: Image(systemName: "location.viewfinder"), headlineText: "test", bodyText: "other" )
                    OnboardingNewsView(image: Image(systemName: "location.viewfinder"), headlineText: "test", bodyText: "other" )
                    Text("What's New?").masjidTitle()
                    OnboardingNewsView(image: Image(systemName: "location.viewfinder"), headlineText: "test", bodyText: "other" )
                    OnboardingNewsView(image: Image(systemName: "location.viewfinder"), headlineText: "test", bodyText: "other" )
                    OnboardingNewsView(image: Image(systemName: "location.viewfinder"), headlineText: "test", bodyText: "other" )
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
            image?
                .resizable()
                .scaledToFit()
                .frame(height: .relativeToScreen(.height, ratio: 0.08))
            VStack(alignment: .leading){
                Spacer()
                HStack {
                    Text(headlineText ?? "")
                        .font(.title)
                        .foregroundColor(.brandPrimary)
                        .lineLimit(1)
                Spacer()
                }
                Text(bodyText ?? "")
                    .font(.callout)
                    .lineLimit(2)
                Spacer()
            }
            .frame(width: .relativeToScreen(.width,ratio: 0.5), height: .relativeToScreen(.height, ratio: 0.098))
            .padding()
        }
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
