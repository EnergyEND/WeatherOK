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
    
    @Environment(\.colorScheme) var colorScheme     //UI theme observer
    @AppStorage("selectedLocale") var selectedLocale = false  //Saved localization in UD
        

    let locationFetcher = LocationFetcher()     //Location engine
    @State private var engine: CHHapticEngine?  //Vibro engine
    @State private var userLocation = LocationFetcher().lastKnownLocation   //User location coord's
    @State private var inputCity = String()     //City for fetching data
    @State private var isCity = false           //Fetching toggle
    @State private var height : CGFloat = 130   //Bottom rectangle animation
    @State private var result: CurrentData?    //Current weather data
    @State private var hourly: HourlyWeather?    //Hourly weather data
    @ObservedObject private var observer = KeyboardObserver()   //Keyboard status observer

    var body: some View {
        NavigationStack {
            GeometryReader { reader in
                ZStack {
                    
                    //MARK: Background style:
                    if colorScheme == .light {
                        Rectangle().fill(Color.blue.gradient).ignoresSafeArea()
                        //LottieView(animationName: "lottieAnimation")
                    }else {
                        Rectangle().fill(Color("DarkBack").gradient).ignoresSafeArea()
                    }
                    
                    
                    //MARK: Location buttons block:
                    //Background:
                    Rectangle().fill(.ultraThickMaterial).cornerRadius(25)
                        .offset(y: reader.size.height * 0.47)
                        .frame(height: height)
                    
                    VStack {
                        HStack {
                            //User location button:
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
                                    Rectangle().frame(width: reader.size.width * 0.45, height: 50).cornerRadius(15).foregroundColor(Color("ButtonBack"))
                                    HStack {
                                        Image(systemName: "location.fill")
                                            .foregroundColor(Color("ButtonText"))
                                            .font(.system(size: 20))
                                        Text("myLoc")
                                            .foregroundColor(Color("ButtonText"))
                                            .font(.system(size: 23))
                                    }
                                }
                            }.disabled(observer.textFieldIsPressed)
                            
                            //City button:
                            Button {
                                withAnimation {
                                    if isCity {
                                        height = reader.size.height * 0.165 //130
                                        isCity = false
                                    }else {
                                        height = reader.size.height * 0.3 //200
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            isCity = true
                                        }
                                    }
                                }

                            } label: {
                                ZStack {
                                    Rectangle().frame(width: reader.size.width * 0.45, height: 50).cornerRadius(15).foregroundColor(Color("ButtonBack"))
                                    HStack {
                                        Text("forCity")
                                            .foregroundColor(Color("ButtonText"))
                                            .font(.system(size: 23))
                                        Image(systemName: "location.magnifyingglass")
                                            .foregroundColor(Color("ButtonText"))
                                            .font(.system(size: 20))
                                    }.offset(x: 10)
                                }
                            }.disabled(observer.textFieldIsPressed)
                        }
                     }.offset(y: reader.size.height * 0.44)
                    
                    
                    
                    //MARK: Center info block:
                    VStack {
                        if result != nil {
                            
                            //MARK: Fetched data block:
                            withAnimation {
                                ZStack {
                                    LogoView().scaleEffect(0.4).offset(x: -reader.size.width * 0.345 ,y: -reader.size.height * 0.44) // -135  -330
                                    VStack{
                                        ResultWeatherView(location: $result)
                                            .frame(width: reader.size.width * 0.9, height: reader.size.height * 0.5)
                                        
                                        HourlyView(hours: $hourly, width: reader.size.width * 0.9, height: reader.size.height * 0.15)
                                            .opacity(observer.textOpacity)
                                            .padding(.top, 5)
                                    }.offset(y: -reader.size.height * 0.03)
                                        
                                }
                            }
                        } else {
                            LogoView().shadow(radius: 45)
                        }
                    }
                    
                    
                    //MARK: Data input block:
                    if isCity {
                        //City name textfield
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
                            .frame(maxWidth: reader.size.width * 0.92)
                            .offset(y: reader.size.height * (observer.textOffset * 0.0013))
                            .shadow(radius: observer.textShadow)
                            .onTapGesture {
                                inputCity = ""
                            }
                        
                    }else if result == nil {
                        
                        //Placeholder
                        Text("waitLocation")
                            .offset(y: reader.size.height * 0.335)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    
                    //MARK: Localization toggle:
                    HStack {
                        Text("🇬🇧")
                        Toggle("",isOn: $selectedLocale).toggleStyle(SwitchToggleStyle(tint: .yellow)).labelsHidden()
                        Text("🇺🇦")
                    }.frame(width: 120, height: 40 )
                        .background(.thinMaterial)
                        .cornerRadius(25)
                        .offset(x: reader.size.width * 0.31, y: -reader.size.height * 0.465)
                    
                }
            }
            
        }.modifier(LocalizedViewModifier(locale: selectedLocale ? Locale(identifier: "uk_UA") : Locale(identifier: "en_US")))
        .onAppear{
            locationFetcher.start()
            prepareHaptics()
        }
    }
    
    
    
    
    //MARK: Vibro config:
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
