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
    @State private var animateText = false
    @State private var animateImage = false
    @State private var animateStack = false

    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    let pages = [
        OnboardingPage(imageName: "groupedImages", title: "Browse Menus", subtitle: "Discover a world of flavors from top-rated restaurants, all at your fingertips."),
        OnboardingPage(imageName: "deliver", title: "Lightning Fast Delivery", subtitle: "From kitchen to your doorstep in minutes, always fresh and delicious!"),
        OnboardingPage(imageName: "track", title: "Real-Time Tracking", subtitle: "Watch your order's journey in real-time, from preparation to delivery.")
    ]

    var body: some View {
        VStack {
            // MARK: - Carousel
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        // MARK: - First Page (stacked images)
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
                                    .frame(width: 100, height: 100)
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
                            .padding(.top, 60) // Fixed spacing
                            .opacity(animateStack ? 1 : 0)
                            .offset(y: animateStack ? 0 : 30)
                            .animation(.easeOut(duration: 0.8), value: animateStack)
                            .onAppear {
                                animateStack = true
                            }
                        } else {
                            // MARK: - Other Pages (single image with animation)
                            Image(pages[index].imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .padding(.top, 60)
                                .opacity(animateImage ? 1 : 0)
                                .offset(y: animateImage ? 0 : 30)
                                .animation(.easeOut(duration: 0.8), value: animateImage)
                        }

                        // MARK: - Title
                        Text(pages[index].title)
                            .font(.title)
                            .fontWeight(.bold)
                            .opacity(animateText ? 1 : 0)
                            .offset(y: animateText ? 0 : 20)
                            .animation(.easeOut(duration: 0.6), value: animateText)

                        // MARK: - Subtitle
                        Text(pages[index].subtitle)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .opacity(animateText ? 1 : 0)
                            .offset(y: animateText ? 0 : 20)
                            .animation(.easeOut(duration: 0.6).delay(0.2), value: animateText)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                animateText = true
                animateImage = true
                animateStack = true
            }
            .onChange(of: currentPage) { _ in
                animateText = false
                animateImage = false
                animateStack = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    animateText = true
                    animateImage = true
                    animateStack = true
                }
            }
            .onReceive(timer) { _ in
                withAnimation {
                    currentPage = (currentPage + 1) % pages.count
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

            // MARK: - Next Button
            Button(action: {
                if currentPage < pages.count - 1 {
                    currentPage += 1
                } else {
                    print("Navigate to home or login screen")
                }
                animateText = false
                animateImage = false
                animateStack = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    animateText = true
                    animateImage = true
                    animateStack = true
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
