//
//  Animations.swift
//  WeatherOK
//
//  Created by MAC on 13.05.2023.
//
/*
import SwiftUI
import Lottie

struct Animations: UIViewRepresentable {
    var name: String = "littieAnimation"
    let view = LottieAnimationView()
    
    func makeUIView(context: Context) -> some UIView {
        view.animation = LottieAnimation.named(name)
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.play()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: view.widthAnchor),
            view.heightAnchor.constraint(equalTo: view.heightAnchor),
            view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct Animations_Previews: PreviewProvider {
    static var previews: some View {
        Animations()
    }
}
*/
