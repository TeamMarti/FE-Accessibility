//
//  SortButtonView.swift
//  MRT
//
//  Created by Jeremy Raymond on 20/07/23.
//

import SwiftUI

struct SortButtonView: View {
    @State var isOn: Bool = true
    @State var text: String = "Terbaru"
    
    var body: some View {
        HStack {
            ZStack {
                if isOn {
                    Circle()
                        .frame(width: 20)
                        .foregroundColor(Color("DarkBlue"))
                        .padding(2)
                }
                Circle()
                    .stroke(Color("DarkBlue"), lineWidth: 2)
                    .frame(width: 28)
            }
            .animation(.default, value: isOn)
            Text(text)
        }
    }
}

struct SortButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SortButtonView()
    }
}
