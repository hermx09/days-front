//
//  authView.swift
//  days
//
//  Created by 長山瑞 on 2024/10/05.
//

import SwiftUI

struct authView: View {
    @FocusState var focus: Bool
    @State var idName = ""
    @State var passName = ""
    @State private var alertFlg = false
    @Binding var auth: Bool
    @Binding var tabClick1: Bool
    @Binding var userId: String
    @Binding var userName: String
    @Binding var faculty: String
    
    var body: some View {
        VStack{
            Image(systemName: "star.circle.fill")
                .resizable()
                .frame(width: 45, height: 45)
                .padding(.top, 100)
                .padding(.bottom)
            Text("大学生活をもっと楽に\n      楽しく過ごせる")
                .foregroundColor(.gray)
                .font(.headline)
                .padding(.bottom, 5)
            Text("DAYS")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.984, green: 0.765, blue: 0.765))
                .padding(.bottom)
            TextField("ID", text: $idName)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.leading, 10)
                .font(.caption)
                .focused($focus)
                .foregroundColor(.black)
                .padding(7)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
                .padding(.bottom, 1)
            TextField("PASSWORD", text: $passName)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.leading, 10)
                .font(.caption)
                .focused($focus)
                .foregroundColor(.black)
                .padding(7)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
            Button(action: {
                focus = false
                loginCheck(idName: idName, passName: passName){result in
                    DispatchQueue.main.async {
                        if let result = result{
                            print("帰ってきたのは: \(result)")
                            if(result){
                                userId = idName
                                auth = false
                                tabClick1 = true
                            }else{
                                alertFlg = true
                            }
                        }else{
                            print("取得できませんでした")
                        }
                        
                    }
                }
            }, label: {
                HStack{
                    Spacer()
                    Text("DAYS ログイン")
                        .foregroundColor(.black)
                    Spacer()
                }
            })
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
            .background(Color(red: 0.984, green: 0.765, blue: 0.765), in: RoundedRectangle(cornerRadius: 40))
            Button(action: {}, label: {
                Text("ID / PASSWORD 忘れた場合")
                    .foregroundColor(.gray)
                    .font(.caption)
            })
            .padding(.top, 50)
            .padding(.bottom, 5)
            Button(action: {}, label: {
                Text("アカウント作成")
                    .foregroundColor(.black)
                    .font(.caption)
            })
            Spacer()
        }
        .onTapGesture {
            focus = false
        }
        .onAppear{
            sendToken(){result in
                DispatchQueue.main.async{
                    if let result = result{
                        print("帰ってきたのは: \(result)")
                        if(result.startFlg){
                            getUserData(userId: result.message){result in
                                DispatchQueue.main.async{
                                    if let result = result{
                                        print(result)
                                        userName = result.userName
                                        faculty = result.faculty
                                    }
                                }
                            }
                            userId = result.message
                            auth = false
                            tabClick1 = true
                        }
                    }else{
                        print("トークン無効")
                    }
                }
            }
        }
        .alert(isPresented: $alertFlg){
            Alert(title: Text("IDかパスワードが不正です"),
                  dismissButton: .default(Text("閉じる")))
        }
        .padding(30)
    }
    
}

struct authView_Previews: PreviewProvider {
    @State static var auth = true
    @State static var tabClick1 = false
    @State static var userId = "a"
    @State static var userName = "あ"
    @State static var faculty = "商学部"
    
    static var previews: some View {
        authView(auth: $auth, tabClick1: $tabClick1, userId: $userId, userName: $userName, faculty: $faculty)
    }
}
