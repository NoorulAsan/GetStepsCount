//
//  ViewController.swift
//  GetStepsPOC
//
//  Created by MacMini on 15/03/18.
//  Copyright © 2018 MacMini. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    fileprivate let healthKitManager = HealthKitManager.sharedInstance
    
    fileprivate var steps = [HKQuantitySample]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let startDate = convert_start_date(date_val: NSDate())
        let endDate = convert_end_date(date_val: NSDate())
        self.requestHealthKitAuthorization(start_date: startDate, end_date: endDate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func requestHealthKitAuthorization(start_date: NSDate, end_date: NSDate) {
        //let dataTypesToRead = NSSet(objects: healthKitManager.stepsCount as Any)
        let dataTypesToRead = NSSet(objects: healthKitManager.stepsCount as Any, healthKitManager.distanceValue as Any)
        healthKitManager.healthStore?.requestAuthorization(toShare: nil, read: dataTypesToRead as? Set<HKObjectType>, completion: {(success, error) in
            if success {
                self.get_the_steps(start_date: start_date, end_date: end_date)
                self.get_distance(start_date: start_date, end_date: end_date)
            } else {
                print(error.debugDescription)
            }
        })
    }
    
    func get_the_steps(start_date: NSDate, end_date: NSDate) {
        guard let type = HKSampleType.quantityType(forIdentifier: .stepCount) else {
            fatalError("Something went wrong retriebing quantity type StepCount")
        }
        let predicate = HKQuery.predicateForSamples(withStart: start_date as Date, end: end_date as Date, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
            var value: Double = 0
            if error != nil {
                print("something went wrong")
                print("\(start_date): Steps = \(value)")
            } else if let quantity = statistics?.sumQuantity() {
                let date_co = statistics?.startDate
                let date_str = self.convert_date_to_date(date_val: date_co! as NSDate)
                value = quantity.doubleValue(for: HKUnit.count())
                print("\(date_str): Steps = \(value)")
            }
        }
        healthKitManager.healthStore?.execute(query)
    }
    
    func get_distance(start_date: NSDate, end_date: NSDate) {
        guard let type = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            fatalError("Something went wrong retriebing quantity type distanceWalkingRunning")
        }
        let predicate = HKQuery.predicateForSamples(withStart: start_date as Date, end: end_date as Date, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
            var value: Double = 0
            if error != nil {
                print("something went wrong")
                print("\(start_date): distance = \(value)")
            } else if let quantity = statistics?.sumQuantity() {
                let date_co = statistics?.startDate
                let date_str = self.convert_date_to_date(date_val: date_co! as NSDate)
                value = quantity.doubleValue(for: HKUnit.mile())
                print("\(date_str): distance = \(value)")
            }
        }
        healthKitManager.healthStore?.execute(query)
    }
    
    func convert_date_to_date(date_val: NSDate) -> String
    {
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "dd-MM-yyyy"
        let str_time_val = "\(timeFormatter.string(from: date_val as Date))"
        return str_time_val
    }
    
    func convert_start_date(date_val: NSDate) -> NSDate
    {
        let timeFormatter = DateFormatter()
        //timeFormatter.dateFormat = "dd-MM-yyyy"
        //let str_date = "\(timeFormatter.string(from: date_val as Date)), 00:00"
        let str_date = "16-03-2018, 00:00:00"
        
        timeFormatter.dateFormat = "dd-MM-yyyy, HH:mm:ss"
        let date_calc = timeFormatter.date(from: str_date)
        return date_calc! as NSDate
    }
    
    func convert_end_date(date_val: NSDate) -> NSDate
    {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "dd-MM-yyyy"
        //let str_date = "\(timeFormatter.string(from: date_val as Date)), 00:00"
        let str_date = "16-03-2018, 23:59:59"
        
        timeFormatter.dateFormat = "dd-MM-yyyy, HH:mm:ss"
        let date_calc = timeFormatter.date(from: str_date)
        return date_calc! as NSDate
    }
}


