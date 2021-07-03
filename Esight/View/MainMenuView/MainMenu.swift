//
//  MainMenu.swift
//  eyes
//
//  Created by 陳奕利 on 2021/6/23.
//

import SwiftUI

struct MainMenu: View {
    @Binding var selected: Int
    @State var showAlert: Bool = false

    var body: some View {
        VStack {
            Image("eye")
                .resizable()
                .scaledToFit()
                .frame(height: 320)
                .padding(.top)
            Text("E-sight").font(.custom("Times New Roman", size: 65)).fontWeight(.heavy).kerning(1.8)
            Text("relax, replenise, and rejuvenate").font(.custom("Didot Italic", size: 30)).kerning(0.9)
            Spacer()
            Button(action: {
                self.showAlert = true
            }, label: {
                Text("Disable ME ⚠️").font(.custom("Helvetica", size: 30))
            }
            )
            .buttonStyle(BorderlessButtonStyle())
            .padding(.bottom)
            .alert(isPresented: self.$showAlert) {
                Alert(title: Text("Are you sure to disable E-sight"), primaryButton: .default(Text("Enable E-sight")),
                      secondaryButton: .default(Text("Sure"), action: {
                          NSApp.terminate(self)
                      }))
            }
        }
    }
}
