//
//  AboutView.swift
//  eyes
//
//  Created by 陳奕利 on 2021/6/23.
//

import SwiftUI

struct AboutView: View {
    @Binding var selected: Int
    var body: some View {
        VStack {
            ScrollView {
            Spacer()
            HStack {
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 35)
                Text("About")
                    .font(.custom("Helvetica",size: 35))
                    .fontWeight(.heavy)
            }
            HStack {
                InformationView().padding()
                VStack {
                    HStack {
                        Image(systemName: "ant.fill")
                        Text("Contact & Bug Report")
                            .fontWeight(.bold)
                    }
                    Image("GithubQrcode").resizable().scaledToFit().frame(width: 150)
                }.padding()
            }
            }
        }
    }
}
