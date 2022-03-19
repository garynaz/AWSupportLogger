//
//  UpdateView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 12/9/21.
//

import SwiftUI

struct UpdateView: View {
    
    @EnvironmentObject private var appViewModel: AppViewModel
    @Environment(\.presentationMode) var presentation //Tells the view to dismiss itself using its presentation mode environment key.
    
    var body: some View {
        ZStack{
            if appViewModel.emptyUpdateView{
                Text("No Active Tickets")
                    .opacity(0.5)
                    .foregroundColor(Color(UIColor.systemGray2))
                    .font(.system(size: 30, weight: .semibold, design: .default))
                    .offset(y: -50)
                Button("Clear All Notifications"){
                    appViewModel.updateIcon = "bell"
                    self.presentation.wrappedValue.dismiss()
                }
            } else {
                List{
                    ForEach(appViewModel.userTicketsArray) { ticket in
//                        NavigationLink(
//                            destination: DetailView(selectedTicket: ticket)){
//                                updateRow(ticket: ticket)
//                            }
                        Button {
                            self.presentation.wrappedValue.dismiss()
                        } label: {
                            updateRow(ticket: ticket)
                        }

                    }
//                    .onDelete(perform: appViewModel.deleteTicket)
                    .listRowBackground(Color.themeBackground)
                }
//                .toolbar{
//                    EditButton()
//                }
            }
        }
        
    }
}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateView()
    }
}


struct updateRow: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var ticket : Ticket
    
    var body: some View {
        
        VStack{
            Text(ticket.type)
				.foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .font(.system(size: 20, weight: .semibold))
            
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    Text(appViewModel.userInfo!.company)
						.foregroundColor(.gray)
                        .font(.system(size: 20, weight: .bold))
                    Text(ticket.date)
						.foregroundColor(.gray)
                        .font(.caption)
                        .fontWeight(.bold)
                    
                    Text("Submitted By: \(appViewModel.userInfo!.name)")
						.foregroundColor(.gray)
                        .font(.system(size: 15, weight: .light))
                    
                    Text(ticket.inquiry)
						.foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack{
                    Text(ticket.status)
						.foregroundColor(.black)
                        .padding()
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .lineLimit(1)
                }
            }
            
        }
        .padding()
        
    }
}
