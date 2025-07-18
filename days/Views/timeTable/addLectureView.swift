//
//  addLectureView.swift
//  days
//
//  Created by 長山瑞 on 2024/10/08.
//

import SwiftUI


//各大学、学部情報をFacultiesにインサートしておく
struct addLectureView: View {
    @State private var selectedFaculty = "学部"
    @State private var selectedPlace = "全て"
    @State private var year = "2024年度"
    @State private var faculties = [""]
    @State private var places = ["全て"]
    @State private var springFlg = true
    @State private var autumnFlg = false
    @State private var days = ["全て", "月", "火", "水", "木", "金", "土"]
    @State private var periods = [0, 1, 2, 3, 4, 5, 6]
    @State private var daysText = "全て"
    @State private var periodsText = "全て"
    @State var lectureName = ""
    @State var teacherName = ""
    @FocusState var focus: Bool
    @Binding var lectureData: [lectureResponse]
    @Binding var searchLectureResultFlg: Bool
    @Binding var addLectureFlg: Bool
    var onSearchLectureResultView: () -> Void
    
        var body: some View {
            VStack{
                Text("授業登録")
                    .font(.title)
                HStack {
                    Text("学部")
                            Menu() {
                                ForEach(faculties, id: \.self) { faculty in
                                    Button(action: {
                                        selectedFaculty = faculty // 選択された学部を更新
                                    }) {
                                        HStack {
                                            if selectedFaculty == faculty {
                                                Image(systemName: "checkmark") // 左にチェックマークを表示
                                                    .foregroundColor(.blue)
                                            }
                                            Text(faculty)
                                        }
                                    }
                                }
                            }label: {
                                HStack{
                                    Text(selectedFaculty)
                                        .padding(.leading, 7)
                                    Spacer()
                                    Image(systemName: "arrowtriangle.down")
                                }
                            }
                            .frame(width: 270, height: 20)
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                            .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
                            .onAppear{
                                getFaculties(){ result in
                                    DispatchQueue.main.async{
                                        if let results = result{
                                            faculties = results.map{$0.facultyName}
                                        }else{
                                            print("学部データの取得に失敗")
                                            return
                                        }
                                    }
                                }
                            }
                    
                }
                HStack{
                    Text("年度")
                            Menu{
                                Button(action: {
                                    year = "2024年度"
                                }, label: {
                                    Text("2024年度")
                                })
                                Button(action: {
                                    year = "2025年度"
                                }, label: {
                                    Text("2025年度")
                                })
                            }label: {
                                HStack{
                                    Text(year)
                                        .padding(.leading, 7)
                                    Spacer()
                                    Image(systemName: "arrowtriangle.down")
                                }
                                .frame(width: 270, height: 20)
                                .padding(5)
                                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                                .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
                            }
                }
                
                HStack{
                    Text("開講期")
                        .padding(5)
                    HStack{
                        Button(action: {
                            if springFlg {
                                springFlg = false
                            }else{
                                springFlg = true
                            }
                        }, label: {
                            Image(systemName: springFlg ? "checkmark.square": "square")
                            Text("春学期")
                        })
                        Button(action: {
                            if autumnFlg {
                                autumnFlg = false
                            }else{
                                autumnFlg = true
                            }
                        }, label: {
                            Image(systemName: autumnFlg ? "checkmark.square": "square")
                            Text("秋学期")
                        })
                    }
                    Spacer()
                }
                .foregroundColor(.black)
                HStack{
                    Text("曜日")
                            Menu{
                                ForEach(days, id: \.self){day in
                                    Button(action: {
                                        daysText = day
                                    }, label: {
                                        Text(day)
                                    })
                                }
                            }label: {
                                HStack{
                                    Text(daysText)
                                        .padding(.leading, 7)
                                    Spacer()
                                    Image(systemName: "arrowtriangle.down")
                                }
                                .frame(width: 270, height: 20)
                                .padding(5)
                                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                                .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
                            }
                }
                HStack{
                    Text("時限")
                            Menu{
                                ForEach(periods, id: \.self){period in
                                    Button(action: {
                                        if(period == 0){
                                            periodsText = "全て"
                                        }else{
                                            periodsText = "\(period)"
                                        }
                                    }, label: {
                                        if(period == 0){
                                            Text("全て")
                                        }else{
                                            Text("\(period)")
                                        }
                                    })
                                }
                            }label: {
                                HStack{
                                    Text(periodsText)
                                        .padding(.leading, 7)
                                    Spacer()
                                    Image(systemName: "arrowtriangle.down")
                                }
                                .frame(width: 270, height: 20)
                                .padding(5)
                                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                                .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
                            }
                }
                HStack {
                    Text("キャンパス")
                        .font(.caption)
                            Menu() {
                                ForEach(places, id: \.self) { place in
                                    Button(action: {
                                        selectedPlace = place
                                    }) {
                                        HStack {
                                            if selectedPlace == place {
                                                Image(systemName: "checkmark") // 左にチェックマークを表示
                                                    .foregroundColor(.blue)
                                            }
                                            Text(place)
                                        }
                                    }
                                }
                            }label: {
                                HStack{
                                    Text(selectedPlace)
                                        .padding(.leading, 7)
                                    Spacer()
                                    Image(systemName: "arrowtriangle.down")
                                }
                            }
                            .frame(width: 270, height: 20)
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                            .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
                            .onAppear{
                                getPlaces(){ results in
                                    DispatchQueue.main.async{
                                        if let result = results{
                                            print(result)
                                            places.insert(contentsOf: result.map{$0.placeName}, at: 1)
                                        }else{
                                            print("キャンパスデータの取得に失敗")
                                            return
                                        }
                                    }
                                }
                            }
                    
                }
                HStack{
                    Text("講義名")
                    TextField("", text: $lectureName)
                        .frame(width: 270, height: 20)
                        .padding(5)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.leading, 5)
                        .font(.caption)
                        .focused($focus)
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                        .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
                }
                HStack{
                    Text("教員名")
                    TextField("", text: $teacherName)
                        .frame(width: 270, height: 20)
                        .padding(5)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.leading, 5)
                        .font(.caption)
                        .focused($focus)
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                        .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 40))
                }
                Button(action: {
                    searchLecture(faculty: selectedFaculty, year: year, springFlg: springFlg, autumnFlg: autumnFlg, day: daysText, period: Int(periodsText) ?? 0, lectureName: lectureName, teacherName: teacherName, place: selectedPlace){result in
                        guard let lectureResponseData = result else{
                            return
                        }
                        DispatchQueue.main.async{
                            lectureData = lectureResponseData
                            searchLectureResultFlg = true
                            addLectureFlg = false
                            onSearchLectureResultView()
                        }
                    }
                }, label: {
                    Text("検索")
                })
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 0.1))
                .background(Color(red: 0.95, green: 0.95, blue: 0.95), in: RoundedRectangle(cornerRadius: 10))
            }
            .onTapGesture {
                focus = false
            }
            .padding()
            Spacer()
        }
        
}

/*#Preview {
    addLectureView()
}*/
