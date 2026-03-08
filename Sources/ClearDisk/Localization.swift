import Foundation
import SwiftUI

/// Observable language manager for runtime switching
class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @AppStorage("appLanguage") var appLanguage: String = "auto" {
        didSet { reloadBundle() }
    }
    
    @Published var currentBundle: Bundle
    
    private init() {
        currentBundle = LanguageManager.resolveBundle(for: "auto")
    }
    
    func reloadBundle() {
        currentBundle = LanguageManager.resolveBundle(for: appLanguage)
        objectWillChange.send()
    }
    
    static func resolveBundle(for lang: String) -> Bundle {
        let resourceBundle = Bundle.module
        
        let targetLang: String
        if lang == "auto" {
            let preferred = Locale.preferredLanguages.first ?? "en"
            if preferred.hasPrefix("zh-Hans") || preferred.hasPrefix("zh-CN") {
                targetLang = "zh"
            } else {
                targetLang = "en"
            }
        } else {
            targetLang = lang
        }
        
        let candidates: [String]
        if targetLang == "zh" || targetLang == "zh-Hans" {
            candidates = ["zh-Hans", "zh-hans", "zh"]
        } else {
            candidates = ["en"]
        }
        
        for candidate in candidates {
            if let path = resourceBundle.path(forResource: candidate, ofType: "lproj"),
               let bundle = Bundle(path: path) {
                return bundle
            }
        }
        
        if let enPath = resourceBundle.path(forResource: "en", ofType: "lproj"),
           let enBundle = Bundle(path: enPath) {
            return enBundle
        }
        
        return resourceBundle
    }
    
    var displayName: String {
        switch appLanguage {
        case "zh": return "简体中文"
        case "en": return "English"
        default: return autoLanguageName
        }
    }
    
    private var autoLanguageName: String {
        let preferred = Locale.preferredLanguages.first ?? "en"
        if preferred.hasPrefix("zh") { return "自动 (简体中文)" }
        return "Auto (English)"
    }
}

/// Localization helper function
func L(_ key: String, _ args: CVarArg...) -> String {
    let bundle = LanguageManager.shared.currentBundle
    let format = NSLocalizedString(key, bundle: bundle, comment: "")
    if format == key {
        // Fallback to module bundle
        let fallback = NSLocalizedString(key, bundle: Bundle.module, comment: "")
        if !args.isEmpty && fallback != key {
            return String(format: fallback, arguments: args)
        }
        if !args.isEmpty { return String(format: format, arguments: args) }
        return format
    }
    if args.isEmpty { return format }
    return String(format: format, arguments: args)
}

/// Maps cache names to Localizable.strings keys
let cacheDescriptionKeys: [String: String] = [
    "Xcode DerivedData": "cache.desc.xcodeDerivedData",
    "Xcode Archives": "cache.desc.xcodeArchives",
    "Xcode Simulators": "cache.desc.xcodeSimulators",
    "Xcode Caches": "cache.desc.xcodeCaches",
    "Xcode Device Support": "cache.desc.xcodeDeviceSupport",
    "Xcode Logs": "cache.desc.xcodeLogs",
    "Xcode Previews": "cache.desc.xcodePreviews",
    "Simulator Caches": "cache.desc.simulatorCaches",
    "Swift PM Cache": "cache.desc.swiftPM",
    "CocoaPods Cache": "cache.desc.cocoapods",
    "Carthage": "cache.desc.carthage",
    "Homebrew Cache": "cache.desc.homebrew",
    "npm Cache": "cache.desc.npm",
    "Yarn Cache": "cache.desc.yarn",
    "pnpm Store": "cache.desc.pnpm",
    "Bun Cache": "cache.desc.bun",
    "Deno Cache": "cache.desc.deno",
    "pip Cache": "cache.desc.pip",
    "UV Cache": "cache.desc.uv",
    "Conda Packages": "cache.desc.conda",
    "Gradle Cache": "cache.desc.gradle",
    "Maven Cache": "cache.desc.maven",
    "Android Emulators": "cache.desc.androidEmulators",
    "Docker (Data)": "cache.desc.docker",
    "Terraform Plugins": "cache.desc.terraform",
    "Composer Cache": "cache.desc.composer",
    "Go Modules": "cache.desc.goModules",
    "Rust Cargo": "cache.desc.rustCargo",
    "Playwright Browsers": "cache.desc.playwright",
    "Puppeteer Browsers": "cache.desc.puppeteer",
    "Prisma Engines": "cache.desc.prisma",
    "Flutter/Pub Cache": "cache.desc.flutter",
    "JetBrains Cache": "cache.desc.jetbrains",
    "Ruby Gems": "cache.desc.rubyGems",
    "rbenv Versions": "cache.desc.rbenv",
    "mise Rubies": "cache.desc.mise",
    "RVM": "cache.desc.rvm",
    "Bundler Cache": "cache.desc.bundler",
    "Claude Desktop": "cache.desc.claudeDesktop",
    "Claude Code": "cache.desc.claudeCode",
    "HuggingFace Cache": "cache.desc.huggingface",
    "Ollama Models": "cache.desc.ollama",
    "ChatGPT Desktop": "cache.desc.chatgpt",
    "Cursor Cache": "cache.desc.cursor",
    "Windsurf Cache": "cache.desc.windsurf",
    "VS Code Cache": "cache.desc.vscodeCache",
    "VS Code Data": "cache.desc.vscodeData",
    "VS Code Extensions Cache": "cache.desc.vscodeExtensions",
    "VS Code Chromium Cache": "cache.desc.vscodeChromium",
    "VS Code Logs": "cache.desc.vscodeLogs",
]
