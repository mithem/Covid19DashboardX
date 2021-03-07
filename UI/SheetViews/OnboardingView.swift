//
//  OnboardingView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 07.03.21.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Text("Covid19DashboardX")
                .bold()
                .font(.largeTitle)
                .padding(.top, 50)
            Spacer()
            VStack(alignment: .leading, spacing: 30) {
                Item(localizationKey: "overview", image: "newspaper", color: .gray)
                Item(localizationKey: "compare", image: "scalemass", color: .orange)
                Item(localizationKey: "spotlight", image: "magnifyingglass", color: .green)
            }
            .padding(.horizontal, 60)
            Spacer()
            Button(action: {
                save()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Finish")
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .padding(.bottom, 100)
        }
        .onDisappear {
            save()
        }
    }
    
    func save() {
        UserDefaults().set(true, forKey: UserDefaultsKeys.dontShowOnboardingScreen)
    }
}

fileprivate struct Item: View {
    let localizationKey: String
    let image: String
    let color: Color
    var body: some View {
        HStack {
            Image(systemName: image)
                .foregroundColor(color)
                .font(.system(size: 40, design: .rounded))
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(s("onb_" + localizationKey + "_title"))
                    .font(.title3)
                Text(s("onb_" + localizationKey + "_body"))
            }
        }
    }
    
    private func s(_ key: String) -> String {
        NSLocalizedString(key, comment: key)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
