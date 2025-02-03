//
//  searchResult.swift
//  days
//
//  Created by 長山瑞 on 2024/10/01.
//

import SwiftUI
import Combine

struct searchResult: View {
    @Binding var searchResult: String
    var body: some View {
        Text("\(searchResult)")
            .foregroundColor(.black);
    }
}

/*#Preview {
    searchResult()
}*/
