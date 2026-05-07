import Combine
import Foundation

struct getSchoolsResponse: Codable, Identifiable, Hashable{
    var id: Int
    var name: String
}

final class SchoolSelectionViewModel: ObservableObject {
    @Published var searchSchoolText: String = ""
    @Published var searchResults: [getSchoolsResponse] = []
    private var isSelectionInProgress = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchSchoolText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if self.isSelectionInProgress { return }
                if query.isEmpty {
                    self.searchResults = []
                } else {
                    self.fetchSchools(query: query){result in
                        DispatchQueue.main.async{                            
                            self.searchResults = result ?? []
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    func selectSchool(_ name: String) {
            isSelectionInProgress = true
            searchSchoolText = name
            searchResults = []
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isSelectionInProgress = false
            }
        }
    
    private func fetchSchools(query: String, completion: @escaping([getSchoolsResponse]?) -> Void) {
        
        let queryItems = [URLQueryItem(name: "query", value: String(query))]
        APIRequest.getRequest(endPoint: "/getUniversities", queryItems: queryItems){(result: Result<[getSchoolsResponse], Error>) in
            switch result{
            case .success(let success):
                completion(success)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
