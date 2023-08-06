//
//  MasjidChangeRequestView.swift
//  Sabeel
//
//  Created by Owais on 2023-08-06.
//

import SwiftUI

struct MasjidChangeRequestView: View {
    @Binding var isShowingThisView: Bool
    @Binding var selectedMasjid: Masjid?
    
    // Values to create request
    @State var name: String = ""
    
    
    func dismiss() {
        withAnimation(.easeInOut) {
            isShowingThisView = false
        }
    }
    
    var body: some View {
            VStack(alignment: .center) {
                HStack (alignment: .center ) {
                    if $selectedMasjid.wrappedValue?.changeRequest != nil {
                        VStack {
                            Text(selectedMasjid?.name ?? "Unknown")
                                .font(.title)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.brandPrimary)
                            Text(selectedMasjid?.address ?? "Unknown")
                                .font(.caption)
                                .foregroundColor(.brandSecondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    } else {
                        TextField("Institution Name", text: $name)
                    }
                    Button(action: {
                        withAnimation (.easeInOut) {
                            self.isShowingThisView = false
                        }
                    }) {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.brandSecondary)
                    }
                    .padding()
                }
                .padding(.horizontal)
                .padding(.top)
                Spacer()
                
            }
            .frame(height: CGFloat.relativeToScreen(.height, ratio: 0.65))
            .background(Color.brandBackground)
            .cornerRadius(20).shadow(radius: 20)
            .padding()
    }
}

struct MasjidChangeRequestView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MasjidChangeRequestView(isShowingThisView: .constant(true), selectedMasjid: .constant(Masjid()))
        }

    }
}
