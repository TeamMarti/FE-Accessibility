//
//  HistoryView.swift
//  MRT
//
//  Created by Kanaya Tio on 17/07/23.
//

import SwiftUI

struct HistoryView: View {
    @State var isSortActive: Bool = false
    @State var isFilterActive: Bool = false
    
    var body: some View {
        VStack {
            Text("Riwayat")
                .bold()
            Divider()
            HStack {
                Spacer()
                Button {
                    isSortActive.toggle()
                } label: {
                    Label("Urutkan", image: "SortSymbol")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 36)
                        .foregroundColor(.white)
                        .background(Color("Blue"))
                        .cornerRadius(8)
                }

                Spacer()
                
                Button {
                    isFilterActive.toggle()
                } label: {
                    Label("Filter", image: "FilterSymbol")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 36)
                        .foregroundColor(.white)
                        .background(Color("Blue"))
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding()

            ScrollView {
                HStack {
                    Image("TrainSymbol")
                    VStack(alignment: .leading) {
                        Text("Perjalanan")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.blue)
                        Text("Lebak Bulus - Dukuh Atas")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("15 Juli 2023 | 08:00 - 09.45")
                            .font(.footnote)
                    }
                    Spacer()
                    Text("Rp 14.000")
                        .foregroundColor(.red)
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("LightGray").opacity(0.5) , lineWidth: 1)
                }
                .padding(.horizontal)
                
                HStack {
                    Image("WalletSymbol")
                    VStack(alignment: .leading) {
                        Text("Perjalanan")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.blue)
                        Text("15 Juli 2023 | 07:00")
                            .font(.footnote)
                    }
                    Spacer()
                    Text("Rp 50.000")
                        .foregroundColor(.blue)
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("LightGray").opacity(0.5) , lineWidth: 1)
                }
                .padding(.horizontal)
            }
            
        }
        .sheet(isPresented: $isSortActive) {
            VStack {
                Text("Urutkan")
                    .bold()
                    .font(.title3)
                    .padding(.top)
                HStack {
                    VStack {
                        SortButtonView()
                        SortButtonView(isOn: false, text: "Terlama")
                    }
                    Spacer()
                }
                .padding(.bottom)
                
                Button {
                    
                } label: {
                    Text("Tampilkan")
                        .padding(.vertical, 12)
                        .padding(.horizontal, 136)
                        .foregroundColor(.white)
                        .background(Color("Blue"))
                        .cornerRadius(8)
                }
            }
            .padding()
            .presentationDetents([.fraction(0.25)])
            .presentationDragIndicator(.visible)
            .padding(.top)
        }
        .sheet(isPresented: $isFilterActive) {
            FilterView()
            .padding(.vertical)
            .presentationDetents([.fraction(0.65)])
            .presentationDragIndicator(.visible)
            .padding(.top)

        }

        
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
