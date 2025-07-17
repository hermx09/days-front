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
    @Binding var path: NavigationPath
    var body: some View {
        VStack{
            Button(action: {
                print("トークン削除")
                UserDefaults.standard.removeObject(forKey: "jwtToken")
                auth = true
                settingFlg = false
                path.removeLast(path.count)
            }, label: {
                Text("ログアウト")
                    .foregroundColor(.black)
            })
        }
    }
}
