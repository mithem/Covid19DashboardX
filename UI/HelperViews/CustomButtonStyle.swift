//
//  CustomButtonStyle.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 23.10.20.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    func makeBody(configuration: Configuration) -> some View {
        #if os(watchOS)
        return content(configuration)
        #else
        return content(configuration)
            .hoverEffect(.highlight)
        #endif
    }
    
    func content(_ configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.accentColor)
                    .opacity(colorScheme == .dark ? 0.7 : 1)
            )
    }
}


struct CustomButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Button("Hello world", action: {})
                .preferredColorScheme(.dark)
            Button("Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum", action: {})
        }
        .buttonStyle(CustomButtonStyle())
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
