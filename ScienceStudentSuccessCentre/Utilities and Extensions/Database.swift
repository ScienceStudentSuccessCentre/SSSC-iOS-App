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
    private let t_courses_finalGrade = Expression<String>("finalGrade")
    private let t_courses_termId = Expression<Int>("termId")
    private let t_courses_colour = Expression<String>("colour")
    
    private let t_assignments = Table("assignments")
    private let t_assignments_id = Expression<Int>("assignmentId")
    private let t_assignments_name = Expression<String>("name")
    private let t_assignments_gradeEarned = Expression<Double>("gradeEarned")
    private let t_assignments_gradeTotal = Expression<Double>("gradeTotal")
    private let t_assignments_weight = Expression<Double>("weight")
    private let t_assignments_courseId = Expression<Int>("courseId")
    
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
            createAssignmentsTable()
            
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
                t.column(t_courses_finalGrade)
                t.column(t_courses_termId)
                t.column(t_courses_colour)
                t.foreignKey(t_courses_termId, references: t_terms, t_terms_id, delete: .cascade)
            })
        } catch {
            print("Did not create courses table")
        }
    }
    
    private func createAssignmentsTable() {
        do {
            try db?.run(t_assignments.create(ifNotExists: true) { t in
                t.column(t_assignments_id, primaryKey: .autoincrement)
                t.column(t_assignments_name)
                t.column(t_assignments_gradeEarned)
                t.column(t_assignments_gradeTotal)
                t.column(t_assignments_weight)
                t.column(t_assignments_courseId)
                t.foreignKey(t_assignments_courseId, references: t_courses, t_courses_id, delete: .cascade)
            })
        } catch {
            print("Did not create assignments table")
        }
    }
    
    public func insert(term: String, year: String) -> Bool {
        print("Adding term \(term) \(year) into \(t_terms)")
        do {
            let rowid = try db?.run(t_terms.insert(or: .replace,
                                                   t_terms_term <- term,
                                                   t_terms_year <- year))
            print("Inserted rowid \(rowid!)")
        } catch let Result.error(message, code, _) where code == SQLITE_CONSTRAINT {
            print("Constraint failed: \(message)")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
        return true
    }
    
    public func insertOrUpdate(course: Course) -> Bool {
        do {
            if course.id == -1 {
                print("Adding course \(course.name) (\(course.code)) into \(t_courses)")
                let insert = t_courses.insert(t_courses_name <- course.name,
                                              t_courses_code <- course.code,
                                              t_courses_credits <- course.credits,
                                              t_courses_isCGPACourse <- course.isCGPACourse,
                                              t_courses_finalGrade <- course.finalGrade,
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
                                                   t_courses_finalGrade <- course.finalGrade,
                                                   t_courses_termId <- course.termId,
                                                   t_courses_colour <- String(describing: course.colour))
                try db?.run(update)
            }
        } catch let Result.error(message, code, _) where code == SQLITE_CONSTRAINT {
            print("Constraint failed: \(message)")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
        return true
    }
    
    public func insertOrUpdate(assignment: Assignment) -> Bool {
        do {
            if assignment.id == -1 {
                print("Adding assignment \(assignment.name) (\(assignment.gradeEarned), \(assignment.gradeTotal), \(assignment.weight)) into \(t_assignments)")
                let insert = t_assignments.insert(t_assignments_name <- assignment.name,
                                                   t_assignments_gradeEarned <- assignment.gradeEarned,
                                                   t_assignments_gradeTotal <- assignment.gradeTotal,
                                                   t_assignments_weight <- assignment.weight,
                                                   t_assignments_courseId <- assignment.courseId)
                try db?.run(insert)
            } else {
                print("Updating assignment \(assignment.name) (\(assignment.gradeEarned), \(assignment.gradeTotal), \(assignment.weight)) with id \(assignment.id) in \(t_assignments)")
                let existingAssignment = t_assignments.filter(t_assignments_id == assignment.id)
                let update = existingAssignment.update(t_assignments_name <- assignment.name,
                                                       t_assignments_gradeEarned <- assignment.gradeEarned,
                                                       t_assignments_gradeTotal <- assignment.gradeTotal,
                                                       t_assignments_weight <- assignment.weight,
                                                       t_assignments_courseId <- assignment.courseId)
                try db?.run(update)
            }
        } catch let Result.error(message, code, _) where code == SQLITE_CONSTRAINT {
            print("Constraint failed: \(message)")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
        return true
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
    
    public func delete(assignmentId: Int) -> Bool {
        print("Deleting assignment \(assignmentId) from \(t_assignments)")
        let assignment = t_assignments.filter(t_assignments_id == assignmentId)
        do {
            try db?.run(assignment.delete())
            print("Deleted assignment \(assignmentId)")
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
                let finalGrade = try row!.get(t_courses_finalGrade)
                let termId = try row!.get(t_courses_termId)
                let colour = UIColor.Material(rawValue: try row!.get(t_courses_colour))
                return Course(id: courseId, name: name, code: code, credits: credits, isCGPACourse: isCGPACourse, finalGrade: finalGrade, termId: termId, colour: colour)
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
                let finalGrade = try row.get(t_courses_finalGrade)
                let termId = try row.get(t_courses_termId)
                let colour = UIColor.Material(rawValue: try row.get(t_courses_colour))
                courses.append(Course(id: courseId, name: name, code: code, credits: credits, isCGPACourse: isCGPACourse, finalGrade: finalGrade, termId: termId, colour: colour))
            }
        } catch let error {
            print("Select failed: \(error)")
        }
        print("Found \(courses.count) courses")
        return courses
    }
    
    public func getAssignmentsByCourseId(id: Int) -> [Assignment] {
        print("Getting assignments from \(t_assignments) by courseId \(id)")
        var assignments = [Assignment]()
        do {
            for row in try (db?.prepare(t_assignments.filter(t_assignments_courseId == id)))! {
                let assignmentId = try row.get(t_assignments_id)
                let name = try row.get(t_assignments_name)
                let gradeEarned = try row.get(t_assignments_gradeEarned)
                let gradeTotal = try row.get(t_assignments_gradeTotal)
                let weight = try row.get(t_assignments_weight)
                let courseId = try row.get(t_assignments_courseId)
                assignments.append(Assignment(id: assignmentId, name: name, gradeEarned: gradeEarned, gradeTotal: gradeTotal, weight: weight, courseId: courseId))
            }
        } catch let error {
            print("Select failed: \(error)")
        }
        print("Found \(assignments.count) assignments")
        return assignments
    }
    
    private func preCreationScripts() {
        // any custom scripts that should be run while developing/testing/debugging BEFORE creating tables
    }
    
    private func postCreationScripts() {
        // any custom scripts that should be run while developing/testing/debugging AFTER creating tables
    }
    
}
