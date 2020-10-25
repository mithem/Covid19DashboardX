//
//  SearchBar.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 04.10.20.
// https://www.appcoda.com/swiftui-search-bar/

import SwiftUI

struct SearchBar: View {
    @Binding var searchTerm: String
    @State private var isEditing = false
    @State private var hoverOnCancelBtn = false
    var body: some View {
        HStack {
            TextField("Search", text: $searchTerm)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .onTapGesture {
                    isEditing = true
                }
                .cornerRadius(6)
                .overlay(
                    Image(systemName: isEditing ? "multiply.circle.fill" : "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                        .hoverEffect()
                        .onTapGesture {
                            if isEditing {
                                searchTerm = ""
                            } else {
                                isEditing = true
                            }
                        }
                )
                .transition(.move(edge: .trailing)) // moves with Cancel btn
                .animation(.default)
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.searchTerm = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    ZStack {
                        if hoverOnCancelBtn {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.secondary)
                                .opacity(0.2)
                                .frame(width: 70, height: 30)
                        }
                        Text("Cancel")
                    }
                }
                .padding(.trailing, 10)
                .onHover {
                    hoverOnCancelBtn = $0
                }
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBar(searchTerm: .constant("hello, world!"))
            SearchBar(searchTerm: .constant(""))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
