//
//  iMasteryMainView.swift
//  iMastery
//
//  Created by Saloni Singh on 01/05/25.
//

import SwiftUI

struct iMasteryMainView: View {
    @State var animate: Bool = false
    @State var showView: Bool = false
    
    var body: some View {
        VStack(spacing: 20){
            Text("📱 iMastery")
                .padding()
                .bold()
                .font(.largeTitle)
                .scaleEffect(animate ? 1.1 : 1.0)
                .offset(y: animate ? -7 : 0)
                            
            Text("iMastry is an all in one iOS app that showcases all the tasks and learning I completed during my training.")
                .font(.title3)
                .foregroundStyle(LinearGradient.blueGradient)
                .multilineTextAlignment(.center)
                .padding(.bottom, 25)
            
            VStack{
                Button("Know More.."){
                    showView.toggle()
                }
                .foregroundStyle(.blue)
                .font(.title3)
                .bold()
                
                if showView{
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(LinearGradient.blueGradient)
                        
                        ScrollView{
                            VStack(alignment: .leading, spacing: 10) {
                                
                                // Description
                                Text("iMastry is a SwiftUI-based iOS application that brings together all the learning, tasks, and mini-projects completed during my training period. This all-in-one app showcases various concepts I explored, including SwiftUI layouts, Core Data, networking, animations, state management, and more.")
                                    .font(.body)
                                
                                // Features Section
                                Text("Features")
                                    .font(.title)
                                    .bold()
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("• Modular and scalable SwiftUI architecture")
                                    Text("• Core Data integration for persistent storage")
                                    Text("• Custom UI components and animations")
                                    Text("• Real-world tasks and practice projects")
                                    Text("• Clean and readable code structure for learning purposes")
                                }
                                
                                // Tech Stack Section
                                Text("Tech Stack")
                                    .font(.title)
                                    .bold()
                                
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("• SwiftUI")
                                    Text("• Core Data")
                                    Text("• MVVM Architecture")
                                }
                            }
                            .padding()
                            .foregroundStyle(.white)
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .opacity(showView ? 1.0 : 0.0)
                    .transition(AnyTransition.scale.animation(.easeInOut(duration: 0.5)))
                }
            }
        }
        .padding()
        .onAppear(perform: addAnimation)
    }
    
    func addAnimation(){
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            ){
                animate.toggle()
            }
        }
    }
}

#Preview {
    iMasteryMainView()
}
