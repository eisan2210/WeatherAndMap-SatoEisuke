//
//  DailyWeatherView.swift
//  WeatherAndMap
//
//  Created by satoeisuke on 2025/02/16.
//

import SwiftUI

struct DailyWeatherView: View {
    @ObservedObject var weatherVM: WeatherViewModel // APIレスポンスの値を保持するオブジェクト
    
    
    var body: some View {
        // MARK: - 1日分の天気予報のUI
        ScrollView(.horizontal) {
            // レスポンスに天気予報の情報があったとき
            if let forecastsDay = weatherVM.forecast?.forecastsDay {
                
                
                HStack {
                    ForEach(forecastsDay,id : \.self) { forecastDay in
                        VStack(spacing: 5) {
                            
                            Text(forecastDay.toDisplayDate(forecastDay.date)) //日付（年月日）
                                .font(.callout) // フォントをコールアウトのスタイルに
                            
                            //Text(forecastDay.day.condition.icon)
                            AsyncImageView(urlStr: "https:\(forecastDay.day.condition.icon)")
                                .padding()
                                .scaledToFit()
                            
                            Text(forecastDay.day.condition.text) //天気の説明(晴れ、曇り　等)
                                .font(.headline) // フォントを見出しのスタイルに
                            
                            // 最高気温 / 最低気温
                            HStack {
                                Text(forecastDay.day.maxTemp, format: .number)//数字が入る
                                    .foregroundStyle(.red)
                                Text("℃")//
                                    .foregroundStyle(.red)
                                Text("/")
                                Text(forecastDay.day.minTemp, format: .number)//数字が入る
                                    .foregroundStyle(.blue)
                                Text("℃ ")//
                                    .foregroundStyle(.blue)
                            }
                            
                            //降水確率
                            HStack {
                                Text("降水確率:")
                                Text(forecastDay.day.dailyChanceOfRain, format: .number)//数字が入る
                                Text("%")//数字が入る
                            }
                            .font(.subheadline)
                            
                        }
                        .padding()
                        .frame(width: ScreenInfo.width / 2, height: ScreenInfo.height / 3)
                        .background(.yellow.opacity(0.3)) //背景色、透過率を設定
                        .clipShape(.rect(cornerRadius: 10))
                    }
                }
            } else {
                // コピペした部分。データがない時（または起動直後）に表示
                HStack {
                    ForEach(0...2,id : \.self) { _ in
                        VStack(spacing: 5) {
                            
                            Text("____年__月__日__") //日付（年月日）
                            Image(systemName: "cloud.sun") //天気アイコン（サンプル）
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                            
                            Text("") //天気の説明(晴れ、曇り　等)
                            
                            // 最高気温 / 最低気温
                            HStack {
                                Text("最高")//数字が入る
                                Text("℃ /")//
                                
                                Text("最低")//数字が入る
                                Text("℃ ")//
                            }
                            
                            //降水確率
                            HStack {
                                Text("降水確率:")
                                Text("00")//数字が入る
                                Text("%")//数字が入る
                                
                            }
                            
                        }
                        .padding()
                        .frame(width: ScreenInfo.width / 2, height: ScreenInfo.height / 3)
                        .background(.yellow.opacity(0.3)) //背景色、透過率を設定
                        .clipShape(.rect(cornerRadius: 10))
                    }
                }
            }
        }
    }
    
}

#Preview {
    @Previewable @StateObject var weatherVM = WeatherViewModel()
    // 八幡平市大更の緯度・経度
    let lat: Double = 39.91167
    let lon: Double = 141.093459
    
    DailyWeatherView(weatherVM: weatherVM)
        .onAppear {
            weatherVM.request3DaysForecast(lat: lat, lon: lon)
        }
}
