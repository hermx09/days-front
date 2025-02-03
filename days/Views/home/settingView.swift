//
//  settingView.swift
//  days
//
//  Created by 長山瑞 on 2024/10/07.
//

import SwiftUI

struct settingView: View {
    @Binding var auth: Bool
    @Binding var settingFlg: Bool
    var body: some View {
        VStack{
            Button(action: {
                print("トークン削除")
                UserDefaults.standard.removeObject(forKey: "jwtToken")
                auth = true
                settingFlg = false
            }, label: {
                Text("ログアウト")
                    .foregroundColor(.black)
            })
        }
    }
}

struct settingView_Previews: PreviewProvider{
    @State static var auth = false
    @State static var settingFlg = true
    static var previews: some View{
        settingView(auth: $auth, settingFlg: $settingFlg)
    }
}
