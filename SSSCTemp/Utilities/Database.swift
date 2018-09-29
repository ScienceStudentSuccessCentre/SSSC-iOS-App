//
//  Database.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import SQLite

class Database {
    
    public static let instance = Database()
    private static let name = "ssscdb.sqlite3"
    private static let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    private let t_terms = Table("terms")
    private let termId = Expression<Int64>("termId")
    private let termName = Expression<String>("termName")
    
    private var db: Connection?
    
    private init() {
        db = try? Connection("\(Database.path)/\(Database.name)")
        if db != nil {
            print("Connected to database \(Database.name)")
            
            createTermsTable()
            
            postCreationScripts()
        }
    }
    
    private func createTermsTable() {
        do {
            try db?.run(t_terms.create(ifNotExists: true) { t in
                t.column(termId, primaryKey: .autoincrement)
                t.column(termName)
            })
        } catch {
            print("Did not create terms table")
        }
    }
    
    public func addTerm(name: String) -> Bool {
        print("Adding term \(name) into \(t_terms)")
        do {
            let rowid = try db?.run(t_terms.insert(or: .replace, termName <- name))
            print("Inserted rowid \(rowid!)")
            return true
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Constraint failed: \(message), in \(statement!)")
        } catch let error {
            print("Insertion failed: \(error)")
        }
        return false
    }
    
    public func deleteTerm(id: Int) -> Bool {
        print("Deleting term \(id) from \(t_terms)")
        let term = t_terms.filter(termId == Int64(id))
        do {
            try db?.run(term.delete())
            print("Deleted term \(id)")
            return true
        } catch let error {
            print("Delete failed: \(error)")
        }
        return false
    }
    
    public func getTerms() -> [Term] {
        print("Getting terms from \(t_terms)")
        var terms = [Term]()
        do {
            for term in try (db?.prepare(t_terms))! {
                let tId = try term.get(termId)
                let tName = try term.get(termName)
                terms.append(Term(id: tId, name: tName))
            }
        } catch let error {
            print("Select failed: \(error)")
        }
        print("Found \(terms.count) terms")
        return terms
    }
    
    private func postCreationScripts() {
        // any custom scripts that should be run while developing/testing/debugging
    }
    
}
