//
//  SchoolAuthView.swift
//  days
//
//  Created by 長山瑞 on 2025/08/10.
//

import SwiftUI

struct AuthUserView: View {
    @Binding var path: NavigationPath    
    var body: some View {
        VStack{
            Text("学校認証")
            Button(action: {
                path.append(AuthStep.authNewStudent)
            }, label: {
                Text("新入生認証")
            })
            Button(action: {
                path.append(AuthStep.authCurrentStudent)
            }, label: {
                Text("在学生認証")
            })
            Button(action: {
                path.append(AuthStep.authGraduate)
            }, label: {
                Text("卒業生認証")
            })
        }
    }
}

