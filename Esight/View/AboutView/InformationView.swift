//
//  InformationView.swift
//  eyes
//
//  Created by 陳奕利 on 2021/6/23.
//

import SwiftUI

struct Information {
    var title: String
    var content: String
}

struct InformationView: View {
    let information = [
        Information(title: "Computer Vision Sydrome (CVS)", content: "  CVS is a condition resulting from focusing the eyes on a computer or other display device for protracted, uninterrupted periods of time and the eye's muscles being unable to recover from the constant tension required to maintain focus on a close object. Symptoms of CVS include headaches, blurred vision, neck pain, eye strain, dry eyes, irritated eyes, double vision, dizziness, polyopia, and difficulty refocusing the eyes."),
        Information(title: "Macular Degeneration (ARMD)", content: "  ARMD,or AMD, is a medical condition which may result in blurred or no vision in the center of the visual field. Early on there are often no symptoms. Over time, however, some people experience a gradual worsening of vision that may affect one or both eyes.")]
    
    var body: some View {
        VStack {
        ForEach(information, id: \.title) { info in
            Spacer().frame(minHeight: 50)
            Text("\(info.title)")
                .font(.custom("Helvetica",size: 30))
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true)
            Spacer().frame(minHeight: 20)
            Text("\(info.content)")
                .font(.custom("Helvetica",size: 20))
                .lineSpacing(20)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            }
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
