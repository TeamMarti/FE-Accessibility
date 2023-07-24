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
    @StateObject var detectorManager = DetectorManager()
    
    @State private var isShowingBottomSheet = false
    @State var userName: String = ""
    @State var isConfirmed: Bool = false
    @State var userBalance: Int = 0
    @State var isEmptySchedule: Bool = true
    @ObservedObject var viewModel: ViewModel = ViewModel.shared
    
    var body: some View {
        NavigationStack {
//            Spacer()
//                .frame(height: 55)
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(" Hi, \(userName)!")
                            .font(.system(size: 15))
                            .foregroundColor(Color("LightGray"))
                        
                        Spacer().frame(height: 5)
                        
                        HStack {
                            Image(systemName: "creditcard")
                                .font(.system(size: 25))
                                .foregroundColor(Color("Black"))
                            
                            Text("RP \(String(userBalance))")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Black"))
                                .font(.system(size: 22))
                        }
                    }
                    .padding(.top, 20)
                    
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
                        .foregroundColor(detectorManager.isBluetoothOn ? .green : .red)
                    Image("Bluetooth")
                    Text(detectorManager.isBluetoothOn ? "Nyala" : "Mati")
                    Spacer()
                    Text(detectorManager.isBluetoothOn ? "Bluetooth sudah menyala" : "Pastikan aktif selama perjalanan")
                        .font(.footnote)
                        .foregroundColor(detectorManager.isBluetoothOn ? .green : .red)
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
                Spacer()
            }
            .sheet(isPresented: $isShowingBottomSheet, content: {
                BottomSheetView(isShowingBottomSheet: $isShowingBottomSheet)
                    .presentationDetents([.fraction(0.5)])
                    .onDisappear {
                        isConfirmed = UserDefaults.standard.bool(forKey: "isConfirmed")
                    }
            })
            
            //Spacer().frame(height: 200)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if viewModel.value != 1 {
                isShowingBottomSheet = true
            }
            
            isConfirmed = UserDefaults.standard.bool(forKey: "isConfirmed")
            isEmptySchedule = true
            
            if UserDefaults.standard.integer(forKey: "tripStatus") == 1 {
                isEmptySchedule = false
            } else if UserDefaults.standard.integer(forKey: "tripStatus") == 2 {
                UserDefaults.standard.set(false, forKey: "isConfirmed")
                isConfirmed = false
                isEmptySchedule = false
            }
            
            getCurrentUser()
        }
    }
    
    func getCurrentUser() {
        guard let url = URL(string: "https://raw.githubusercontent.com/TeamMarti/marti-temp-data/main/UserDatas") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(User_Data.self, from: data)
                guard let currentUser = decoded.data.first else { return }
                guard let getBalance = Int(currentUser.balance) else { return }
                
                UserDefaults.standard.set(currentUser.name, forKey: "userName")
                UserDefaults.standard.set(currentUser.email, forKey: "userEmail")
                UserDefaults.standard.set(getBalance, forKey: "userBalance")
                
                userBalance = getBalance
                userName = currentUser.name
                
                if getBalance >= 15000 {
                    detectorManager.isBalanceEnough = true
                } else {
                    detectorManager.isBalanceEnough = false
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct User_Data: Codable {
    let data: [UserData]
}
