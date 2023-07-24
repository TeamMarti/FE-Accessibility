//
//  TravelScheduleView.swift
//  MRT
//
//  Created by Jeremy Raymond on 19/07/23.
//

import SwiftUI

struct TravelScheduleView: View {
    @State var isFinished: Bool = false
    
    var origin: String = "Lebak Bulus"
    var destination: String = "Dukuh Atas"
    var balance: Double = 14000
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Group {
                        Text(origin)
                            .bold()
                            .foregroundColor(Color("DarkBlue"))
                        Text("Gerbang 1")
                            .font(.footnote)
                        Text("08:00")
                            .bold()
                    }
                    .padding(.vertical, 1)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Image(isFinished ? "TravelScheduleDone" : "TravelSchedule")
                    Text(isFinished ? "Tiba di tujuan" : "Dalam Perjalanan")
                        .font(.footnote)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    if isFinished {
                        Group {
                            Text(destination)
                                .bold()
                                .foregroundColor(Color("DarkBlue"))
                            Text("Gerbang 1")
                                .font(.footnote)
                            Text("08:45")
                                .bold()
                        }
                        .padding(.vertical, 1)
                    }
                    else {
                        Group {
                            Text("Menunggu")
                            Text("Penurunan")
                        }
                        .foregroundColor(.orange)
                    }
                }

            }
            .padding()
            Divider()
            VStack(alignment: .leading) {
                Text("Saldo Terpotong")
                    .font(.footnote)
                Text(isFinished ? "Rp. \(balance, specifier: "%.0f")" : "-")
                    .foregroundColor(Color("Blue"))
            }
            .padding()
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        }
        .padding(.horizontal)
        .onAppear {
            if UserDefaults.standard.integer(forKey: "tripStatus") == 1 {
                isFinished = false
            } else {
                isFinished = true
            }
        }
    }
}

struct TravelScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        TravelScheduleView()
    }
}
