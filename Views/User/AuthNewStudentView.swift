import SwiftUI
import UniformTypeIdentifiers

struct AuthNewStudentView: View {
    @State private var examNumber: String = ""
    @State private var selectedFileURL: URL?
    @State private var selectedFileName: String = ""
    @State private var isImporting: Bool = false
    @State private var uploadStatus: String = ""    
    @Binding var userInfo: User
    @Binding var auth: Bool
    @Binding var userId: String
    @Binding var intUserId: Int
    @Binding var tabClick1: Bool
    @Binding var authPath: NavigationPath
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                headerSection
                descriptionSection
                fileInputSection
                uploadButton
                statusMessage
            }
            .padding()
        }
    }
}

// MARK: - UI Sections
private extension AuthNewStudentView {
    var headerSection: some View {
        Text("新入生認証")
            .font(.title2)
            .bold()
    }
    
    var descriptionSection: some View {
        Group {
            Text("・3月まで新入生掲示板のみ利用できます。")
            Text("認証処理まで最大72時間（休日を除く)かかる場合があります。")
            
            Divider()
            
            Text("合格通知書または合格証添付(イメージまたはPDF)")
            Text("・所属大学から発行された今年の合格通知書及び合格証のみ提出可能です。")
            Text("・他人の合格通知書/合格証を悪用、偽造した場合、関連法によっては法的措置が取られることがあります。")
            Text("・合格通知書には必ず受験番号が記載されてなければいけません。")
            Text("・合格通知書の受験番号と入力した受験番号が異なる場合、認証が取り消される場合があります。")
            Text("・受験番号を除いた生年月日などの個人情報は使用されませんので、該当情報を隠してから添付してください。")
            
            Divider()
            
            Text("新入生の場合、すべてのコミュニティを利用するためには、3月以降に在学証明資料が発行可能な時点で、在学生認証手続きを再び進める必要があります。")
        }
    }
    
    var fileInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("受験番号を入力", text: $examNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("ファイルを選択") {
                isImporting.toggle()
            }
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [.pdf, .image],
                allowsMultipleSelection: false
            ) { result in
                handleFileSelection(result: result)
            }
            
            if !selectedFileName.isEmpty {
                Text("選択済み: \(selectedFileName)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
    
    var uploadButton: some View {
        Button("アップロード") {
            uploadNewStudentData()
        }
        .disabled(examNumber.isEmpty || selectedFileURL == nil)
        .padding()
        .background(Color.blue.cornerRadius(8))
        .foregroundColor(.white)
    }
    
    var statusMessage: some View {
        Group {
            if !uploadStatus.isEmpty {
                Text(uploadStatus)
                    .foregroundColor(uploadStatus.contains("成功") ? .green : .red)
            }
        }
    }
}

// MARK: - File Handling
private extension AuthNewStudentView {
    func handleFileSelection(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                // セキュリティスコープ付きアクセスを開始
                if url.startAccessingSecurityScopedResource() {
                    selectedFileURL = url
                    selectedFileName = url.lastPathComponent
                    
                    // 必要ならファイル内容を読み込んだりもできる
                    do {
                        let data = try Data(contentsOf: url)
                        print("ファイルサイズ: \(data.count) bytes")
                    } catch {
                        print("ファイル読み込みエラー: \(error.localizedDescription)")
                    }
                    
                    // アクセスが終わったら必ず解放する
                    url.stopAccessingSecurityScopedResource()
                } else {
                    print("セキュリティスコープ付きリソースのアクセス開始に失敗")
                }
            }
        case .failure(let error):
            print("ファイル選択エラー: \(error.localizedDescription)")
        }
    }

}

// MARK: - Upload Logic
private extension AuthNewStudentView {
    func uploadNewStudentData() {
        guard let fileURL = selectedFileURL else {
            print("ファイルURLがありません")
            return
        }

        if fileURL.startAccessingSecurityScopedResource() {
            defer {
                fileURL.stopAccessingSecurityScopedResource()
            }
            
            do {
                let fileData = try Data(contentsOf: fileURL)
                print("ファイル名: \(fileURL.lastPathComponent)")
                print("ファイルサイズ: \(fileData.count) bytes")

                let boundary = "Boundary-\(UUID().uuidString)"
                let body = createMultipartBody(boundary: boundary, examNumber: examNumber, userId: userInfo.id, fileURL: fileURL)

                APIRequest.uploadMultipart(
                    endPoint: "/uploadNewStudent",
                    body: body,
                    boundary: boundary
                ) { (result: Result<UploadResponse, Error>) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            uploadStatus = "アップロード成功！"
                            print("ファイルok")
                            authPath = NavigationPath()
                            // userInfo を初期化
                                userInfo = User(
                                    id: 0,
                                    name: "",                                    
                                    email: "",
                                    userId: "",
                                    faculty: 0,
                                    status: "" // もし status がある場合
                                )

                                // ローカルの入力項目もリセット
                                examNumber = ""
                                selectedFileURL = nil
                                selectedFileName = ""
                        case .failure(let error):
                            uploadStatus = "アップロード失敗: \(error.localizedDescription)"
                        }
                    }
                }
            } catch {
                print("ファイル読み込みエラー: \(error.localizedDescription)")
                uploadStatus = "ファイル読み込みエラー: \(error.localizedDescription)"
            }
        } else {
            print("セキュリティスコープ付きリソースのアクセス開始に失敗")
            uploadStatus = "ファイルのアクセス権限がありません"
        }
    }

    
    func createMultipartBody(boundary: String, examNumber: String, userId: Int, fileURL: URL) -> Data {
        var body = Data()
        
        // examNumber
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"examNumber\"\r\n\r\n")
        body.append("\(examNumber)\r\n")
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"userId\"\r\n\r\n")
        body.append("\(userId)\r\n")
        
        // file
        if let fileData = try? Data(contentsOf: fileURL) {
            let mimeType = mimeTypeForFile(fileURL)
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n")
            body.append("Content-Type: \(mimeType)\r\n\r\n")
            body.append(fileData)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    func mimeTypeForFile(_ url: URL) -> String {
        switch url.pathExtension.lowercased() {
        case "pdf":
            return "application/pdf"
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        default:
            return "application/octet-stream"
        }
    }
}

// MARK: - Data Extension
private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

struct UploadResponse: Decodable {
    let success: Bool
    let message: String
}
