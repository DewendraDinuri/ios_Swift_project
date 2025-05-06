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
    @State private var animateText = false

    // Auto-scroll timer
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    // Page data
    let pages = [
        OnboardingPage(imageName: "groupedImages", title: "Browse Menus", subtitle: "Discover a world of flavors from top-rated restaurants, all at your fingertips."),
        OnboardingPage(imageName: "deliver", title: "Lightning Fast Delivery", subtitle: "From kitchen to your doorstep in minutes, always fresh and delicious!"),
        OnboardingPage(imageName: "track", title: "Real-Time Tracking", subtitle: "Watch your order's journey in real-time, from preparation to delivery.")
    ]

    var body: some View {
        VStack {
            // MARK: - Page Carousel
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        // MARK: - First page with layered food images
                        if index == 0 {
                            ZStack {
                                Image("fries")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .rotationEffect(.degrees(25))
                                    .offset(x: 80, y: 20)
                                    .zIndex(0)

                                Image("coffee")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 150, height: 150)
                                    .rotationEffect(.degrees(-18))
                                    .offset(x: -70, y: 10)
                                    .zIndex(1)

                                Image("burger")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                                    .offset(x: 0, y: 30)
                                    .zIndex(2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            .offset(y: animateImages ? -10 : 10)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateImages)
                            .onAppear {
                                animateImages = true
                            }
                        } else {
                            // MARK: - Other pages with burger in background
                            ZStack {
                                Image("burger")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 130, height: 130)
                                    .offset(y: 30)
                                    .opacity(0.2)
                                    .zIndex(0)
                                    .offset(y: animateImages ? -5 : 5)
                                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateImages)

                                Image(pages[index].imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 180)
                                    .zIndex(1)
                            }
                            .padding(.top, 40)
                        }

                        // MARK: - Texts with animation
                        VStack(spacing: 8) {
                            Text(pages[index].title)
                                .font(.title)
                                .fontWeight(.bold)
                                .opacity(animateText ? 1 : 0)
                                .offset(y: animateText ? 0 : 20)
                                .animation(.easeOut(duration: 0.6), value: animateText)

                            Text(pages[index].subtitle)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .opacity(animateText ? 1 : 0)
                                .offset(y: animateText ? 0 : 20)
                                .animation(.easeOut(duration: 0.6).delay(0.2), value: animateText)
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                animateText = true
                animateImages = true
            }
            .onChange(of: currentPage) { _ in
                animateText = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animateText = true
                }
            }
            .onReceive(timer) { _ in
                withAnimation {
                    currentPage = (currentPage + 1) % pages.count
                    animateText = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animateText = true
                }
            }

            Spacer()

            // MARK: - Page Dots
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 10)

            // MARK: - Navigation Button
            Button(action: {
                if currentPage < pages.count - 1 {
                    currentPage += 1
                } else {
                    print("Navigate to home or login screen")
                }

                animateText = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animateText = true
                }
            }) {
                Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                    .padding(.top, 12)
            }

            Spacer()
        }
    }
}
