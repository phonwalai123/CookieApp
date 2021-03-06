//
//  Home.swift
//  Cookie App
//
//  Created by phonwalai on 4/6/2564 BE.
//

import SwiftUI

struct Home: View {
    
    @StateObject var HomeModel = HomeViewModel()
    
    var body: some View {
        
        ZStack{
            VStack(spacing:10){
                HStack(spacing: 15){
                    
                    Button(action: {
                        withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    })
                    

                    Text(HomeModel.userLocation == nil ? "Locating...":"Deliver To")
                        .foregroundColor(.blue)
                    
                    Text(HomeModel.userAddress)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                }.padding([.horizontal,.top])
                Divider()
                
                HStack(spacing:15){
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    TextField("Search",text: $HomeModel.search)
                    
                }
                .padding(.horizontal)
                .padding(.top,10)
                
                Divider()
                
                if HomeModel.items.isEmpty{
                    
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                }
                else{
                    
                    ScrollView(.vertical,showsIndicators: false,content:{
                        
                        VStack(spacing: 25){
                            
                            ForEach(HomeModel.filtered){item in
                                //Item view
                                
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                                    ItemView(item: item)
                                    
                                    HStack{
                                        
                                        Text("FREE DELIVERY")
                                            .foregroundColor(.white)
                                            .padding(.vertical,10)
                                            .padding(.horizontal)
                                            .background(Color.blue)
                                        
                                        Spacer(minLength: 0)
                                        
                                        Button(action: {
                                            
                                            HomeModel.addToCard(item: item)
                                        }, label: {
                                            
                                            Image(systemName: item.isAdded ? "checkmark" : "plus")
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(item.isAdded ? Color.green :Color.blue)
                                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                        })
                                    }
                                    
                                    .padding(.trailing,10)
                                    .padding(.top,10)
                                        
                                })
                                .frame(width: UIScreen.main.bounds.width - 30)
                            }
                        }
                        .padding(.top,10)
                    })
                }
            }
            
            //Side Menu
            HStack{
                Menu(homeData: HomeModel)
                //Move Effect From Letf
                    .offset(x:HomeModel.showMenu ? 0: -UIScreen.main.bounds.width/1.6)
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
            .background(
                Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea()
                    
                //clsing when Taps on outside...
                    .onTapGesture(perform: {
                        withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                    })
            )
            
            //Non claosable alert if permission denied...
            if HomeModel.noLocation{
                
                Text("Please Enable Location Access In Setting To Further Mpve On !")
                    
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
        }
        
        .onAppear(perform: {
            //calling location delegate...
            HomeModel.locationManager.delegate = HomeModel
            
        })
        
        .onChange(of: HomeModel.search, perform: { value in
            
            //to avoid continues search reqests
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                
                if value == HomeModel.search && HomeModel.search != ""{
                    //Search Data
                    
                    HomeModel.filterData()
                }
            }
            
            if HomeModel.search == "" {
                //reset all data
                withAnimation(.linear){HomeModel.filtered = HomeModel.items}
            }
        })
    }
}


