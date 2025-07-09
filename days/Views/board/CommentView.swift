import SwiftUI

struct CommentView: View {
    let comment: commentResponse
    @State var responseComments: [responseCommentResponse] = []
    @Binding var targetCommentId: Int
    @FocusState.Binding var isFocused: Bool
    @State var isResponseFavoriteList : [Int: Bool] = [:]

    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                HStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(comment.commenterId)
                        .font(.body)
                    Spacer()
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "heart.fill")
                                .padding(5)
                        }
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
                                Text(responseComment.commenterId)
                                    .font(.body)
                                Spacer()
                                HStack {
                                    Button(action: {}) {
                                        Image(systemName: "heart.fill")
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
