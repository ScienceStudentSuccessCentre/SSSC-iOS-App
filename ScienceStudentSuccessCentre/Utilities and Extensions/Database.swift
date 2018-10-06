//
//  Database.swift
//  SSSCTemp
//
//  Created by Avery Vine on 2018-09-27.
//  Copyright © 2018 Avery Vine. All rights reserved.
//

import Foundation
import SQLite
import UIKit

class Database {
    
    public static let instance = Database()
    private static let name = "ssscdb.sqlite3"
    private static let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    private let t_terms = Table("terms")
    private let t_terms_id = Expression<Int>("termId")
    private let t_terms_term = Expression<String>("term")
    private let t_terms_year = Expression<String>("year")
    
    private let t_courses = Table("courses")
    private let t_courses_id = Expression<Int>("courseId")
    private let t_courses_name = Expression<String>("name")
    private let t_courses_code = Expression<String>("code")
    private let t_courses_credits = Expression<Double>("credits")
    private let t_courses_isCGPACourse = Expression<Bool>("isCGPACourse")
    private let t_courses_termId = Expression<Int>("termId")
    private let t_courses_colour = Expression<String>("colour")
    
    private var db: Connection?
    
    private init() {
        db = try? Connection("\(Database.path)/\(Database.name)")
        if db != nil {
            print("Connected to database \(Database.name)")
            
            do {
                try db?.execute("PRAGMA foreign_keys = ON;")
            } catch let error {
                print("PRAGMA foreign_keys failed: \(error)")
            }
            
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
                t.column(t_courses_credits)
                t.column(t_courses_isCGPACourse)
                t.column(t_courses_termId)
                t.column(t_courses_colour)
                t.foreignKey(t_courses_termId, references: t_terms, t_terms_id, delete: .cascade)
            })
        } catch {
            print("Did not create courses table")
        }
    }
    
    public func insert(term: String, year: String) -> Bool {
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
    
    public func insertOrUpdate(course: Course) -> Bool {
        do {
            if course.id == -1 {
                print("Adding course \(course.name) (\(course.code)) into \(t_courses)")
                let insert = t_courses.insert(t_courses_name <- course.name,
                                              t_courses_code <- course.code,
                                              t_courses_credits <- course.credits,
                                              t_courses_isCGPACourse <- course.isCGPACourse,
                                              t_courses_termId <- course.termId,
                                              t_courses_colour <- String(describing: course.colour))
                try db?.run(insert)
            } else {
                print("Updating course \(course.name) (\(course.code)) with id \(course.id) in \(t_courses)")
                let existingCourse = t_courses.filter(t_courses_id == course.id)
                let update = existingCourse.update(t_courses_name <- course.name,
                                                   t_courses_code <- course.code,
                                                   t_courses_credits <- course.credits,
                                                   t_courses_isCGPACourse <- course.isCGPACourse,
                                                   t_courses_termId <- course.termId,
                                                   t_courses_colour <- String(describing: course.colour))
                try db?.run(update)
            }
        } catch let Result.error(message, code, _) where code == SQLITE_CONSTRAINT {
            print("Constraint failed: \(message)")
        } catch let error {
            print("Insertion failed: \(error)")
        }
        return false
    }
    
    public func delete(termId: Int) -> Bool {
        print("Deleting term \(termId) from \(t_terms)")
        let term = t_terms.filter(t_terms_id == termId)
        do {
            try db?.run(term.delete())
            print("Deleted term \(termId)")
            return true
        } catch let error {
            print("Delete failed: \(error)")
        }
        return false
    }
    
    public func delete(courseId: Int) -> Bool {
        print("Deleting course \(courseId) from \(t_courses)")
        let course = t_courses.filter(t_courses_id == courseId)
        do {
            try db?.run(course.delete())
            print("Deleted course \(courseId)")
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
                let termId = try row.get(t_terms_id)
                let term = try row.get(t_terms_term)
                let year = try row.get(t_terms_year)
                terms.append(Term(id: termId, term: term, year: year))
            }
        } catch let error {
            print("Select failed: \(error)")
        }
        print("Found \(terms.count) terms")
        return terms
    }
    
    public func getCourseById(id: Int) -> Course? {
        print("Getting course from \(t_courses) with id \(id)")
        do {
            let row = try db?.pluck(t_courses.filter(t_courses_id == id))
            if (row != nil) {
                let courseId = try row!.get(t_courses_id)
                let name = try row!.get(t_courses_name)
                let code = try row!.get(t_courses_code)
                let credits = try row!.get(t_courses_credits)
                let isCGPACourse = try row!.get(t_courses_isCGPACourse)
                let termId = try row!.get(t_courses_termId)
                let colour = UIColor.Material(rawValue: try row!.get(t_courses_colour))
                return Course(id: courseId, name: name, code: code, credits: credits, isCGPACourse: isCGPACourse, termId: termId, colour: colour)
            }
        } catch let error {
            print("Select failed: \(error)")
        }
        print("Unable to get course")
        return nil
    }
    
    public func getCoursesByTermId(id: Int) -> [Course] {
        print("Getting courses from \(t_courses) by termId \(id)")
        var courses = [Course]()
        do {
            for row in try (db?.prepare(t_courses.filter(t_courses_termId == id)))! {
                let courseId = try row.get(t_courses_id)
                let name = try row.get(t_courses_name)
                let code = try row.get(t_courses_code)
                let credits = try row.get(t_courses_credits)
                let isCGPACourse = try row.get(t_courses_isCGPACourse)
                let termId = try row.get(t_courses_termId)
                let colour = UIColor.Material(rawValue: try row.get(t_courses_colour))
                courses.append(Course(id: courseId, name: name, code: code, credits: credits, isCGPACourse: isCGPACourse, termId: termId, colour: colour))
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
