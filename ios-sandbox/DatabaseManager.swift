//
//  DatabaseManager.swift
//  ios-sandbox
//
//  Created by Ross Whitehead on 26/07/2018.
//  Copyright © 2018 Ross Whitehead. All rights reserved.
//

import Foundation
import CouchbaseLiteSwift

class DatabaseManager {
    private let dbName = "db"
    private let urlString = "*****"
    private let username = "*****"
    private let password = "*****"
    
    var db:Database?
    private var replicator:Replicator?
    
    static let instance: DatabaseManager = DatabaseManager()
    
    private init() {
        initDb()
        startReplication()
    }
    
    deinit {
        // Stop observing changes to the database that affect the query
        do {
            try self.db?.close()
        }
        catch  {
        }
    }
    
    private func initDb() {
        do {
            db = try Database(name: dbName)
        } catch {
            fatalError("Error opening database")
        }
        
        // Log level
        Database.setLogLevel(.error, domain: .replicator)
        Database.setLogLevel(.verbose, domain: .network)
    }
    
    private func startReplication() {
        // Create replicators to push and pull changes to and from the cloud.
        let targetEndpoint = URLEndpoint(url: URL(string: urlString)!)
        let replConfig = ReplicatorConfiguration(database: db!, target: targetEndpoint)
        replConfig.replicatorType = .pull
        replConfig.continuous = true
    
        // Add authentication.
        replConfig.authenticator = BasicAuthenticator(username: username, password: password)
    
        // Create replicator.
        replicator = Replicator(config: replConfig)
        
        // Listen to replicator change events.
        replicator?.addChangeListener { (change) in
            if let error = change.status.error as NSError? {
                print("Error code :: \(error.code)")
            }
            
            let s = change.status
            switch s.activity {
            case .busy:
                print("Busy transferring data")
            case .connecting:
                print("Connecting to Sync Gateway")
            case .idle:
                print("Replicator in Idle state")
            case .offline:
                print("Replicator in offline state")
            case .stopped:
                print("Completed syncing documents")
            }
            
            // Workarond for BUG :https://github.com/couchbase/couchbase-lite-ios/issues/1816.
            if s.progress.completed == s.progress.total {
                print("All documents synced")
            }
            else {
                print("Documents \(s.progress.total - s.progress.completed) still pending sync")
            }
        }
        
        // Start replication.
        replicator?.start()
    }
}
