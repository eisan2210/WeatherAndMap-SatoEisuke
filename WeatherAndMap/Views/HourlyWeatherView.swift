//
//  HourlyWeatherView.swift
//  WeatherAndMap
//
//  Created by satoeisuke on 2025/02/16.
//

import SwiftUI

struct HourlyWeatherView: View {
    let defaultDateStr = "____年__月__日" //日付が取得できてない時に表示
    @ObservedObject var weatherVM: WeatherViewModel //APIレスポンスの値を保持するオブジェクト
    
    
    
    var body: some View {
        if let forecastDay = weatherVM.forecast?.forecastsDay {
            ForEach(forecastDay, id: \.self) { forecastDay in
                //compactMapを使って[HourlyForecast]→[HourlyDisplayForecas]に変換
                let hourlyDisplayForecasts = forecastDay.hour //HourlyForecast配列
                    .compactMap{ hourlyDisplayForecast in
                        hourlyDisplayForecast.toDisplayFormat(hourlyForecast: hourlyDisplayForecast)
                    }
                
                //時間ごとの天気（1日分）
                VStack {
                    Divider() //区切り線
                    
                    Text(hourlyDisplayForecasts.first?.date ?? defaultDateStr)
                        .padding(.vertical, 5) //垂直方向に余白を５とる
                    
                    // 時間毎の天気予報
                    HStack(spacing: 5) {
                        HourlyWeatherHeader() //ヘッダー(見出し)
                        
                        // 0~23時までの時間毎の予報
                        ScrollView(.horizontal) {
                            HStack(spacing: 5) {
                                ForEach(hourlyDisplayForecasts) { hourlyDisplayForecast in
                                    // MARK: 1時間分の表示
                                    VStack(spacing: 10) {
                                        // 時刻
                                        Text(hourlyDisplayForecast.time)
                                            .font(.subheadline)
                                        
                                        
                                        // 天気アイコン
                                        AsyncImageView(urlStr: "https:\(hourlyDisplayForecast.weatherIcon)")
                                            .frame(maxWidth:64, maxHeight: 64)
                                            .scaledToFit()
                                        
                                        // 気温
                                        Text(hourlyDisplayForecast.temperature, format: .number)
                                            .font(.subheadline)
                                        
                                        // 降水確率
                                        Text(hourlyDisplayForecast.chanceOfRain, format: .number)
                                            .font(.subheadline)
                                    }
                                    .frame(width: ScreenInfo.width / 9)
                                }
                            }
                            .padding()
                            .frame(height: 180)
                            .background(.gray.opacity(0.2))// 背景色グレー
                            .clipShape(.rect(cornerRadius: 10))// 角丸に切り取る
                            
                        }
                    }
                }
            }
        }
    }
}



// MARK: - 時間毎の予報のヘッダー
struct HourlyWeatherHeader: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("時刻(時)")
                .font(.caption)
            
            
            Text("天気")
                .font(.caption)
                .frame(maxHeight: 40)
            
            
            Text("気温(℃)")
                .font(.caption)
            
            
            Text("降水確率(%)")
                .font(.caption2)
        }
        .frame(width: 65, height: 180)
        .background(Color.blue.opacity(0.1))
        .clipShape(.rect(cornerRadius: 10))
    }
}




#Preview {
    @Previewable @StateObject var weatherVM = WeatherViewModel()
    // 八幡平市大更の緯度・経度
    let lat: Double = 39.91167
    let lon: Double = 141.093459
    
    HourlyWeatherView(weatherVM: weatherVM)
        .onAppear {
            weatherVM.request3DaysForecast(lat: lat, lon: lon)
        }
}

#Preview("ContentView") {
    ContentView()
}
