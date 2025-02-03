//
//  searchFriends.swift
//  days
//
//  Created by 長山瑞 on 2024/09/19.
//

import SwiftUI

struct searchFriends: View {
    
    enum field: Hashable{
        case friendsName
    }
    
    @State var inputName = ""
    @FocusState var focus: field?
    
    var body: some View {
            HStack{
                Button(action: {}, label: {
                    Image(systemName: "line.3.horizontal")
                        .padding(.leading, 10)
                })
                TextField("友達検索", text: $inputName)
                    .font(.caption)
                    .onSubmit {
                        print("入力された値: \(inputName)")
                    }
                    .focused($focus, equals: .friendsName)
                    .submitLabel(.search)
                Spacer()
                Button(action: {
                    focus = nil
                    print("入力された値: \(inputName)")
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing, 10)
                })
            }
            .foregroundColor(.black)
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
            .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
            .padding(10)
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onAppear{
            print("yo")
        }
        .onTapGesture {
            focus = nil
            print("タップ")
            }
    }
}

#Preview {
    searchFriends()
}
