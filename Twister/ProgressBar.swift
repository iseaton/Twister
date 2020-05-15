//
//  ProgressBar.swift
//  Twister
//
//  Created by Isaac Eaton on 5/14/20.
//  Copyright © 2020 Isaac Eaton. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height:
                    geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                Rectangle().frame(width: CGFloat(self.value)*geometry.size.width, height: geometry.size.height)
                    .foregroundColor(Color.navy)
                    .animation(.linear)
            }
        }
    }
}
