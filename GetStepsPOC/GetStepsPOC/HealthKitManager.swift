//
//  HealthKitManager.swift
//  HealthKitStepsDemo
//
//  Created by Natasha Murashev on 10/20/14.
//  Copyright (c) 2014 NatashaTheRobot. All rights reserved.
//

import HealthKit

class HealthKitManager {
    
    class var sharedInstance: HealthKitManager {
        struct Singleton {
            static let instance = HealthKitManager()
        }
        
        return Singleton.instance
    }
    
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()
    
    let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    let stepsUnit = HKUnit.count()
    let distanceValue = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
}
