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
    private let t_terms_id = Expression<Int64>("termId")
    private let t_terms_term = Expression<String>("term")
    private let t_terms_year = Expression<String>("year")
    
    private var db: Connection?
    
    private init() {
        db = try? Connection("\(Database.path)/\(Database.name)")
        if db != nil {
            print("Connected to database \(Database.name)")
            
            preCreationScripts()
            
            createTermsTable()
            
            postCreationScripts()
        }
    }
    
    private func createTermsTable() {
        do {
            try db?.run(t_terms.create(ifNotExists: true) { t in
                t.column(t_terms_id, primaryKey: .autoincrement)
                t.column(t_terms_term)
                t.column(t_terms_year)
            })
        } catch {
            print("Did not create terms table")
        }
    }
    
    public func addTerm(term: String, year: String) -> Bool {
        print("Adding term \(term) \(year) into \(t_terms)")
        do {
            let rowid = try db?.run(t_terms.insert(or: .replace, t_terms_term <- term, t_terms_year <- year))
            print("Inserted rowid \(rowid!)")
            return true
        } catch let Result.error(message, code, _) where code == SQLITE_CONSTRAINT {
            print("Constraint failed: \(message)")
        } catch let error {
            print("Insertion failed: \(error)")
        }
        return false
    }
    
    public func deleteTerm(id: Int) -> Bool {
        print("Deleting term \(id) from \(t_terms)")
        let term = t_terms.filter(t_terms_id == Int64(id))
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
            for row in try (db?.prepare(t_terms))! {
                let id = try row.get(t_terms_id)
                let term = try row.get(t_terms_term)
                let year = try row.get(t_terms_year)
                terms.append(Term(id: id, term: term, year: year))
            }
        } catch let error {
            print("Select failed: \(error)")
        }
        print("Found \(terms.count) terms")
        return terms
    }
    
    private func preCreationScripts() {
        // any custom scripts that should be run while developing/testing/debugging BEFORE creating tables
    }
    
    private func postCreationScripts() {
        // any custom scripts that should be run while developing/testing/debugging AFTER creating tables
    }
    
}
