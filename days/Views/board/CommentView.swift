import SwiftUI

struct CommentView: View {
    let comment: commentResponse
    @State var responseComments: [responseCommentResponse] = []
    @Binding var targetCommentId: Int
    @FocusState.Binding var isFocused: Bool
    @Binding var isCommentFavoriteList : [Int: Bool]
    @Binding var isResponseCommentFavoriteList : [Int: Bool]
    @Binding var userId: String

    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                HStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(comment.isAnonymous ? "匿名" : comment.commenterId)
                        .font(.body)
                    Spacer()
                    HStack {
                        Button(action: {
                            toggleFavorite(commentId: comment.commentId, userId: userId, actionName: "favorite"){result in
                                print("開始")
                                
                                guard let result = result else{
                                    return
                                }
                                if(result){
                                    isCommentFavoriteList[comment.commentId] = true
                                }else{
                                    isCommentFavoriteList[comment.commentId] = false
                                }
                            }
                        }, label: {
                            Image(systemName: (isCommentFavoriteList[comment.commentId] ?? false) ? "heart.fill": "heart")
                                .padding(5)
                                .foregroundColor((isCommentFavoriteList[comment.commentId] ?? false) ? .red: .gray)
                        })
                        Divider()
                            .frame(height: 24)
                            .background(Color.gray.opacity(0.3))
                        Button(action: {
                            targetCommentId = comment.commentId
                            isFocused = true
                        }) {
                            Image(systemName: "bubble")
                                .padding(5)
                        }
                        Divider()
                            .frame(height: 24)
                            .background(Color.gray.opacity(0.3))
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .padding(5)
                        }
                    }
                    .background(Color(red: 0xD9/255, green: 0xD9/255, blue: 0xD9/255))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(red: 0xD9/255, green: 0xD9/255, blue: 0xD9/255), lineWidth: 1)
                    )
                }
                Text(comment.commentMessage)
                    .padding(5)
                    .font(.body)
                
                Text(comment.createdAt)
                    .font(.caption2)
                    .foregroundColor(Color(red: 0.4039, green: 0.3961, blue: 0.3961))
            ScrollView{
                ForEach(responseComments){responseComment in
                    HStack{
                        VStack{
                            Image(systemName: "arrow.turn.down.right")
                            Spacer()
                        }
                        VStack(alignment: .leading){
                            HStack {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text(responseComment.isAnonymous ? "匿名" : responseComment.commenterId)
                                    .font(.body)
                                Spacer()
                                HStack {
                                    Button(action: {
                                        toggleFavorite(responseCommentId: responseComment.responseCommentId, userId: userId, actionName: "favorite"){result in
                                            guard let result = result else{
                                                return
                                            }
                                            if(result){
                                                isResponseCommentFavoriteList[responseComment.responseCommentId] = true
                                            }else{
                                                isResponseCommentFavoriteList[responseComment.responseCommentId] = false
                                            }
                                        }
                                    }, label: {
                                        Image(systemName: (isResponseCommentFavoriteList[responseComment.responseCommentId] ?? false) ? "heart.fill": "heart")
                                            .padding(5)
                                            .foregroundColor((isResponseCommentFavoriteList[responseComment.responseCommentId] ?? false) ? .red: .gray)
                                    })
                                    .onAppear{
                                        print("リストは", isResponseCommentFavoriteList)
                                    }
                                    Divider()
                                        .frame(height: 24)
                                        .background(Color.gray.opacity(0.3))
                                    Button(action: {}) {
                                        Image(systemName: "ellipsis")
                                            .rotationEffect(.degrees(90))
                                            .padding(5)
                                    }
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color(red: 0xD9/255.0, green: 0xD9/255.0, blue: 0xD9/255.0))
                                )
                            }
                            Text(responseComment.responseMessage)
                                .padding(5)
                                .font(.body)
                            
                            Text(responseComment.createdAt)
                                .font(.caption2)
                                .foregroundColor(Color(red: 0.4039, green: 0.3961, blue: 0.3961))
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(red: 0.96, green: 0.96, blue: 0.96))
                        )
                    }
                    .padding(.top, 5)
                }
            }
            .padding(.leading, 15)
            .padding(.top, 5)
        }
        .onAppear {
            getResponseComments(commentId: comment.commentId){results in
                DispatchQueue.main.async{
                    guard let results = results else{
                        print("取得失敗")
                        return
                    }
                 responseComments = results
                }
            }
        }
        .foregroundColor(.black)
    }
}
