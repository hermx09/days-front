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
    @Binding var homePath: NavigationPath
    var body: some View {
        VStack{
            Button(action: {                
                UserDefaults.standard.removeObject(forKey: "jwtToken")
                auth = true
                settingFlg = false
                homePath.removeLast(homePath.count)
            }, label: {
                Text("ログアウト")
                    .foregroundColor(.black)
            })
        }
    }
}
