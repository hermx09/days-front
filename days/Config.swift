struct Config {
    
    static let localIP = "192.168.86.79"
    
    #if targetEnvironment(simulator)
    static let baseURL = "http://localhost:3000"
    #else
    static let baseURL = "http://\(localIP):3000"
    #endif
}
