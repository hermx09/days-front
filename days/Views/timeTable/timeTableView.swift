//
//  timeTableView.swift
//  days
//
//  Created by 長山瑞 on 2024/09/15.
//

import SwiftUI

struct timeTableView: View {
    var year = "2024"
    var semester = "春"
    let days = ["月", "火", "水", "木", "金", "土"]
    let periods = [1, 2, 3, 4, 5, 6]
    var gpa = 1.68
    @State var grade = 4
    @State var subject = 28
    @State var language = 15
    @State var basic = 38
    @State var health = 4
    @State var sum = 144
    @State var resultName = ""
    @State var isPresented = false
    @State var modalName = ""
    @Binding var tabClick2: Bool
    @Binding var addLectureFlg: Bool
    @Binding var userId: String
    @State var resultData: [MyResponse] = []
    @Binding var friendId: String
    @Binding var friendTableFlg: Bool
    @Binding var searchLectureResultFlg: Bool
    
    // グリッドの雛形
    @State var gridInit = [
        [" "," "," "," "," "," "],
        [" "," "," "," "," "," "],
        [" "," "," "," "," "," "],
        [" "," "," "," "," "," "],
        [" "," "," "," "," "," "],
        [" "," "," "," "," "," "],
    ]
    //月曜: 0, 火曜: 1, 水曜: 2, 木曜: 3, 金曜: 4, 土曜: 5
    @State var tables = [
        timeTalbes(lectureTime: 3, lectureName: "情報システム論", teacherName: "孫　セミ", roomNum: "1123", day: 0),
        timeTalbes(lectureTime: 5, lectureName: "タコ", teacherName: "セミバカ", roomNum: "1234", day: 4),
        timeTalbes(lectureTime: 4, lectureName: "消費者行動論", teacherName: "佐藤平国", roomNum: "1011", day: 0),
        timeTalbes(lectureTime: 5, lectureName: "広告論", teacherName: "田中瑞", roomNum: "100", day: 3)
    ]
    
    @State var inputName = ""
    @FocusState var focus: Bool
    
    var body: some View {
        ScrollView(.vertical){
            HStack{
                Text("\(year)年 \(semester)学期")
                    .font(.callout)
                    .padding(.top, 20)
                    .padding(.leading,30)
                    .foregroundColor(.red)
                Spacer()
            }
            HStack{
                Text("\(grade)年生")
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    tabClick2 = false
                    addLectureFlg = true
                }, label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                })
                .padding(.trailing, 10)
                Button(action: {}, label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 25, height: 25)
                })
                .padding(.trailing, 10)
                Button(action: {}, label: {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
            }
            .foregroundColor(.black)
            .padding(.trailing)
            .padding(.leading, 30)
            .padding(.bottom, 30)
            
            Grid(horizontalSpacing: 1, verticalSpacing: 1){
                GridRow{
                    Text("")
                        .frame(width: 20, height: 30)
                    ForEach(0 ..< days.count, id: \.self){day in
                        Text(days[day])
                            .frame(width: 60, height: 30)
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color(Color.red), lineWidth: 0.3))
                ForEach(0 ..< periods.count, id: \.self){period in
                    GridRow{
                        Text("\(periods[period])")
                            .frame(width: 20, height: 60)
                        ForEach(0 ..< days.count, id: \.self){day in
                            Button(action: {}, label: {
                                Text(gridInit[day][period])
                                    .font(.system(size: 10))
                                    .frame(width: 60, height: 60)
                            })
                            .foregroundColor(.black)
                        }
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color(Color.red), lineWidth: 0.3))
            }
            .foregroundColor(.red)
            .onAppear{
                searchLectureResultFlg = false
                getUserLectures(userId: userId){results in
                    guard let results = results else {
                        print("取得失敗")
                        return
                    }
                    DispatchQueue.main.async{
                        print("帰ってきたのは:\(results)")
                        for result in results {
                        tables.append(timeTalbes(lectureTime: result.lectureTime, lectureName: result.lectureName, teacherName: result.teacherName, roomNum: result.roomNum, day: result.day))
                        }
                        updateGrid()
                    }
                }
            }
            HStack{
                VStack{
                    Text("現在GPA")
                        .font(.callout)
                        .padding(.bottom, -3)
                    HStack{
                        Text("\(String(format: "%.2f", gpa))")
                            .foregroundColor(.red)
                            .font(.system(size: 15))
                            .bold()
                        Text("/ 4.00")
                            .font(.system(size: 13))
                    }
                    .frame(width: 80, height: 80)
                    .overlay(Circle().stroke(lineWidth: 1.0))
                    .foregroundColor(.gray)
                }
                .padding(.leading)
                VStack{
                    Text("基礎科目")
                        .font(.callout)
                        .padding(.bottom, -3)
                    HStack{
                        Text("\(subject)")
                            .foregroundColor(.red)
                            .font(.system(size: 15))
                            .bold()
                        Text("/ 28")
                            .font(.system(size: 13))
                    }
                    .frame(width: 80, height: 80)
                    .overlay(Circle().stroke(lineWidth: 1.0))
                    .foregroundColor(.gray)
                }
                .padding(.leading)
                VStack{
                    Text("語学")
                        .font(.callout)
                        .padding(.bottom, -3)
                    HStack{
                        Text("\(language)")
                            .foregroundColor(.red)
                            .font(.system(size: 15))
                            .bold()
                        Text("/ 16")
                            .font(.system(size: 13))
                    }
                    .frame(width: 80, height: 80)
                    .overlay(Circle().stroke(lineWidth: 1.0))
                    .foregroundColor(.gray)
                }
                .padding(.leading)
                .padding(.trailing,30)
                VStack{
                    Button(action: {}, label: {
                        Image(systemName: "pencil.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.bottom, 60)
                            .padding(.trailing)
                    })
                    .foregroundColor(.black)
                }
            }
            .padding(.top)
            HStack{
                VStack{
                    Text("基本科目")
                        .font(.callout)
                        .padding(.bottom, -3)
                    HStack{
                        Text("\(basic)")
                            .foregroundColor(.red)
                            .font(.system(size: 15))
                            .bold()
                        Text("/ 42")
                            .font(.system(size: 13))
                    }
                    .frame(width: 80, height: 80)
                    .overlay(Circle().stroke(lineWidth: 1.0))
                    .foregroundColor(.gray)
                }
                .padding(.leading)
                VStack{
                    Text("運動科学")
                        .font(.callout)
                        .padding(.bottom, -3)
                    HStack{
                        Text("\(health)")
                            .foregroundColor(.red)
                            .font(.system(size: 15))
                            .bold()
                        Text("/ 4")
                            .font(.system(size: 13))
                    }
                    .frame(width: 80, height: 80)
                    .overlay(Circle().stroke(lineWidth: 1.0))
                    .foregroundColor(.gray)
                }
                .padding(.leading)
                VStack{
                    Text("合計")
                        .font(.callout)
                        .padding(.bottom, -3)
                    HStack{
                        Text("\(sum)")
                            .foregroundColor(.red)
                            .font(.system(size: 15))
                            .bold()
                        Text("/ 144")
                            .font(.system(size: 13))
                    }
                    .frame(width: 80, height: 80)
                    .overlay(Circle().stroke(lineWidth: 1.0))
                    .foregroundColor(.gray)
                }
                .padding(.leading)
            }
            .padding(.top)
            .padding(.leading,50)
            HStack{
                Button(action: {}, label: {
                    Image(systemName: "line.3.horizontal")
                        .padding(.leading, 10)
                })
                TextField("友達検索", text: $inputName)
                    .font(.caption)
                    .onSubmit {
                        searchFriends()
                    }
                    .focused($focus)
                    .submitLabel(.search)
                    Spacer()
                    Button(action: {
                        focus = false
                        searchFriends()
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .padding(.trailing, 10)
                    })
                }
                    .foregroundColor(.black)
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
                    .padding(10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .sheet(isPresented: $isPresented){
                ModalView(isPresented: $isPresented, resultData: $resultData, tabClick2: $tabClick2, friendTableFlg: $friendTableFlg, friendId: $friendId)
            }
            .onTapGesture {
                focus = false
            }
        }
    
    
    func updateGrid() {
        for table in tables{
            let dayCnt = table.day
            let periodCnt = table.lectureTime - 1
            gridInit[dayCnt][periodCnt] = "\(table.lectureName)\n\(table.teacherName)\n\(table.roomNum)"
        }
    }
    func searchFriends(){
        print("入力された値: \(inputName)")
        sendPostRequest(friendName: inputName){ results in
            DispatchQueue.main.async{
                if let results = results{
                    print("取得したのは: \(results)")
                    //modalName = result.resultName
                    resultData = results
                    isPresented = true
                }else{
                    print("名前が取得できませんでした")
                }
            }
        }
    }
}
    
    
    
struct timeTalbes: Identifiable{
        var id = UUID()
        var lectureTime: Int
        var lectureName: String
        var teacherName: String
        var roomNum: String
        var day: Int
}
    
/*struct timeTableView_Previews: PreviewProvider{
    @State static var tabClick2: Bool = true
    @State static var addLectureFlg: Bool = false
    @State static var userId: String = "a"
    @State static var MyResponse = [MyResponse(resultName: "テスト", userId: "user1234")]
    
    static var previews: some View{
        timeTableView(tabClick2: $tabClick2, addLectureFlg: $addLectureFlg, userId: $userId, resultData: $MyResponse)
    }
}*/
