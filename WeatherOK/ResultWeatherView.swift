//
//  ResultWeatherView.swift
//  WeatherOK
//
//  Created by MAC on 17.03.2023.
//

import SwiftUI

struct ResultWeatherView: View {
    
    @Binding var location: ResultData?
    
    var body: some View {
        ZStack {
            Rectangle().fill(.thinMaterial).frame(maxWidth: 360, maxHeight: 400).cornerRadius(10)
            VStack {
                
                VStack {
                    Text(location!.name).font(.system(size: 55))
                    VStack {
                        Text("\(String(format: "%01.1f", location!.main.temp)) °C").font(.system(size: 35))
                        HStack {
                            Text("min")
                            Text("\(String(format: "%01.1f", location!.main.temp_min))")
                                .padding(.trailing, 10)
                            Text("max")
                            Text("\(String(format: "%01.1f", location!.main.temp_max))")
                        }.font(.system(size: 20))
                    }.padding(.top, 1)
                    
                    HStack {
                        Text("\(location!.weather.first!.description.capitalized)")
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/w/\(location!.weather.first!.icon).png")) { image in
                            image
                                .resizable()
                                .frame(width: 50, height: 50)
                        } placeholder: {
                            ProgressView()
                        }
                    }.font(.system(size: 35))
                        .padding(.top, 10)
                    HStack {
                        Text("wind")
                        Text("\(String(format: "%01.1f",location!.wind.speed))")
                        Text("speed")
                    }.font(.system(size: 30))
                    
                }
            }
        }
    }
}

struct HourlyView: View {
    
    @Binding var hours: HourlyWeather?
    
    var body: some View {
        ZStack {
            Rectangle().fill(.thinMaterial).cornerRadius(10)
            ScrollView(.horizontal) {
                if hours != nil {
                    HStack {
                        ForEach(hours!.list, id: \.dt) { hour in
                            VStack {
                                
                                if hour == hours?.list.first {
                                    Text("now").font(.system(size: 13))
                                        .italic()
                                }else {
                                    Text("\(timeFormatter(dateString: hour.dt_txt))")
                                        .font(.system(size: 13))
                                        .italic()
                                }
                                
                                AsyncImage(url: URL(string: "https://openweathermap.org/img/w/\(hour.weather.first!.icon).png")) { image in
                                    image
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                }.padding(.top, -15)
                                
                                Text("\(String(format: "%01.0f", hour.main.temp))°")
                                    .padding(.top, -15)
                                    .font(.system(size: 20))
                                    .bold()
                                
                            }
                        }
                    }
                }
            }.frame(maxWidth: 360, maxHeight: 60)
                .scrollIndicators(.hidden)
        }.frame(width: 360, height: 100)
    }
}

func timeFormatter(dateString: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = formatter.date(from: dateString)
    formatter.dateFormat = "HH"
    return formatter.string(from: date!)
}
