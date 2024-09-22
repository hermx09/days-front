//
//  ContentView.swift
//  days
//
//  Created by 長山瑞 on 2024/08/21.
//

import SwiftUI

struct ContentView: View {
    @State var tabClick1:Bool = true
    @State var tabClick2:Bool = false
    @State var tabClick3:Bool = false
    @State var tabClick4:Bool = false
    @State var tabClick5:Bool = false
    var body: some View {
        
        NavigationStack{
            if tabClick1{
                homeView()
            }else if tabClick2{
                timeTableView()
            }else if tabClick3{
                boardView()
            }
        }
        .toolbar{
            ToolbarItemGroup(placement: .bottomBar){
                Button(action: {
                    tabClick1 = true
                    tabClick2 = false
                    tabClick3 = false
                    tabClick4 = false
                    tabClick5 = false
                }, label: {
                    if(tabClick1){
                        VStack{
                            Image(systemName: "star.fill")
                            Text("ホーム")
                                .font(.caption)
                        }
                        .foregroundColor(.blue)
                    }else{
                        VStack{
                            Image(systemName: "star.fill")
                            Text("ホーム")
                                .font(.caption)
                        }
                    }
                })
                .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    tabClick1 = false
                    tabClick2 = true
                    tabClick3 = false
                    tabClick4 = false
                    tabClick5 = false
                }, label: {
                    if(tabClick2){
                        VStack{
                            Image(systemName: "star.fill")
                            Text("時間割")
                                .font(.caption)
                        }
                        .foregroundColor(.blue)
                    }else{
                        VStack{
                            Image(systemName: "star.fill")
                            Text("時間割")
                                .font(.caption)
                        }
                    }
                })
                .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    tabClick1 = false
                    tabClick2 = false
                    tabClick3 = true
                    tabClick4 = false
                    tabClick5 = false
                }, label: {
                    if(tabClick3){
                        VStack{
                            Image(systemName: "star.fill")
                            Text("掲示板")
                                .font(.caption)
                        }
                        .foregroundColor(.blue)
                    }else{
                        VStack{
                            Image(systemName: "star.fill")
                            Text("掲示板")
                                .font(.caption)
                        }
                    }
                })
                .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    tabClick1 = false
                    tabClick2 = false
                    tabClick3 = false
                    tabClick4 = true
                    tabClick5 = false
                }, label: {
                    if(tabClick4){
                        VStack{
                            Image(systemName: "star.fill")
                            Text("チャット")
                                .font(.caption)
                        }
                        .foregroundColor(.blue)
                    }else{
                        VStack{
                            Image(systemName: "star.fill")
                            Text("チャット")
                                .font(.caption)
                        }
                    }
                })
                .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    tabClick1 = false
                    tabClick2 = false
                    tabClick3 = false
                    tabClick4 = false
                    tabClick5 = true
                }, label: {
                    if(tabClick5){
                        VStack{
                            Image(systemName: "star.fill")
                            Text("TabName")
                                .font(.caption)
                        }
                        .foregroundColor(.blue)
                    }else{
                        VStack{
                            Image(systemName: "star.fill")
                            Text("TabName")
                                .font(.caption)
                        }
                    }
                })
                .foregroundColor(.gray)
            }
        }
    }
}

struct DisplayBox: View{
    var title: String
    var date: String
    var text: String
    
    var body: some View{
        Button(action: {},
               label: {
            VStack{
                Text(title)
                    .fontWeight(.bold)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(date)
                    .font(.caption)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    Text(text)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "greaterthan")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.gray)
                        .padding(.trailing, 50)
                }
            }
        })
        .padding()
        .foregroundColor(.black)
    }
}


#Preview {
    ContentView()
}
