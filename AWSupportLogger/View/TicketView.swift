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
//        ScrollView(.vertical, showsIndicators: false){
        List{
            ForEach(appViewModel.userTicketsArray) { ticket in
                NavigationLink(
                    destination: DetailView(selectedTicket: ticket)){
                        ticketRow(ticket: ticket)
//                            .padding()
                    }
            }
            .onDelete(perform: deleteTicket).animation(.default) //This functionality only works on List View. Doesn't work with ScrollView.
//        }
        }
        .toolbar{
            EditButton()
        }
    }
    
    
    
    func deleteTicket(at offsets: IndexSet){
        for offset in offsets {
            let selectedTicket = appViewModel.userTicketsArray[offset].key!
            
            DispatchQueue.main.async {
                //Deletes all Ticket Messages when deleting Ticket...
                appViewModel.rootMessageCollection!.document(appViewModel.userIdRef).collection("Message").whereField("ticketId", isEqualTo: selectedTicket.documentID).addSnapshotListener { (querySnapshot, err) in
                    
                    guard let snapshot = querySnapshot else {return}
                    
                    for message in snapshot.documents{
                        print("Deleting Message: \(message.data())")
                        appViewModel.rootMessageCollection!.document(appViewModel.userIdRef).collection("Message").document(message.documentID).delete()
                    }
                }
                
                appViewModel.rootTicketCollection!.document(selectedTicket.documentID).delete()
                appViewModel.userTicketsArray.remove(at: offset)
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
//                        .foregroundColor(.white)
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
//        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
//        .frame(height: 180, alignment: .center)
//        .background(Color.secondary)
//        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        
    }
}
