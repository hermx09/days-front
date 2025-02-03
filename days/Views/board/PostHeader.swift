//
//  PostHeader.swift
//  days
//
//  Created by 長山瑞 on 2025/01/25.
//

import SwiftUI

struct PostHeader: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedBoard: String
    var body: some View {
        HStack{
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "greaterthan")
                    .rotationEffect(.degrees(180))
            })
            Spacer()
            VStack{
                Text(selectedBoard)
                    .font(.callout)
                Text("明治大学")
                    .font(.caption)
            }
            .padding(.trailing,75)
            Button(action: {}, label: {
                Image(systemName: "magnifyingglass")
            })
                .padding(.trailing,10)
            Button(action: {}, label: {
                Image(systemName: "ellipsis")
            })
                .rotationEffect(.degrees(90))
        }
        .foregroundColor(.black)
        .padding()
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
    }
}

