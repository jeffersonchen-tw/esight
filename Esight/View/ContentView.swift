//
//  ContentView.swift
//  Esight
//
//  Created by 陳奕利 on 2021/6/27.
//

import SwiftUI

struct ContentView: View {
    // index of view
    @State private var showView: Int = 0
    // render view
    var body: some View {
        TabView(selection: self.$showView) {
            MainMenu(selected: self.$showView)
                .tabItem({Text("menu")}).tag(0)
            SettingView(selected: self.$showView)
                .tabItem({Text("Settings")}).tag(1)
            AboutView(selected: self.$showView)
                .tabItem({Text("About")}).tag(2)
        }.frame(width: 800, height: 600, alignment: .center)
        .background(SwiftUI.Color(red: 32/256, green: 178/256, blue: 170/256)).opacity(0.8)
    }
}


