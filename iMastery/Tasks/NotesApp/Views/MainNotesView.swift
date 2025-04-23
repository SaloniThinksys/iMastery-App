//
//  MainNotesView.swift
//  iMastery
//
//  Created by Saloni Singh on 23/04/25.
//

import SwiftUI

struct MainNotesView: View {
    @State private var showVoiceInput = false
    @State private var showAttachmentOptions = false
    @State private var showAddOptions = false
    
    var body: some View {
        ZStack{
            VStack{
                //editor
                
                
                Spacer()
                
                //botto buttons
                HStack(spacing: 100) {
                    Button(action: {
                        showVoiceInput.toggle()
                    }) {
                        Image(systemName: "mic")
                            .font(.system(size: 24))
                    }

                    Button(action: {
                        showAttachmentOptions.toggle()
                    }) {
                        Image(systemName: "paperclip")
                            .font(.system(size: 24))
                    }

                    Button(action: {
                        showAddOptions.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 24))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.bottom, 5)
            }// end vstack
            
        }//end zstack
        
        if showAttachmentOptions {
            AddAttachmentsView()
                .transition(.move(edge: .bottom))
        }
        
        if showAddOptions{
            AddNotesView()
        }
        
        if showVoiceInput{
            SpeakToTextView()
        }
    }
}

#Preview {
    MainNotesView()
}
