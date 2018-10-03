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
    
    private let t_courses = Table("courses")
    private let t_courses_id = Expression<Int64>("courseId")
    private let t_courses_name = Expression<String>("name")
    private let t_courses_code = Expression<String>("code")
    private let t_courses_isCGPACourse = Expression<Bool>("isCGPACourse")
    private let t_courses_termId = Expression<Int64>("termId")
    
    private var db: Connection?
    
    private init() {
        db = try? Connection("\(Database.path)/\(Database.name)")
        if db != nil {
            print("Connected to database \(Database.name)")
            
            preCreationScripts()
            
            createTermsTable()
            createCoursesTable()
            
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
    
    private func createCoursesTable() {
        do {
            try db?.run(t_courses.create(ifNotExists: true) { t in
                t.column(t_courses_id, primaryKey: .autoincrement)
                t.column(t_courses_name)
                t.column(t_courses_code)
                t.column(t_courses_isCGPACourse)
                t.column(t_courses_termId)
                t.foreignKey(t_courses_termId, references: t_terms, t_terms_id, delete: .setNull)
            })
        } catch {
            print("Did not create courses table")
        }
    }
    
    public func addTerm(term: String, year: String) -> Bool {
        print("Adding term \(term) \(year) into \(t_terms)")
        do {
            let rowid = try db?.run(t_terms.insert(or: .replace,
                                                   t_terms_term <- term,
                                                   t_terms_year <- year))
            print("Inserted rowid \(rowid!)")
            return true
        } catch let Result.error(message, code, _) where code == SQLITE_CONSTRAINT {
            print("Constraint failed: \(message)")
        } catch let error {
            print("Insertion failed: \(error)")
        }
        return false
    }
    
    public func addCourse(name: String, code: String, isCGPACourse: Bool, termId: Int) -> Bool {
        print("Adding course \(name) (\(code)) into \(t_courses)")
        do {
            let rowid = try db?.run(t_courses.insert(or: .replace,
                                                     t_courses_name <- name,
                                                     t_courses_code <- code,
                                                     t_courses_isCGPACourse <- isCGPACourse,
                                                     t_courses_termId <- Int64(termId)))
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
    
    public func deleteCourse(id: Int) -> Bool {
        print("Deleting course \(id) from \(t_courses)")
        let course = t_courses.filter(t_courses_id == Int64(id))
        do {
            try db?.run(course.delete())
            print("Deleted course \(id)")
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
    
    public func getCourses() -> [Course] {
        print("Getting courses from \(t_courses)")
        var courses = [Course]()
        do {
            for row in try (db?.prepare(t_courses))! {
                let id = try row.get(t_courses_id)
                let name = try row.get(t_courses_name)
                let code = try row.get(t_courses_code)
                let isCGPACourse = try row.get(t_courses_isCGPACourse)
                let termId = try row.get(t_courses_termId)
                courses.append(Course(id: id, name: name, code: code, isCGPACourse: isCGPACourse))
            }
        } catch let error {
            print("Select failed: \(error)")
        }
        print("Found \(courses.count) courses")
        return courses
    }
    
    private func preCreationScripts() {
        // any custom scripts that should be run while developing/testing/debugging BEFORE creating tables
    }
    
    private func postCreationScripts() {
        // any custom scripts that should be run while developing/testing/debugging AFTER creating tables
    }
    
}
