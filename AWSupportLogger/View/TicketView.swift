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
    
    var body: some View {
        List{
            ForEach(appViewModel.ticketsArray) { ticket in
                NavigationLink(
                    destination: DetailView(selectedTicket: ticket)){
                    ticketRow(ticket: ticket)
                }
            }
            .onDelete(perform: deleteTicket).animation(.default)
        }
        .toolbar(content: {
            EditButton()
        }).animation(.default)
    }


    func deleteTicket(at offsets: IndexSet){
        for offset in offsets {
            let selectedTicket = appViewModel.ticketsArray[offset].key!
            
            DispatchQueue.main.async {
                appViewModel.rootTicketCollection!.document(selectedTicket.documentID).delete()
                appViewModel.ticketsArray.remove(at: offset)
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
        VStack(alignment: .leading) {
            Text(ticket.type)
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                .font(.system(size: 20, weight: .semibold))

            HStack(alignment: .center) {
                Text(appViewModel.userInfo!.company)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Text(ticket.status)
                    .padding()
                    .minimumScaleFactor(0.5)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .lineLimit(1)
            }
            Text(ticket.date)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            Spacer()
            Spacer()
            Text("Submitted By: \(appViewModel.userInfo!.name)")
                .font(.system(size: 15, weight: .light))
                .padding(.bottom, 5)
            Text(ticket.inquiry)
                .lineLimit(2)
                .foregroundColor(.gray)
        }
    }
}
