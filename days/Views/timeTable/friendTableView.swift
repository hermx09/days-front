//
//  timeTableView.swift
//  days
//
//  Created by 長山瑞 on 2024/09/15.
//

import SwiftUI

struct friendTableView: View {
    var year = "2024"
    var semester = "春"
    let days = ["月", "火", "水", "木", "金", "土"]
    let periods = [1, 2, 3, 4, 5, 6]
    @State var grade = 4
    @State var resultName = ""
    @Binding var tabClick2: Bool
    @Binding var friendId: String
    
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
                getUserLectures(userId: friendId){results in
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
            
        }
        
    }
        func updateGrid() {
            for table in tables{
                let dayCnt = table.day
                let periodCnt = table.lectureTime - 1
                gridInit[dayCnt][periodCnt] = "\(table.lectureName)\n\(table.teacherName)\n\(table.roomNum)"
            }
        }
    
    struct friendTableView_Previews: PreviewProvider{
        @State static var tabClick2: Bool = true
        @State static var friendId: String = "friend"
        
        static var previews: some View{
            friendTableView(tabClick2: $tabClick2, friendId: $friendId)
        }
    }
}
