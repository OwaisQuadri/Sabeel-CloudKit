//
//  OnboardingView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack{
            BrandLargeBanner()
                .scaledToFit()
                .frame(width: .relativeToScreen(.width))
                .foregroundColor(.brandPrimary)
                .bold()
            VStack {
                HStack {
                    Image(systemName: "location.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .relativeToScreen(.width, ratio: 0.15))
                    VStack{
                        Text("Some Headline")
                            .fontWeight(.regular)
                            .masjidTitle()
                        Text("Fill this up to two lines of text. Fill this up to two lines of text")
                            .lineLimit(2)
                            .font(.callout)
                    }
                    .frame(width: .relativeToScreen(.width,ratio: 0.5))
                    .padding()
                }
                HStack {
                    Image(systemName: "location.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .relativeToScreen(.width, ratio: 0.15))
                    VStack{
                        Text("Some Headline")
                            .fontWeight(.regular)
                            .masjidTitle()
                        Text("Fill this up to two lines of text. Fill this up to two lines of text")
                            .lineLimit(2)
                            .font(.callout)
                    }
                    .frame(width: .relativeToScreen(.width,ratio: 0.5))
                    .padding()
                }
                HStack {
                    Image(systemName: "location.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .relativeToScreen(.width, ratio: 0.15))
                    VStack{
                        Text("Some Headline")
                            .fontWeight(.regular)
                            .masjidTitle()
                        Text("Fill this up to two lines of text. Fill this up to two lines of text")
                            .lineLimit(2)
                            .font(.callout)
                    }
                    .frame(width: .relativeToScreen(.width,ratio: 0.5))
                    .padding()
                }
            }
            .foregroundColor(.brandSecondary)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
