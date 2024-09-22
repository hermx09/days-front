//
//  boardView.swift
//  days
//
//  Created by 長山瑞 on 2024/09/20.
//

import SwiftUI

struct boardView: View {
    var body: some View {
        VStack{
            HStack{
                Text("掲示板")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.bottom)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "person")
                    Text("自分の投稿")
                        .foregroundColor(.black)
                    Spacer()
                }
            })
            .padding(.bottom, 10)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "bubble.fill")
                        .foregroundColor(.green)
                    Text("コメントした投稿")
                        .foregroundColor(.black)
                    Spacer()
                }
            })
            .padding(.bottom, 10)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.yellow)
                    Text("保存した投稿")
                        .foregroundColor(.black)
                    Spacer()
                }
            })
            .padding(.bottom, 10)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "sun.max")
                        .foregroundColor(.orange)
                    Text("みんなが見ている投稿")
                        .foregroundColor(.black)
                    Spacer()
                }
            })
            .padding(.bottom, 10)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "smiley")
                        .foregroundColor(.orange)
                    Text("人気投稿")
                        .foregroundColor(.black)
                    Spacer()
                }
            })
            .padding(.bottom, 20)
            Divider()
                .background(.gray)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "paperclip")
                        .rotationEffect(.degrees(-43))
                    Text("自由掲示板")
                    Spacer()
                }
            })
            .padding(.top, 20)
            .padding(.bottom,  10)
            .foregroundColor(.black)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "paperclip")
                        .rotationEffect(.degrees(-43))
                    Text("新入生掲示板")
                    Spacer()
                }
            })
            .foregroundColor(.black)
            .padding(.bottom,  10)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "paperclip")
                        .rotationEffect(.degrees(-43))
                    Text("卒業生掲示板")
                    Spacer()
                }
            })
            .padding(.bottom,  10)
            .foregroundColor(.black)
            Button(action: {}, label: {
                HStack{
                    Image(systemName: "paperclip")
                        .rotationEffect(.degrees(-43))
                    Text("情報掲示板")
                    Spacer()
                }
            })
            .foregroundColor(.black)
        }
        .padding(40)
        Spacer()
    }
}

#Preview {
    boardView()
}
