import SwiftUI

struct RegisterUserView: View {
    @State private var userId: String = ""
    @State private var confirmPassword: String = ""
    @State private var email: String = ""
    @State private var nickname: String = ""
    @State private var password: String = ""
    @State private var passwordMismatch = false
    @State private var duplicateErrorMessage: String? = nil
    @Binding var selectedUniversity: Int
    @Binding var selectedGrade: Int
    @Binding var userInfo: User
    let onNext: () -> Void
    
    // 全項目が入力済みかどうか
    private var isFormValid: Bool {
        !userId.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        !email.isEmpty &&
        !nickname.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("会員情報")
                .font(.title)
                .bold()
                .padding(.bottom, 10)
            
            Group {
                VStack(alignment: .leading) {
                    Text("ID")
                    TextField("ID", text: $userId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                }
                VStack(alignment: .leading) {
                    Text("PASSWORD")
                    SecureField("PASSWORD", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.oneTimeCode) 
                    
                    SecureField("PASSWORD（確認）", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack(alignment: .leading) {
                    Text("E-MAIL")
                    TextField("E-MAIL", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                VStack(alignment: .leading) {
                    Text("ニックネーム")
                    TextField("ニックネーム", text: $nickname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            
            Button(action: {
                if password != confirmPassword {
                    passwordMismatch = true
                    duplicateErrorMessage = nil
                    return
                } else {
                    passwordMismatch = false
                    duplicateErrorMessage = nil
                    insertUser(userId: userId, password: password, email: email, nickname: nickname, university: selectedUniversity, grade: selectedGrade){result in
                        DispatchQueue.main.async{
                            guard let result = result else{
                                duplicateErrorMessage = "名前かユーザーIDが重複しています"
                                return
                            }
                            userInfo = result
                            onNext()
                        }
                    }
                }
            }) {
                Text("会員登録")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        isFormValid
                        ? Color.daysPink
                        : Color.gray.opacity(0.3),
                        in: RoundedRectangle(cornerRadius: 8)
                    )
                    .foregroundColor(.white)
            }
            .disabled(!isFormValid) // 全部入力されていない場合は無効化
            .padding(.top, 20)
            
            if passwordMismatch {
                Text("パスワードが一致しません")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            if let errorMessage = duplicateErrorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            Spacer()
        }
        .padding()
    }
}
