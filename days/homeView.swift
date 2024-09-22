//
//  homeView.swift
//  days
//
//  Created by 長山瑞 on 2024/09/15.
//

import SwiftUI

struct homeView: View {
    var body: some View {
        @State var boardList =
        [
            addBoards(title: "自由掲示板", contents: "内容"),
            addBoards(title: "新卒掲示板", contents: "内容"),
            addBoards(title: "新卒掲示板", contents: "内容"),
            addBoards(title:"サークル掲示板",contents: "内容"),
            addBoards(title:"恋愛掲示板",contents: "内容"),
            addBoards(title:"物販掲示板",contents: "内容")
        ]
        @State var favoriteBoardList =
        [
        addFavoriteBoards(userName: "匿名", title: "題名", content: "内容", boardName: "自由掲示板", heartCnt: 30, bubbleCnt: 10),
         addFavoriteBoards(userName: "匿名", title: "題名", content: "内容", boardName: "自由掲示板", heartCnt: 30, bubbleCnt: 10)
        ]
        @State var lectureList =
        [
        addLectures(star: 5, lectureName: "政治体制論", teacherName: "外池 力", middle: false, last: true, bring: true, text: "内容", time: "2023/09/14"),
         addLectures(star: 4, lectureName: "政治体制論", teacherName: "内池 力", middle: true, last: false, bring: false, text: "内容", time: "2024/10/14"),
         addLectures(star: 3, lectureName: "政治体制論", teacherName: "内池 力", middle: true, last: false, bring: false, text: "内容", time: "2024/10/14")
        ]
        @State var circleList =
        [
        addCircle(circleName: "サークル名前", circleContents: "サークル説明"),
        addCircle(circleName: "サークル名前", circleContents: "サークル説明"),
        addCircle(circleName: "サークル名前", circleContents: "サークル説明")
        ]
        
        ScrollView(.vertical){
            VStack(alignment: .leading){
                
                HStack(){
                    Image(systemName: "star.circle.fill")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .padding(13)
                    Spacer()
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.top, 30)
                            .padding(.trailing, 15)
                    })
                    .foregroundColor(.black)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        ZStack{
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.top, 30)
                                .padding(.trailing, 15)
                            Image(systemName: "number.circle.fill")
                                .padding(.top, 10)
                                .foregroundColor(.red)
                        }
                    })
                    .foregroundColor(.black)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.top, 30)
                            .padding(.trailing, 21)
                            .foregroundColor(.purple)
                    })
                }
                Text("明治大学")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 10)
                    .padding(.bottom, 12)
                ScrollView(.horizontal){
                    HStack{
                        DisplayBox(title: "履修登録(政治経済学部)", date : "○月○日 12 : 00 ~", text: "他の日程確認")
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.95, green: 0.63, blue: 0.94, opacity: 0.3), lineWidth: 2))
                            .background(Color(red: 0.95, green: 0.63, blue: 0.94, opacity: 0.3), in: RoundedRectangle(cornerRadius: 10))
                            .padding(.trailing)
                        DisplayBox(title: "今日のTo Do List", date: "○月○日 12 : 00 ~", text: "追加する")
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2))
                    }
                }
                HStack{
                    Button(action: {}, label: {
                        VStack{
                            Image(systemName: "globe")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                .padding(.bottom, 5)
                            Text("学校サイト")
                                .font(.caption2)
                        }
                        .padding(.leading, 8)
                        .padding(.top, 35)
                    })
                    .foregroundColor(.black)
                    
                    Button(action: {},
                           label: {
                        VStack{
                            Image(systemName: "paperplane")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                            Text("学校内通知")
                                .font(.caption2)
                        }
                        .padding(.leading, 8)
                        .padding(.top, 35)
                    })
                    .foregroundColor(.black)
                    
                    Button(action: {},
                           label:{
                        VStack{
                            Image(systemName: "chart.pie")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.purple)
                                .padding(.bottom, 5)
                            Text("学年歴")
                                .font(.caption2)
                        }
                        .padding(.leading, 20)
                        .padding(.top, 35)
                    })
                    .foregroundColor(.black)
                    
                    Button(action: {},
                           label: {
                        VStack{
                            Image(systemName: "checkmark.square")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.brown)
                                .padding(.bottom, 5)
                            Text("履修登録")
                                .font(.caption2)
                        }
                        .padding(.leading, 27)
                        .padding(.top, 35)
                    })
                    .foregroundColor(.black)
                    
                    Button(action: {},
                           label: {
                        VStack{
                            Image(systemName: "display")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.green)
                                .padding(.bottom, 5)
                            Text("連絡網")
                                .font(.caption2)
                        }
                        .padding(.leading, 25)
                        .padding(.top, 35)
                    })
                    .foregroundColor(.black)
                    Spacer()
                }
                .padding(.bottom, 28)
                Button(action: {
                    
                }, label: {
                    HStack{
                        Image(systemName: "heart")
                            .padding(.leading, 3)
                            .foregroundColor(.black)
                        Text("お気に入り掲示板")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "greaterthan")
                            .foregroundColor(.gray)
                    }
                })
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    VStack{
                        VStack{
                            ForEach(boardList){board in
                                boardDisplay(title: board.title, content: board.contents)
                            }
                        }
                        .padding(.leading, 13)
                        .padding(.top, 10)
                        .padding(.bottom, 15)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 2))
                        .background(Color(red: 0.9, green: 0.9, blue: 0.9), in :
                                        RoundedRectangle(cornerRadius: 10))
                    }
                })
                .foregroundColor(.black)
                
                Button(action: {},
                       label: {
                    HStack{
                        Image(systemName: "music.note")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.black)
                        Text("人気投稿")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "greaterthan")
                            .foregroundColor(.gray)
                    }
                })
                .padding(5)
                
                ForEach(favoriteBoardList){favorite in
                    favoriteBoard(
                        userName: favorite.userName,
                        title: favorite.title,
                        content: favorite.content,
                        boardName: favorite.boardName,
                        heartCnt: favorite.heartCnt,
                        bubbleCnt: favorite.bubbleCnt
                    )
                }
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    HStack{
                        Image(systemName: "star")
                        Text("講義評価")
                            .font(.body)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "greaterthan")
                            .foregroundColor(.gray)
                    }
                    .foregroundColor(.black)
                })
                ScrollView(.horizontal){
                    HStack{
                        ForEach(lectureList){lecture in
                            lectureReview(star: lecture.star, lectureName: lecture.lectureName, teacherName: lecture.teacherName, middle: lecture.middle, last: lecture.last, bring: lecture.bring, text: lecture.text, time: lecture.time)
                        }
                    }
                }
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    HStack{
                        Image(systemName: "person.3")
                        Text("サークル情報")
                            .font(.body)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "greaterthan")
                            .foregroundColor(.gray)
                    }
                    .foregroundColor(.black)
                })
                ScrollView(.horizontal){
                    HStack{
                        ForEach(circleList){circle in
                            circleInfo(circleName: circle.circleName, circleContents: circle.circleContents)
                        }
                    }
                }
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    HStack{
                        Image(systemName: "star.fill")
                        Text("就活情報")
                            .font(.body)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "greaterthan")
                            .foregroundColor(.gray)
                    }
                    .foregroundColor(.black)
                })
                Text("Comming Soon...")
                VStack{
                    HStack{
                        Spacer()
                        Image(systemName: "star.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Spacer()
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 6)
                    HStack{
                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("ホーム画面設定")
                                .font(.caption)
                                .foregroundColor(.black)
                        })
                        .padding(7)
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color(.black), lineWidth: 1))
                        Spacer()
                    }
                }
            }
            .padding(20)
        }
    }
}

struct boardDisplay: View{
    var title: String
    var content: String
    
    var body: some View{
        
            HStack{
                Text(title)
                Text(content)
                Spacer()
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(5)
        
    }
}

struct favoriteBoard: View{
    var userName : String
    var title: String
    var content: String
    var boardName: String
    var heartCnt: Int
    var bubbleCnt: Int
    
    var body: some View{
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            HStack{
                VStack{
                    HStack{
                        Image(systemName: "person.circle")
                        Text(userName)
                            .font(.caption)
                        Spacer()
                    }
                    .padding(.leading,5)
                    HStack{
                        Text(title)
                            .font(.caption)
                        Spacer()
                    }
                    .padding(.leading,15)
                    HStack{
                        Text(content)
                            .font(.caption2)
                            .fontWeight(.light)
                            .padding(.bottom, 10)
                        Spacer()
                    }
                    .padding(.leading,15)
                    HStack{
                        Text(boardName)
                            .font(.caption2)
                            .fontWeight(.light)
                        Spacer()
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 8, height: 8)
                            .foregroundColor(.red)
                        Text("\(heartCnt)")
                            .font(.caption)
                            .foregroundColor(.red)
                        Image(systemName: "bubble")
                            .resizable()
                            .frame(width: 8, height: 8)
                        Text("\(bubbleCnt)")
                            .font(.caption)
                    }
                }
                Spacer()
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 2))
            .background(Color(red: 0.9, green: 0.9, blue: 0.9), in :
                            RoundedRectangle(cornerRadius: 10))
        })
        .foregroundColor(.black)
    }
    
}

struct lectureReview: View{
    
    var star: Int
    var lectureName: String
    var teacherName: String
    var middle: Bool
    var last: Bool
    var bring: Bool
    var text: String
    var time: String
    
    var body: some View{
        Button(action: {}, label: {
            
            
            VStack{
                HStack{
                    if star > 0{
                        ForEach(0 ..< star, id: \.self){num in
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.yellow)
                        }
                    }
                    if star != 5{
                        ForEach(0 ..< 5 - star, id: \.self){num in
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.gray)
                        }
                    }
                }
                Text(lectureName)
                    .font(.callout)
                Text(teacherName)
                HStack{
                    if middle{
                        Text("中間テスト : あり")
                    }else{
                        Text("中間テスト : なし")
                    }
                    Spacer()
                }
                HStack{
                    if last{
                        Text("期末テスト : あり")
                    }else{
                        Text("期末テスト : なし")
                    }
                    Spacer()
                }
                HStack{
                    if bring{
                        Text("持ち込み : 可")
                    }else{
                        Text("持ち込み : 不可")
                    }
                    Spacer()
                }
                .padding(.bottom,5)
                HStack{
                    Text(text)
                    Spacer()
                }
                Spacer()
                Text("授業を受けた日 : " + "\(time)")
                    .font(.caption2)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
        })
        .font(.caption)
        .fontWeight(.medium)
        .foregroundColor(.black)
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 2))
        .background(Color(red: 0.9, green: 0.9, blue: 0.9), in :
                        RoundedRectangle(cornerRadius: 10))
    }
}

struct circleInfo: View{
    
    var circleName: String
    var circleContents: String
    
    var body: some View{
        Button(action: {}, label: {
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 150, height: 220)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                    .cornerRadius(20);
                VStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 150, height: 120)
                        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                        .cornerRadius(20);
                    HStack{
                        Text(circleName)
                            .font(.caption)
                            .padding(.leading)
                        Spacer()
                    }
                    HStack{
                        Text(circleContents)
                            .font(.caption2)
                            .padding(.leading)
                        Spacer()
                    }
                    Spacer()
                }
                .foregroundColor(.black)
            }
            .padding(2)
        })
    }
}



struct addLectures: Identifiable{
    var star : Int
    var lectureName: String
    var teacherName: String
    var middle: Bool
    var last: Bool
    var bring: Bool
    var text: String
    var time: String
    var id = UUID()
}

struct addBoards: Identifiable{
    var title: String
    var contents: String
    var id = UUID()
}

struct addFavoriteBoards: Identifiable{
    var userName: String
    var title: String
    var content: String
    var boardName : String
    var heartCnt: Int
    var bubbleCnt: Int
    var id = UUID()
}

struct addCircle: Identifiable{
    var circleName: String
    var circleContents: String
    var id = UUID()
}


#Preview {
    homeView()
}
