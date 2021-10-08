//
//  DetailView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 9/18/21.
//

import SwiftUI
import Firebase

struct DetailView: View {
    
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var selectedTicket: Ticket!
    var body: some View {
        List(appViewModel.allMessagesArray){i in
                        
            VStack(alignment: .leading) {
                Text(selectedTicket.type)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 25, weight: .light))
                Spacer()
                Spacer()
                Text(selectedTicket.date)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                HStack {
                    HStack {
                        Text(appViewModel.userInfo!.name)
                            .font(.system(size: 20, weight: .light))
                    }
                    Spacer()

                    if selectedTicket.priority == "High"{
                        Text("\(selectedTicket.priority) Priority")
                            .padding()
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    } else if selectedTicket.priority == "Medium"{
                        Text("\(selectedTicket.priority) Priority")
                            .padding()
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    } else {
                        Text("\(selectedTicket.priority) Priority")
                            .padding()
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }

                }
                Spacer()
                Text(selectedTicket.inquiry)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20, weight: .light))
            }
        }
        .navigationBarTitle(appViewModel.userInfo!.company, displayMode: .inline)
        .listStyle(PlainListStyle())
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
