//
//  daysApp.swift
//  days
//
//  Created by 長山瑞 on 2024/08/21.
//

import SwiftUI

@main
struct daysApp: App {
    @State var lectureData: [lectureResponse] = [] // 初期化

    var body: some Scene {
        WindowGroup {
            ContentView(lectureData: $lectureData)
        }
    }
}
