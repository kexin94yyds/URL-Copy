import AppKit
import Foundation
import SwiftUI

// MARK: - Core Logic Controller
class PathHelperController: ObservableObject {
    @Published var isEnabled = true {
        didSet { updateStatusItem() }
    }
    @Published var isHidden = false {
        didSet { updateFloatingVisibility() }
    }
    
    var statusItem: NSStatusItem?
    var floatingWindow: NSPanel?
    
    private let pasteboard = NSPasteboard.general
    private var lastChangeCount = NSPasteboard.general.changeCount
    private let saveDir = URL(fileURLWithPath: NSString(string: "~/Pictures/ClipboardShots").expandingTildeInPath)
    private var timer: Timer?

    init() {
        setupSaveDirectory()
        startMonitoring()
    }

    private func setupSaveDirectory() {
        try? FileManager.default.createDirectory(at: saveDir, withIntermediateDirectories: true)
    }

    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }

    // Toggle the main conversion functionality
    @objc func toggleEnabled() {
        isEnabled.toggle()
    }

    // Toggle the visibility of the floating ball
    @objc func toggleVisibility() {
        isHidden.toggle()
    }

    private func updateStatusItem() {
        if let button = statusItem?.button {
            button.title = isEnabled ? "🔗" : "❌"
        }
        // Re-construct menu to update text
        constructMenu()
    }

    private func updateFloatingVisibility() {
        if isHidden {
            floatingWindow?.orderOut(nil)
        } else {
            floatingWindow?.makeKeyAndOrderFront(nil)
        }
        constructMenu()
    }

    func constructMenu() {
        let menu = NSMenu()
        menu.addItem(withTitle: "路径助手", action: nil, keyEquivalent: "")
        
        let statusText = isEnabled ? "状态: 🟢 开启" : "状态: 🔴 已暂停"
        let statusItemMenu = NSMenuItem(title: statusText, action: nil, keyEquivalent: "")
        statusItemMenu.isEnabled = false
        menu.addItem(statusItemMenu)
        
        menu.addItem(NSMenuItem.separator())
        
        let toggleItem = NSMenuItem(title: isEnabled ? "暂停转换" : "开启转换", action: #selector(toggleEnabled), keyEquivalent: "t")
        toggleItem.target = self
        menu.addItem(toggleItem)
        
        let visibilityText = isHidden ? "显示悬浮球" : "隐藏悬浮球"
        let visibilityItem = NSMenuItem(title: visibilityText, action: #selector(toggleVisibility), keyEquivalent: "q")
        visibilityItem.keyEquivalentModifierMask = .option
        visibilityItem.target = self
        menu.addItem(visibilityItem)
        
        menu.addItem(withTitle: "打开图片目录", action: #selector(openSaveDir), keyEquivalent: "o").target = self
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "退出程序", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        statusItem?.menu = menu
    }

    @objc func openSaveDir() {
        NSWorkspace.shared.open(saveDir)
    }

    private func checkClipboard() {
        guard isEnabled && pasteboard.changeCount != lastChangeCount else {
            lastChangeCount = pasteboard.changeCount
            return
        }
        lastChangeCount = pasteboard.changeCount

        let formats = pasteboard.types ?? []
        
        // 1. Files/Folders from Finder
        if formats.contains(.fileURL) {
            if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
                let paths = urls.map { $0.path }.joined(separator: " ")
                if !paths.isEmpty {
                    updateClipboardWithText(paths)
                }
                return
            }
        }

        // 2. Images (Screenshots/Copy Image)
        if (formats.contains(.png) || formats.contains(.tiff)) && !formats.contains(.string) {
            if let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage,
               let tiffData = image.tiffRepresentation,
               let bitmap = NSBitmapImageRep(data: tiffData),
               let pngData = bitmap.representation(using: .png, properties: [:]) {
                
                let fileName = "Clipboard_\(Int(Date().timeIntervalSince1970)).png"
                let fileURL = saveDir.appendingPathComponent(fileName)
                
                do {
                    try pngData.write(to: fileURL)
                    updateClipboardWithText(fileURL.path)
                } catch {
                    print("Error saving image: \(error)")
                }
            }
        }
    }

    private func updateClipboardWithText(_ text: String) {
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        lastChangeCount = pasteboard.changeCount
    }
}

// MARK: - UI Components
struct FloatingBallView: View {
    @ObservedObject var controller: PathHelperController
    
    var body: some View {
        ZStack {
            Circle()
                .fill(controller.isEnabled ? Color.blue.opacity(0.8) : Color.red.opacity(0.8))
                .frame(width: 40, height: 40)
                .shadow(radius: 4)
            
            Image(systemName: "link")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
        }
    }
}

class MouseView: NSHostingView<FloatingBallView> {
    var controller: PathHelperController?
    
    override func mouseDown(with event: NSEvent) {
        if event.clickCount == 2 {
            NSApplication.shared.terminate(nil)
        } else {
            controller?.toggleEnabled()
        }
    }
    
    override func rightMouseDown(with event: NSEvent) {
        let menu = NSMenu()
        menu.addItem(withTitle: "隐藏悬浮球 (Opt+Q)", action: #selector(PathHelperController.toggleVisibility), keyEquivalent: "").target = controller
        menu.addItem(withTitle: "退出程序", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "")
        NSMenu.popUpContextMenu(menu, with: event, for: self)
    }
}

// MARK: - App Delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    let controller = PathHelperController()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // Setup Status Bar Item
        controller.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        controller.constructMenu()
        if let button = controller.statusItem?.button {
            button.title = "🔗"
        }
        
        // Setup Floating Window
        let screenFrame = NSScreen.main?.frame ?? NSRect.zero
        let panel = NSPanel(
            contentRect: NSRect(x: 20, y: screenFrame.height - 100, width: 40, height: 40),
            styleMask: [.nonactivatingPanel, .fullSizeContentView],
            backing: .buffered, defer: false)
        
        panel.isFloatingPanel = true
        panel.level = .mainMenu
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = false
        
        let mouseView = MouseView(rootView: FloatingBallView(controller: controller))
        mouseView.controller = controller
        panel.contentView = mouseView
        panel.makeKeyAndOrderFront(nil)
        
        controller.floatingWindow = panel
        
        // 全局热键监听：Option + Q 切换悬浮球显示/隐藏
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            // keyCode 12 = Q 键
            if event.modifierFlags.contains(.option) && event.keyCode == 12 {
                self?.controller.toggleVisibility()
            }
        }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
