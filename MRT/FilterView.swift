//
//  FilterView.swift
//  MRT
//
//  Created by Jeremy Raymond on 21/07/23.
//

import SwiftUI

struct FilterView: View {
    @State var date: Date = Date.now
    
    var body: some View {
        VStack {
            Text("Filter")
                .font(.title3)
                .bold()
            HStack {
                VStack(alignment: .leading) {
                    Text("Kategori")
                    HStack {
                        Button {
                            
                        } label: {
                            Text("Isi Saldo")
                                .font(.footnote)
                                .foregroundColor(.white)
                                .padding(6)
                                .padding(.horizontal, 4)
                                .background(Color("DarkBlue"))
                                .cornerRadius(8)
                        }
                        Button {
                            
                        } label: {
                            Text("Perjalanan")
                                .font(.footnote)
                                .foregroundColor(Color("DarkBlue"))
                                .padding(6)
                                .padding(.horizontal, 4)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("DarkBlue").opacity(0.5) , lineWidth: 1)
                                }
                        }

                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            
            Divider()
            HStack {
                Text("Tanggal")
                Spacer()
                Text("14 Jun 2022 - 30 Jun 2022")
                    .foregroundColor(Color("DarkBlue"))
            }
            DatePicker("Select", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding()
        }
        .padding()
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
