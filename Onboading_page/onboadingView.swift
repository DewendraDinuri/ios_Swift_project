//
//  onboadingView.swift
//  Onboading_page
//
//  Created by Dinuri Dewendra on 2025-05-05.
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
}

struct OnboardingView: View {
    @State private var currentPage = 0
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    let pages = [
        OnboardingPage(imageName: "fries.burger.coffee", title: "Browse Menus", subtitle: "Discover a world of flavors from top-rated restaurants, all at your fingertips."),
        OnboardingPage(imageName: "delivery.truck", title: "Lightning Fast Delivery", subtitle: "From kitchen to your doorstep in minutes, always fresh and delicious!"),
        OnboardingPage(imageName: "tracking.cart", title: "Real-Time Tracking", subtitle: "Watch your order's journey in real-time, from preparation to delivery.")
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        Image(pages[index].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .padding()

                        Text(pages[index].title)
                            .font(.title)
                            .fontWeight(.bold)

                        Text(pages[index].subtitle)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .onReceive(timer) { _ in
                withAnimation {
                    currentPage = (currentPage + 1) % pages.count
                }
            }

            Spacer()

            Button(action: {
                if currentPage < pages.count - 1 {
                    currentPage += 1
                } else {
                    print("Navigate to home or login screen")
                }
            }) {
                Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            Spacer()
        }
    }
}
