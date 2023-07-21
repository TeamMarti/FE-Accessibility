//
//  HomeView.swift
//  MRT
//
//  Created by Kanaya Tio on 17/07/23.
//

import SwiftUI
import CoreLocation
import CoreBluetooth

struct HomeView: View {
    @StateObject var detectorManager = DetectorManager(bluetoothManager: CBCentralManager(), locationManager: CLLocationManager())
    
    @State private var isShowingBottomSheet = false
    @ObservedObject var viewModel: ViewModel = ViewModel.shared
    
    var isEmptySchedule: Bool = false
    var isConfirmed: Bool = false
    var isBluetoothOn: Bool = false
    
    var body: some View {
        NavigationStack {
            Spacer()
                .frame(height: 55)
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(" Hi, Maria Jonas!")
                            .font(.system(size: 15))
                            .foregroundColor(Color("LightGray"))
                        
                        Spacer().frame(height: 5)

                        HStack {
                            Image(systemName: "creditcard")
                                .font(.system(size: 25))
                                .foregroundColor(Color("Black"))

                            Text("RP 50.000")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Black"))
                                .font(.system(size: 22))
                        }
                    }
                    
                    ZStack {
                        Rectangle()
                            .frame(width: 138, height: 34)
                            .cornerRadius(6)
                            .foregroundColor(Color("Blue"))
                        
                        HStack {
                            Image(systemName: "plus")
                                .font(.system(size: 15))
                                .foregroundColor(Color("White"))
                                .fontWeight(.medium)
                            
                            Text("Top Up Saldo")
                                .foregroundColor(Color("White"))
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.leading, 60.0)
                }
                
                Divider()
                //Spacer().frame(height: 16)

                HStack {
                    Circle()
                        .frame(width: 8)
                        .foregroundColor(.red)
                    Image("Bluetooth")
                    Text(isBluetoothOn ? "Nyala" : "Mati")
                    Spacer()
                    Text("Pastikan aktif selama perjalanan")
                        .font(.footnote)
                        .foregroundColor(.red)
                    
                }
                .padding()
                
                if !isConfirmed {
                    ZStack {
//                        Image("ConfirmPaymentBackground")
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Konfirmasi\nPemotongan Saldo")
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("Black"))
                                
                                Text("Saldo akan terpotong otomatis\nsaat kamu keluar dari peron\nstasiun tujuan")
                                    .font(.system(size: 13))
                                    .fontWeight(.regular)
                                    .foregroundColor(Color("Black"))
                                    Button(action: {
                                    isShowingBottomSheet = true
                                }) {
                                    Text("KONFIRMASI")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color("Black"))
                                        .padding(.vertical,12)
                                        .padding(.horizontal)
                                        .cornerRadius(10)
                                        .fontWeight(.semibold)
                                        .background(Color("White"))
                                        .cornerRadius(6)
                                }
                            }
                            Image("MartiConfirmPayment")
                        }
                        .padding()
                        .background(
                            Color("Blue").opacity(0.75)
                        )
                        .cornerRadius(12)

                    }
                }
                
                HStack {
                    Text("Perjalananmu Hari Ini")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("DarkBlue"))
                    Spacer()
                }
                .padding()
                
                
                
                if !isEmptySchedule {
                    ScrollView {
                        TravelScheduleView()
                    }
                }
                else {
                    Spacer().frame(height: 70)
                    
                    Image("MartiNoTravelYet")

                    Text("Hari ini kamu belum ada perjalanan dengan Swee")
                        .font(.system(size: 13))
                        .fontWeight(.light)
                        .foregroundColor(Color("LightGray"))
                }
            }
            .sheet(isPresented: $isShowingBottomSheet, content: {
                BottomSheetView(isShowingBottomSheet: $isShowingBottomSheet)
                    .presentationDetents([.fraction(0.5)])
            }
            
            //Spacer().frame(height: 200)
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            if viewModel.value != 1 {
                isShowingBottomSheet = true
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
