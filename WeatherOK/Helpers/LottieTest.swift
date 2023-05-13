//
//  LottieTest.swift
//  WeatherOK
//
//  Created by MAC on 13.05.2023.
//

import SwiftUI
import Lottie

struct LottieTest: UIViewRepresentable {
    
    var name = "lottieAnimation"
    let view = LottieAnimationView()
    
    func makeUIView(context: Context) -> LottieAnimationView {
        view.animation = LottieAnimation.named(name)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct LottieTest_Previews: PreviewProvider {
    static var previews: some View {
        LottieTest()
    }
}

/*
 import SwiftUI
 import Lottie


 struct LottieView: UIViewRepresentable {
     
     var name = "lottieAnimation"
     //var loopMode: LottieLoopMode = .loop
     

     func makeUIView(context: Context) -> LottieAnimationView {
         let view = LottieAnimationView(name: name, bundle: Bundle.main)
         view.loopMode = .loop
         view.play()
         
         return view
         
     }
     
     func updateUIView(_ uiView: UIViewType, context: Context) {}
 }

 struct LottieView_Previews: PreviewProvider {
     static var previews: some View {
         LottieView()
     }
 }
*/
