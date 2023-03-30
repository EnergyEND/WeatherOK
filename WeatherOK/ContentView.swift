//
//  ContentView.swift
//  WeatherOK
//
//  Created by MAC on 15.03.2023.
//

// 039b8b1c421027d76a3214ab43c2560f

import SwiftUI
import CoreHaptics

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("selectedLocale") var selectedLocale = false
        

    let locationFetcher = LocationFetcher()
    @State private var engine: CHHapticEngine?
    @State private var userLocation = LocationFetcher().lastKnownLocation
    @State private var inputCity = String()
    @State private var isCity = false
    @State private var height : CGFloat = 130
    @State private var result: ResultData?
    @State private var hourly: HourlyWeather?
    @ObservedObject private var observer = KeyboardObserver()

    var body: some View {
        NavigationStack {
            ZStack {
                
                if colorScheme == .light {
                    Rectangle().fill(Color.blue.gradient).ignoresSafeArea()
                }else {
                    Rectangle().fill(Color("DarkBack").gradient).ignoresSafeArea()
                }
                
                Rectangle().fill(.ultraThickMaterial).cornerRadius(25).offset(y: 350)
                    .frame(height: height)
                
                
                VStack {
                    
                    HStack {
                        Button{
                            
                            if let location = locationFetcher.lastKnownLocation {
                                print("User location is \(location)")
                                userLocation = location
                            }
                            
                            guard let userLocation = userLocation else{
                                print("Location is nil")
                                return
                            }
                            
                            getWeatherFromAPI(lat: userLocation.latitude, long: userLocation.longitude,isUkr: selectedLocale, isCity: false) { result in
                                switch result {
                                case .success(let result):
                                    self.result = result
                                case .failure(let error):
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                            getHourlyWeather(for: result?.name ?? "Kyiv",isUkr: selectedLocale) { result in
                                switch result {
                                case .success(let result):
                                    self.hourly = result
                                case .failure(let error):
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                            simpleSuccess()
                        } label: {
                            ZStack {
                                Rectangle().frame(width: 170, height: 50).cornerRadius(15).foregroundColor(Color("ButtonBack"))
                                HStack {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(Color("ButtonText"))
                                        .font(.system(size: 20))
                                    Text("myLoc")
                                        .foregroundColor(Color("ButtonText"))
                                        .font(.system(size: 23))
                                }
                            }
                        }
                        
                        Button {
                            withAnimation {
                                if isCity {
                                    height = 130
                                    isCity = false
                                }else {
                                    height = 200
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        isCity = true
                                    }
                                }
                            }

                        } label: {
                            ZStack {
                                Rectangle().frame(width: 170, height: 50).cornerRadius(15).foregroundColor(Color("ButtonBack"))
                                HStack {
                                    Text("forCity")
                                        .foregroundColor(Color("ButtonText"))
                                        .font(.system(size: 23))
                                    Image(systemName: "location.magnifyingglass")
                                        .foregroundColor(Color("ButtonText"))
                                        .font(.system(size: 20))
                                }.offset(x: 10)
                            }
                        }
                    }.padding(.top, 3)
                }.offset(y: 330)
                
                VStack {
                    if result != nil {
                        withAnimation {
                            ZStack {
                                LogoView().scaleEffect(0.4).offset(x: -135,y: -330)
                                ResultWeatherView(location: $result)
                                    .offset(y: -80)
                                HourlyView(hours: $hourly).offset(y: 185).opacity(observer.textOpacity)
                            }
                        }
                    } else {
                        LogoView().shadow(radius: 45)
                    }
                }
                
                if isCity {
                    TextField("cityName", text: $inputCity, onCommit: {
                        getWeatherFromAPI(for: inputCity.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Kyiv",isUkr: selectedLocale, isCity: true) { result in
                            switch result {
                            case .success(let result):
                                self.result = result
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                        getHourlyWeather(for: inputCity.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Kyiv",isUkr: selectedLocale) { result in
                            switch result {
                            case .success(let result):
                                self.hourly = result
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                        simpleSuccess()
                        
                    })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
                        .offset(y: observer.textOffset)
                        .shadow(radius: observer.textShadow)
                        .onTapGesture {
                            inputCity = ""
                        }
                    
                }else if result == nil {
                    
                    Text("waitLocation")
                        .offset(y: 250)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                
                HStack {
                    Text("🇬🇧")
                    Toggle("",isOn: $selectedLocale).toggleStyle(SwitchToggleStyle(tint: .yellow)).labelsHidden()
                    Text("🇺🇦")
                }.frame(width: 120, height: 40 )
                    .background(.thinMaterial)
                    .cornerRadius(25)
                    .offset(x: 120, y: -330)
                
            }.modifier(LocalizedViewModifier(locale: selectedLocale ? Locale(identifier: "uk_UA") : Locale(identifier: "en_US")))
            
            
        }.onAppear{
            locationFetcher.start()
            prepareHaptics()
        }
    }
    
    
    
    
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
