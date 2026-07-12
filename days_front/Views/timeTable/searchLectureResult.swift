//
//  searchLectureResult.swift
//  days
//
//  Created by 長山瑞 on 2024/10/13.
//

import SwiftUI

struct searchLectureResult: View {
    @Binding var lectureData: [lectureResponse]
    @State var lectureDataTitle = ["学部", "講義名", "教員名", "開講期", "曜日", "時限", "場所", "教室"]
    @State var registerFlg = false
    @State var completionFlg = false
    @State var faculty: String = ""
    @State var year: String = ""
    @State var lectureName: String = ""
    @State var teacherName: String = ""
    @State var springFlg: Int = 0
    @State var autumnFlg: Int = 0
    @State var day: String = ""
    @State var period: Int = 10
    @State var roomNum: String = ""
    @State var place: String = ""
    @State var lectureId: Int = 0
    @Binding var userId: String
    @State var returnMessage: String = ""
    
    
    var body: some View {
        
        VStack{
            Grid(horizontalSpacing: 1, verticalSpacing: 1){
                GridRow{
                    ForEach(0 ..< lectureDataTitle.count, id: \.self){index in
                        if(index == 1){
                            Text(lectureDataTitle[index])
                                .font(.caption)
                                .frame(width: 90, height: 30)
                        }else if(index == 4 || index == 5){
                            Text(lectureDataTitle[index])
                                .font(.caption)
                                .frame(width: 30, height: 30)
                        }else{
                            Text(lectureDataTitle[index])
                                .font(.caption)
                                .frame(width: 50, height: 30)
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color(Color.black), lineWidth: 0.3))
                }
                ForEach(lectureData, id: \.id){data in
                    let season = data.springFlg == 1 ? "春" : "秋"
                                        
                    var dataArray = [data.faculty, data.lectureName, data.teacherName, season, data.day, String(data.period), data.place, data.roomNum]
                    GridRow{
                         ForEach(0 ..< dataArray.count, id: \.self){index in
                             if(index == 1){
                                 Button(action: {
                                     registerFlg = true
                                     faculty = data.faculty
                                     year = data.year
                                     lectureName = data.lectureName
                                     teacherName = data.teacherName
                                     springFlg = data.springFlg
                                     autumnFlg = data.autumnFlg
                                     day = data.day
                                     period = data.period
                                     place = data.place
                                     roomNum = data.roomNum
                                     lectureId = data.lectureId
                                 }) {
                                     Text(dataArray[index])
                                         .font(.system(size: 8))
                                         .frame(width: 90, height: 20)
                                         .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color(Color.black), lineWidth: 0.3))
                                 }
                             }else if(index == 2){
                                 Text(dataArray[index])
                                     .font(.system(size: 7))
                                     .frame(width: 50, height: 20)
                                     .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color(Color.black), lineWidth: 0.3))
                             }else if(index == 4 || index == 5){
                                 Text(dataArray[index])
                                     .font(.system(size: 10))
                                     .frame(width: 30, height: 20)
                                     .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color(Color.black), lineWidth: 0.3))
                             }else{
                                 Text(dataArray[index])
                                     .font(.system(size: 10))
                                     .frame(width: 50, height: 20)
                                     .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color(Color.black), lineWidth: 0.3))
                             }
                        }
                    }
                }
            }
            .alert("授業を登録しますか？", isPresented: $registerFlg){
                Button("登録"){
                    registerLecture(userId: userId, lectureId: lectureId){result  in
                        guard let resultMessage = result else{
                            print("授業登録失敗")
                            return
                        }
                        DispatchQueue.main.async{
                            returnMessage = resultMessage
                            completionFlg = true
                        }
                    }
                }
                Button("キャンセル", role: .cancel){}
            }
            .alert(returnMessage, isPresented: $completionFlg){
                Button("OK", role: .cancel){
                }
            }
        }
    }
}

struct searchLectureResult_Previews: PreviewProvider{
    @State static var sampleLectureData = [lectureResponse(faculty: "商学部", year: "2024", springFlg: 0, autumnFlg: 1, day: "木", period: 1, lectureName: "商品学B", teacherName: "上原 義子", roomNum: "1013", place: "駿河台", lectureId: 1)]
    @State static var userId = "a"
    static var previews: some View{
        searchLectureResult(lectureData: $sampleLectureData, userId: $userId)
    }
}
