//
//  SearchBarView.swift
//  days
//
//  Created by 長山瑞 on 2025/07/21.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var focus: FocusState<Bool>.Binding
    var placeholder: String = "検索"
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                // ここはメニューなど好きに追加可能
            }) {
                Image(systemName: "line.3.horizontal")
                    .padding(.leading, 10)
            }
            TextField(placeholder, text: $text)
                .font(.caption)
                .onSubmit {
                    onSearch()
                }
                .focused(focus)
                .submitLabel(.search)
            Spacer()
            Button(action: {
                focus.wrappedValue = false
                onSearch()
            }) {
                Image(systemName: "magnifyingglass")
                    .padding(.trailing, 10)
            }
        }
        .foregroundColor(.black)
        .padding(5)
        .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
        .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
        .padding(10)
    }
}
