//
//  ContentView.swift
//  MegaSena_2
//
//  Created by Nazildo Souza on 09/03/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    let label = ["Mega-Sena", "Quina"]
    
    @State private var numbersSena = [1,2,3,4,5,6]
    @State private var numbersQuina = [7,8,9,10,11]
    
    @State private var selected = 0
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .leading) {
                    Image("top")
                        .resizable()
                        .frame(maxWidth: geo.size.width * 2, minHeight: geo.size.height / 4)
                        .overlay(Color.black.opacity(self.colorScheme == .dark ? 0.3 : 0))
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
                        .edgesIgnoringSafeArea(.top)
                    
                    Text(self.label[self.selected])
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(30)
                        .offset(y: geo.size.height / 20)
                }
                
                Picker(selection: self.$selected, label: Text("Jogo")) {
                    if #available(iOS 14.0, *) {
                        ForEach(0 ..< self.label.count) {
                            Text(self.label[$0])
                        }
                        .onChange(of: selected) { (value) in
                            if value == 0 {
                                self.numbersSena = self.addNumbers(total: 6, universe: 60)
                            } else {
                                self.numbersQuina = self.addNumbers(total: 5, universe: 50)
                            }
                        }
                    } else {
                        // Fallback on earlier versions
                        ForEach(0 ..< self.label.count) {
                            Text(self.label[$0])
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer(minLength: geo.size.height / 15)

                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        ForEach(0 ..< 3 ,id: \.self) { i in
                            Ball(numbers: self.selected == 0 ? self.numbersSena[i] : self.numbersQuina[i])
                                .font(.system(size: geo.size.width / 10))
                                .frame(width: geo.size.width / 5, height: geo.size.height / 10)
                        }
                    }
                    HStack(spacing: 20) {
                        ForEach(3 ..< (self.selected == 0 ? 6 : 5), id: \.self) { i in
                            Ball(numbers: self.selected == 0 ? self.numbersSena[i] : self.numbersQuina[i])
                                .font(.system(size: geo.size.width / 10))
                                .frame(width: geo.size.width / 5, height: geo.size.height / 10)
                        }
                    }
                }

                Spacer(minLength: geo.size.height / 6)
                         
                Button(action: {
                    if self.selected == 0 {
                        self.numbersSena = self.addNumbers(total: 6, universe: 60)
                    } else {
                        self.numbersQuina = self.addNumbers(total: 5, universe: 50)
                    }
                }) {
                    Text("Gerar Jogo")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .frame(width: geo.size.width / 1.2, height: geo.size.height / 15)
                        .background(self.colorScheme == .light ? Color(#colorLiteral(red: 0, green: 0.3916527629, blue: 0.7383970618, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0.2732983828, blue: 0.5167632699, alpha: 1)))
                        .cornerRadius(20)
                }
                .shadow(color: Color.black.opacity(0.4), radius: 5, x: 2, y: 2)
                Spacer(minLength: geo.size.height / 8)
            }
            .background(Color(.secondarySystemBackground))
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(perform: {
                self.numbersSena = self.addNumbers(total: 6, universe: 60)
                self.numbersQuina = self.addNumbers(total: 5, universe: 50)
            })
        }
    }
    
    func addNumbers(total: Int, universe: Int) -> [Int] {
        var result: [Int] = []
        while result.count <  total {
            let randomNumber = Int.random(in: 1...universe)
            if !result.contains(randomNumber){
                result.append(randomNumber)
            }
        }
        return result.sorted()
    }
    
    struct Ball: View {
        var numbers: Int

        var body: some View {
            ZStack {
                Image("ball")
                    .resizable()
                    .shadow(color: Color.primary.opacity(0.2), radius: 3, x: 1, y: 1)
                Text("\(self.numbers)")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
