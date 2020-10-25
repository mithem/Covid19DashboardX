//
//  CustomButtonStyle.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 23.10.20.
//

import Foundation
import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.accentColor)
                    .opacity(colorScheme == .dark ? 0.7 : 1)
            )
            .hoverEffect(.highlight)
    }
}


struct CustomButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Button("Hello world", action: {})
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            Button("Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum", action: {})
        }
        .buttonStyle(CustomButtonStyle())
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
