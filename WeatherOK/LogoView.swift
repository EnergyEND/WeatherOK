//
//  LogoView.swift
//  WeatherOK
//
//  Created by MAC on 19.03.2023.
//

import SwiftUI

//MARK: App logo style view:
struct LogoView: View {
    var body: some View {
        
        VStack {
            Image(systemName: "cloud.fill")
                .font(.system(size: 140))
                .foregroundColor(.white)
                .shadow(radius: 1)
                
            HStack(spacing: 0) {
                Text("Weather").foregroundColor(.white)
                Text("OK").foregroundColor(Color("LogoText"))
            }.font(.system(size: 30))
                .shadow(radius: 1)
        }.padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
    
}
