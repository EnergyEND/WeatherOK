//
//  GetWeather.swift
//  WeatherOK
//
//  Created by MAC on 15.03.2023.
//

import Foundation

//MARK: Temprature model:
struct Temp: Codable {
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case feels_like
        case temp_min
        case temp_max
    }
}

//MARK: Weather info model:
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
}

//MARK: Wind info model:
struct Wind: Codable {
    let speed: Double
    
    private enum CodingKeys: String, CodingKey {
        case speed
    }
}

//MARK: Current weather data model:
struct CurrentData: Codable {
    let weather: [Weather]
    let main: Temp
    let wind: Wind
    let name: String
}

//MARK: Hourly weather data model:
struct HourlyData: Codable, Equatable {
    let dt: Int
    let weather: [Weather]
    let main: Temp
    let wind: Wind
    let dt_txt: String
    
    static func ==(lhs: HourlyData, rhs: HourlyData) -> Bool {
            return lhs.dt == rhs.dt 
        }

        static func !=(lhs: HourlyData, rhs: HourlyData) -> Bool {
            return !(lhs == rhs)
        }
}

//MARK: Hourly weather data list:
struct HourlyWeather: Codable{
    let list: [HourlyData]
}

//MARK: Current localization observer:
let currentLocale = Locale.current.language.languageCode?.identifier

//MARK: Current weather fetcher:
func getWeatherFromAPI(for city: String = "Kyiv", lat: Double = 34.500831, long: Double = -117.185876, isUkr: Bool, isCity: Bool, completion: @escaping (Result<CurrentData, Error>) -> Void) {
    
    let loc = isUkr ? "uk" : "en"
    
    let api = "039b8b1c421027d76a3214ab43c2560f"
    let cityUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&lang=\(loc)&appid=\(api)&units=metric")
    let coordUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&lang=\(loc)&appid=\(api)&units=metric")!
    
    guard let cityUrl = cityUrl else{return}
    
    URLSession.shared.dataTask(with: isCity ? cityUrl : coordUrl) { data, response, error in
        guard let data = data, error == nil else {
            print("Error: No data")
            return
        }
        
        do {
            let result = try JSONDecoder().decode(CurrentData.self, from: data)
            completion(.success(result))
            print(cityUrl)
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

//MARK: Hourly weather fetcher:
func getHourlyWeather(for city: String = "Kyiv",isUkr: Bool, completion: @escaping (Result<HourlyWeather, Error>) -> Void) {
    let api = "039b8b1c421027d76a3214ab43c2560f"
    let loc = isUkr ? "uk" : "en"
    let hourlyCity = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&lang=\(loc)&appid=\(api)&units=metric")!
    
    URLSession.shared.dataTask(with: hourlyCity) { data, response, error in
        guard let data = data, error == nil else {
            print("Error: No data")
            return
        }
        
        do {
            let result = try JSONDecoder().decode(HourlyWeather.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}
