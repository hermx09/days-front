import SwiftUI

struct CheckPolicyView: View {
    let onNext: () -> Void
    @State private var selectAll = false
    @State private var agreements: [String: Bool] = [
        "サービス利用規約同意(必須)": false,
        "連絡先・情報提供の同意(必須)": false,
        "コミュニティ利用規約同意(必須)": false,
        "不適切なコンテンツの通報ポリシー(必須)": false,
        "サービス利用制限の条件(必須)": false,
        "広告受信の同意(任意)": false
    ]
    
    // 必須項目が全部チェック済みかどうか
    private var isRequiredAgreed: Bool {
        !agreements.filter { $0.key.contains("(必須)") }.contains { !$0.value }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("アカウント作成")
                .font(.title2)
                .bold()
            Text("利用規約同意")
                .font(.title2)
                .bold()
                .foregroundColor(.daysPink)
            
            HStack {
                CheckBoxView(isChecked: $selectAll)
                    .onChange(of: selectAll) { newValue in
                        for key in agreements.keys {
                            agreements[key] = newValue
                        }
                    }
                Text("以下の規約すべてに同意します")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            ForEach(agreements.keys.sorted(), id: \.self) { key in
                HStack {
                    CheckBoxView(isChecked: Binding(
                        get: { agreements[key] ?? false },
                        set: { newValue in
                            agreements[key] = newValue
                            // 全部選ばれているか確認して selectAll を更新
                            selectAll = !agreements.values.contains(false)
                        }
                    ))
                    Text(key)
                }
            }
            
            Button(action: {
                onNext()
            }) {
                HStack {
                    Spacer()
                    Text("次へ")
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
            .background(isRequiredAgreed ? Color.daysPink : Color.gray.opacity(0.3),
                        in: RoundedRectangle(cornerRadius: 40))
            .disabled(!isRequiredAgreed) // 必須項目未同意なら押せない
        }
        .padding()
        Spacer()
    }
}

struct CheckBoxView: View {
    @Binding var isChecked: Bool

    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .foregroundColor(.blue)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
