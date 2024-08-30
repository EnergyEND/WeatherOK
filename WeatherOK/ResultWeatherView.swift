//
//  ResultWeatherView.swift
//  WeatherOK
//
//  Created by MAC on 17.03.2023.
//

import SwiftUI

//MARK: Currunt weather block
struct ResultWeatherView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var location: CurrentData?  //Fetched data
    @State var tempColor: Color = .white
    
    var body: some View {
        ZStack {
            //Background style:
            Rectangle().fill(.thinMaterial).cornerRadius(10)
            
            VStack {
                VStack {
                    
                    //Location name:
                    HStack {
                        Image(colorScheme == .dark ? "locationPointLight" : "locationPointDark").resizable()
                            .frame(width: 30, height: 40)
                        Text(location!.name).font(.system(size: 55))
                    }.offset(y: 10)
                    .onAppear{
                        tempColor = getTempTextColor()
                    }
                    
                    .onChange(of: location!.name) { _ in
                        tempColor = getTempTextColor()
                    }
                    
                    //Temprature block:
                    VStack {
                        HStack {
                            Text("\(String(format: "%01.0f", location!.main.temp))").foregroundColor(tempColor)
                            Text("°C")
                        }.font(.system(size: 50))
                            .padding(.bottom, 1)
                        HStack {
                            Text("min")
                            Text("\(String(format: "%01.1f", location!.main.temp_min))")
                            Image(systemName: "arrow.down")
                                .padding(.trailing, 10)
                            
                            Text("max")
                            Text("\(String(format: "%01.1f", location!.main.temp_max))")
                            Image(systemName: "arrow.up")
                        }.font(.system(size: 20))
                    }.padding(.top, 1)
    
                    
                    
                    //Weather info block:
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
                    
                    
                    //Wind info block:
                    HStack {
                        Text("wind")
                        Text("\(String(format: "%01.1f",location!.wind.speed))")
                        Text("speed")
                        Image(colorScheme == .dark ? "windLight" : "windDark").resizable()
                            .frame(width: 30, height: 40)
                    }.font(.system(size: 30))
                    
                }
            }
        }
    }
    
    func getTempTextColor() -> Color {
        switch Int(location!.main.temp) {
        case -20..<5: return Color("veryColdTemp")
        case 5..<15: return Color("coldTemp")
        case 15..<20: return Color("normalTemp")
        case 20..<30: return Color("hotTemp")
        default: return .red
        }
    }
    
}

//MARK: Hourly weather block
struct HourlyView: View {
    
    @Binding var hours: HourlyWeather?      //Fetched data
    var width: CGFloat      //GR width
    var height: CGFloat     //GR height
    var body: some View {
        ZStack {
            //Background style:
            Rectangle().fill(.thinMaterial).cornerRadius(10)
            
            //Horizontal scroll block:
            ScrollView(.horizontal) {
                if hours != nil {
                    HStack {
                        ForEach(hours!.list, id: \.dt) { hour in
                            
                            //Style for all fetched elements:
                            VStack {
                                
                                //Time
                                if hour == hours?.list.first {
                                    Text("now").font(.system(size: 13))
                                        .italic()
                                }else {
                                    Text("\(timeFormatter(dateString: hour.dt_txt))")
                                        .font(.system(size: 13))
                                        .italic()
                                }
                                
                                //Weather image
                                AsyncImage(url: URL(string: "https://openweathermap.org/img/w/\(hour.weather.first!.icon).png")) { image in
                                    image
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                }.padding(.top, -15)
                                
                                //Tempreture
                                Text("\(String(format: "%01.0f", hour.main.temp))°")
                                    .padding(.top, -15)
                                    .font(.system(size: 20))
                                    .bold()
                                
                            }
                        }
                    }
                }
            }.frame(maxWidth: width, maxHeight: height * 0.6)
                .scrollIndicators(.hidden)
        }.frame(width: width, height: height)
    }
}

//MARK: Custom date formatter:
func timeFormatter(dateString: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = formatter.date(from: dateString)
    formatter.dateFormat = "HH"
    return formatter.string(from: date!)
}
