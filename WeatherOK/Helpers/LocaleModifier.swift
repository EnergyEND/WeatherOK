//
//  LocaleModifier.swift
//  WeatherOK
//
//  Created by MAC on 23.03.2023.
//

import SwiftUI


struct LocalizedViewModifier: ViewModifier {
    var locale: Locale
    
    func body(content: Content) -> some View {
        content.environment(\.locale, locale)
    }
}
