//
//  ModalView.swift
//  days
//
//  Created by 長山瑞 on 2024/10/01.
//

import SwiftUI

struct ModalView: View {
    @Binding var isPresented: Bool
    @Binding var resultData: [MyResponse]
    @Binding var tabClick2: Bool
    @Binding var friendTableFlg: Bool
    //@Binding var name: String
    //@Binding var userId: String
    @Binding var friendId: String
    var body: some View {
        NavigationStack{
            VStack{
                Text("検索結果")
                    .padding(.top,50)
                    .padding(.trailing, 200)
                    .padding(.bottom)
                    .font(.largeTitle)
                ForEach(resultData){data in
                    Button(action: {
                        friendId = data.userId
                        friendTableFlg = true
                        tabClick2 = false
                        isPresented = false
                    }, label: {
                        HStack{
                            Text(data.resultName)
                            Text(data.userId)
                        }
                        .font(.title)
                        .foregroundColor(.black)
                    })
                    Spacer()
                }
            }
            .padding()
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Image(systemName: "chevron.backward")
                        Text("戻る")
                    })
                    .foregroundColor(.black)
                }
            }
        }
        
    }
}

/*struct ModalView_Previews: PreviewProvider {
    @State static var isPresented = true
    @State static var name = "サンプルユーザー"
    @State static var userId = "testUser"
    
    static var previews: some View {
        ModalView(isPresented: $isPresented, name: $name, userId: $userId)
    }
}
*/
