import SwiftUI
import Combine

struct SchoolSelectionView: View {
    let onNext: (Int, Int) -> Void
    @StateObject private var viewModel = SchoolSelectionViewModel()
    
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @FocusState var searchSchoolFocused: Bool
    @State private var selectedUniversity: String = ""
    @State var selectedUniversityId: Int = 0
    
    private var yearOptions: [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array((currentYear - 10)...currentYear).reversed()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("学校選択")
                .font(.title)
                .bold()
            
            // 入学年度
            VStack(alignment: .leading) {
                Text("入学年度")
                    .font(.headline)
                
                Picker("入学年度を選択", selection: $selectedYear) {
                    ForEach(yearOptions, id: \.self) { year in
                        Text("\(String(year))年").tag(year)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
            }
            
            // 学校検索
            VStack(alignment: .leading, spacing: 5) {
                Text("学校")
                    .font(.headline)
                
                SearchBarView(
                    text: $viewModel.searchSchoolText,
                    focus: $searchSchoolFocused,
                    placeholder: "学校の名前を検索してください"
                ) {}
                
                if !viewModel.searchResults.isEmpty {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(viewModel.searchResults, id: \.self) { school in
                            Button(action: {
                                viewModel.selectSchool(school.name)
                                selectedUniversity = school.name  // 選択した学校名をセット
                                selectedUniversityId = school.id
                                searchSchoolFocused = false
                                viewModel.searchResults = []
                            }) {
                                Text(school.name)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                            }
                            Divider()
                        }
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            
            Spacer()
            
            Button(action: {
                let grade = calculateGrade(from: selectedYear)
                onNext(selectedUniversityId, grade)
            }) {
                Text("次へ")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        selectedUniversity.isEmpty
                        ? Color.gray.opacity(0.3)   // 未選択時はグレーアウト
                        : Color.daysPink
                        , in: RoundedRectangle(cornerRadius: 40)
                    )
                    .foregroundColor(.black)
            }
            .disabled(selectedUniversity.isEmpty)  // 選択されてなければ押せない
            .padding(.top)
        }
        .padding()
    }
}

func calculateGrade(from entryYear: Int) -> Int {
    let currentYear = Calendar.current.component(.year, from: Date())
    return (currentYear - entryYear) + 1
}
