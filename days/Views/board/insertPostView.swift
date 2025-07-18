//
//  insertPostView.swift
//  days
//
//  Created by 長山瑞 on 2025/02/26.
//

import SwiftUI

struct insertPostView: View {
    @State var insertPostTitle: String = ""
    @State var insertPostBody: String = ""
    @State var isPostAnonymous: Bool = false
    @Binding var isPresentingInsertPostView: Bool
    @Binding var userId: String
    @Binding var boardId: Int
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    isPresentingInsertPostView = false
                }, label: {
                    Image(systemName: "xmark")
                })
                Spacer()
                Text("投稿作成")
                Spacer()
                Button(action: {
                    insertPost(title: insertPostTitle, message: insertPostBody, isAnonymous: isPostAnonymous, userId: userId, boardId: boardId){result in
                        DispatchQueue.main.async{
                            print(result)
                            isPresentingInsertPostView = false
                        }
                    }
                }, label: {
                    Image(systemName: "pencil")
                })
            }
            .foregroundColor(Color.black)
            TextField("タイトル", text: $insertPostTitle)
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
                .background(Color.clear)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray.opacity(0.3)),
                    alignment: .bottom
            )
            TextField("内容を入力してください", text: $insertPostBody)
                .padding(.horizontal)
                .foregroundColor(.black) // 文字色
                .background(Color.clear) // 背景なし
                .overlay(Rectangle().stroke(Color.clear)) // 枠を透明に
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("コミュニティー利用規約全文")
                        .font(.footnote)
                            .foregroundColor(.gray) // テキスト色
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.1)) // 薄いグレーの背景
                            .cornerRadius(20) // 丸く囲む
                })
            }
            VStack{
                Text("""
            デイズでは、みんなが楽しく会話できるコミュニティを作るために、
            コミュニティ利用ルールを設定し、それに従って運営しています。
            ルールに違反した場合、投稿が削除され、
            サービスの利用が一定期間制限されることがあります。
            投稿を作成する前に、必ずコミュニティ利用規則の全文を確認してください。
            """)
                
                Text("""
            他の人が不快に感じるような投稿は控えましょう。
            """)
                .foregroundColor(Color(red: 1.0, green: 0.39, blue: 0.39)) // #FF6464相当
                .underline()
                Text("""
            ⚠︎違法撮影物の掲載禁止  
            違法撮影物を掲載した場合、法律に基づき削除措置が取られ、サービスの利用が永久に制限されることがあります。また、関連する法律に従って刑事処罰を受ける可能性があります。
            """)
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(.bottom, 10)

            HStack{
                Button(action: {
                    
                }, label: {
                    Image(systemName: "camera")
                })
                Spacer()
                Button(action: {
                    isPostAnonymous.toggle()
                }, label: {
                    HStack{
                        Image(systemName: isPostAnonymous ? "checkmark.square" : "square")
                            .frame(width: 10, height: 10)
                        Text("匿名")
                            .font(.callout)
                    }
                    .padding(.leading, 10)
                })
            }
        }
        .padding(30)
    }
}

//#Preview {
//    insertPostView()
//}
