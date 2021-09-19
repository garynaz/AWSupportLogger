//
//  ContentView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 8/17/21.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            VStack{
                if viewModel.signedIn {
                    MainView()
                        .transition(.slide)
                } else {
                    //.onAppear method is used for keyboard management (See Misc Functions...)
                    SignInView()
                        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                        .navigationBarHidden(true)
                }
            }
            .onAppear {
                viewModel.listen()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) //Makes the NavLinkButton deselect on TicketView after returning back from DetailView.
    }
}
