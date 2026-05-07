//
//  PhoneVerificationView.swift
//  days
//
//  Created by 長山瑞 on 2025/08/08.
//

import SwiftUI

struct PhoneVerificationView: View {
    let onNext: () -> Void
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button(action: {
            onNext()
        }, label: {
            Text("次へ")
        })
    }
}
