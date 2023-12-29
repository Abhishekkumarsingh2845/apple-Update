import SwiftUI

// ContentView represents the main user interface of the Octory application.
struct ContentView: View {

    // State variables for managing UI interactions and state changes.
    @State private var showAlert = false
    @State private var tap = false
    @State private var currentIndex = 0

    // Body of the ContentView.
    var body: some View {

        // Main ZStack containing the background image and UI elements.
        ZStack {

            // Background image of the application.
            Image("BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // Overlay ZStack for displaying a semi-transparent background and UI elements.
            ZStack {

                // Semi-transparent gray background with rounded corners and shadow.
                Color.gray.opacity(0.6)
                    .frame(width: 450, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
                    .blur(radius: 2)

                // VStack containing the main content of the application.
                VStack(alignment: .center, spacing: 50) {

                    // Header text for indicating a software update.
                    Text("SOFTWARE UPDATE AVAILABLE!")
                        .font(Font.custom("Cinzel", size: 25))
                        .foregroundColor(Color.black.opacity(1))
                        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
                            // Hides window buttons when application becomes active.
                            NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isHidden = true
                            NSApp.mainWindow?.standardWindowButton(.closeButton)?.isHidden = true
                            NSApp.mainWindow?.standardWindowButton(.miniaturizeButton)?.isHidden = true
                        }

                    // Image carousel with a timer to switch between images.
                    let imageNames = ["tc", "applee"]
                    ZStack {
                        Spacer()
                        Image(imageNames[currentIndex])
                            .resizable()
                            .frame(width: 60, height: 60)
                            .animation(.default)
                        Spacer()
                    }
                    .onAppear {
                        // Timer to automatically switch images every 3 seconds.
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                            currentIndex = (currentIndex + 1) % imageNames.count
                        }
                    }

                    // DEFER button for minimizing and restoring the window.
                    Button(action: {
                        NSApplication.shared.windows.first?.miniaturize(self)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 300) {
                            NSApplication.shared.windows.first?.deminiaturize(self)
                        }
                    }) {
                        Text("DEFER")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(CustomButtonStyle())

                    // INFO button for opening a web link.
                    Button(action: {
                        if let url = URL(string: "https://www.apple.com/in/newsroom/2023/09/macos-sonoma-is-available-today/") {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                        Text("INFO")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(CustomButtonStyle())

                    // BACKUP button for showing an informative alert.
                    Button(action: {
                        self.showAlert = true
                    }) {
                        Text("BACKUP")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(CustomButtonStyle())
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("To Proceed with Update kindly Backup your important data->Steps to Back-UP 1.Make a Backup Folder and copy all important Data to this folder2.Upload this folder to Gmail Drive/iCloud Drive Or Hard Disk/Pendrive"),
                            dismissButton: .default(Text("OK"))
                        )
                    }

                    // UPDATE button for opening a Google Form.
                    Button(action: {
                        if let url = URL(string: "https://docs.google.com/forms/d/e/your_form_link_here") {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                        Text("UPDATE")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(CustomButtonStyle())

                }
                .padding(.bottom, 70)

            }
            .padding(.top, 170)

        }
        .onAppear {
            // Timer to bring the application window to the front every 10 hours.
            Timer.scheduledTimer(withTimeInterval: 36000, repeats: true) { timer in
                NSApplication.shared.windows.first?.makeKeyAndOrderFront(nil)
            }
        }

    }

}

// CustomButtonStyle for styling buttons with animations.
struct CustomButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color(.blue)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .shadow(color: Color.blue.opacity(configuration.isPressed ? 0.6 : 0.3), radius: configuration.isPressed ? 10 : 20, x: 0, y: configuration.isPressed ? 5 : 10)
            )
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6))
    }

}

// Preview provider for ContentView.
struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }

}
