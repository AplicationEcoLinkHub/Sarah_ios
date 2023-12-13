//
//  ContentView.swift
//  educatif
//
//  Created by sarrabs on 27/11/2023.
//

import SwiftUI

struct CoursTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image("371487087_3780580252267619_2095802961232283747_n")
                    Text("home")
                }
            EventView()
                .tabItem {
                    Image("367957659_320419407522004_4739717644858721962_n")
                    Text("Event")
                }
            CarteInteractiveView()
                .tabItem {
                    Image("370197404_1982486192132355_41717040192656202_n")
                    Text("Carte")
                }
            CoursListView()
                .tabItem {
                    Image("385533507_1507380799803961_1880102437452726642_n")
                    Text("Cours")
                }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            CoursTabView()
        }
    }
}
