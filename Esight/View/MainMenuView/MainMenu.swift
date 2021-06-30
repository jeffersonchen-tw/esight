//
//  MainMenu.swift
//  eyes
//
//  Created by 陳奕利 on 2021/6/23.
//

import SwiftUI

struct MainMenu: View {
    @Binding var selected: Int
    var body: some View {
        VStack {
            Image("eye")
                .resizable()
                .scaledToFit()
                .frame(height: 320)
                .padding(.top)
            Text("E-sight").font(.custom("Times New Roman",size: 65)).fontWeight(.heavy).kerning(1.8)
            Text("relax, replenise, and rejuvenate").font(.custom("Didot Italic", size: 30)).kerning(0.9)
            Spacer()
            Button(action: {
                NSApp.terminate(self)
            }){
                Text("Disable ME ⚠️").font(.custom("Helvetica", size: 30))
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.bottom)
        }
    }
}

