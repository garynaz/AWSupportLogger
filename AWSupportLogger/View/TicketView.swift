//
//  TicketView.swift
//  AWSupportLogger
//
//  Created by Gary Naz on 9/12/21.
//

import SwiftUI
import Firebase

struct TicketView: View {
    
    @EnvironmentObject private var appViewModel: AppViewModel
    @State var emptyView:Bool = false
    
    var body: some View {
        ZStack{
            if emptyView{
                Text("No Active Tickets")
                    .opacity(0.5)
                    .foregroundColor(Color(UIColor.systemGray2))
                    .font(.system(size: 30, weight: .semibold, design: .default))
                    .offset(y: -50)
            } else{
                List{
                    ForEach(appViewModel.userTicketsArray) { ticket in
                        NavigationLink(
                            destination: DetailView(selectedTicket: ticket)){
                                ticketRow(ticket: ticket)
                            }
                    }
                    .onDelete(perform: appViewModel.deleteTicket)
                    .listRowBackground(Color.themeBackground)
                }
                .toolbar{
                    EditButton()
                }
            }
        }
        .onAppear(){
            if appViewModel.userTicketsArray.isEmpty{
                emptyView = true
            }
        }
        
    }
    
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        TicketView()
    }
}

struct ticketRow: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var ticket : Ticket
    
    var body: some View {
        
        VStack{
            Text(ticket.type)
                .frame(maxWidth: .infinity)
                .font(.system(size: 20, weight: .semibold))
            
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    Text(appViewModel.userInfo!.company)
                        .font(.system(size: 20, weight: .bold))
                    Text(ticket.date)
                        .font(.caption)
                        .fontWeight(.bold)
                    
                    Text("Submitted By: \(appViewModel.userInfo!.name)")
                        .font(.system(size: 15, weight: .light))
                    
                    Text(ticket.inquiry)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack{
                    Text(ticket.status)
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
