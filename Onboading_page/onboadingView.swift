//
//  onboadingView.swift
//  Onboading_page
//
//  Created by Dinuri Dewendra on 2025-05-05.
//

import SwiftUI

// MARK: - Onboarding Page Model
struct OnboardingPage: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
}

// MARK: - Onboarding View
struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var animateImages = false

    // Auto-scroll timer
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    // Onboarding screen data
    let pages = [
        OnboardingPage(imageName: "groupedImages", title: "Browse Menus", subtitle: "Discover a world of flavors from top-rated restaurants, all at your fingertips."),
        OnboardingPage(imageName: "delivery.truck", title: "Lightning Fast Delivery", subtitle: "From kitchen to your doorstep in minutes, always fresh and delicious!"),
        OnboardingPage(imageName: "tracking.cart", title: "Real-Time Tracking", subtitle: "Watch your order's journey in real-time, from preparation to delivery.")
    ]

    var body: some View {
        VStack {
            // MARK: - Page Carousel with TabView
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        // MARK: - Custom Combined Image (only on first page)
                        if index == 0 {
                            HStack {
                                ZStack {
                                    Image("fries")
                                    // fires on the right
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 100, height: 100)
                                            .rotationEffect(.degrees(25))
                                            .offset(x: 80, y: 20)
                                            .zIndex(0) // Back layer

                                        //  Coffee on the left
                                        Image("coffee")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 150, height: 150)
                                            .rotationEffect(.degrees(-18))
                                            .offset(x: -70, y: 10)
                                            .zIndex(1) // Front layer

                                        // Burger in the center
                                        Image("burger")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 120, height: 120)
                                            .offset(x: 0, y: 30)
                                            .zIndex(2) // Middle layer
                                    }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)


                            // MARK: - Bounce Animation (up-down effect)
                            .offset(y: animateImages ? -10 : 10)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateImages)
                            .onAppear {
                                animateImages = true
                            }
                        } else {
                            // MARK: - Use Image Asset for other pages
                            Image(pages[index].imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 220)
                        }

                        // MARK: - Title Text
                        Text(pages[index].title)
                            .font(.title)
                            .fontWeight(.bold)

                        // MARK: - Subtitle Text
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

            // MARK: - Page Indicator Dots
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 10)

            // MARK: - Text Button Below Dots
            Button(action: {
                if currentPage < pages.count - 1 {
                    currentPage += 1
                } else {
                    print("Navigate to home or login screen")
                }
            }) {
                Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                    .foregroundColor(.blue)
                    .padding(.top, 8)
            }

            Spacer()
        }
    }
}
