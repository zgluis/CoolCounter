//
//  CounterWorker.swift
//  CoolCounter
//
//  Created by Luis Zapata on 05-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit
import CoreData

protocol CounterWorkerProtocol {
    func getRemoteCounters(_ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void)
    func getLocalCounters(_ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void)
    func incrementCount(request: CounterModel.Increment.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void)
    func decrementCount(request: CounterModel.Decrement.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void)
    func deleteCounter(request: CounterModel.Delete.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void)
    func deleteLocalCounters(countersIds: [String])
    func createCounter(request: CounterModel.Create.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void)
    func storeCounter(counter: CounterModel.Counter)
    func updateLocalCounter(counter: CounterModel.Counter, increment: Bool)
}

class CounterWorker: CounterWorkerProtocol {

    func getRemoteCounters(_ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void) {
        requestHandler.get(resource: "counters", completion: completion)
    }

    func getLocalCounters(_ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void) {
        guard let managedContext = CounterWorker.getManagedContext() else {
            completion(.failure(AppError(id: .coreData)))
            return
        }
        managedContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CounterModel.counterEntityName)
                if let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                    var arr: [CounterModel.Counter] = []
                    for data in result {
                        arr.append(CounterModel.Counter(id: data.value(forKey: "id") as? String ?? "",
                                                        title: data.value(forKey: "title") as? String ?? "",
                                                        count: data.value(forKey: "count") as? Int ?? 0))
                    }
                    if arr.count > 0 {
                        completion(.success(arr))
                    } else {
                        completion(.failure(AppError(id: .noData)))
                    }
                } else {
                    completion(.failure(AppError(id: .coreData)))
                }
            } catch {
                completion(.failure(AppError(id: .coreData)))
            }
        }
    }

    func incrementCount(request: CounterModel.Increment.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void) {
        requestHandler.post(resource: "counter/inc", parameters: request.toParameters(), completion: completion)
    }

    func decrementCount(request: CounterModel.Decrement.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void) {
        requestHandler.post(resource: "counter/dec", parameters: request.toParameters(), completion: completion)
    }

    func deleteCounter(request: CounterModel.Delete.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void) {
        requestHandler.delete(resource: "counter", parameters: request.toParameters(), completion: completion)
    }

    func createCounter(request: CounterModel.Create.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void) {
        requestHandler.post(resource: "counter", parameters: request.toParameters(), completion: completion)
    }

    func deleteLocalCounters(countersIds: [String]) {
        guard let managedContext = CounterWorker.getManagedContext() else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CounterModel.counterEntityName)
        fetchRequest.predicate = NSPredicate(format: "id IN %@", countersIds)

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        do {
            try managedContext.executeAndMergeChanges(using: deleteRequest)
        } catch let error as NSError {
            print("Delete failed \(error.userInfo)")
        }
    }

    func storeCounter(counter: CounterModel.Counter) {
        guard let managedContext = CounterWorker.getManagedContext() else { return }
        if let counterEntity = NSEntityDescription.entity(forEntityName: CounterModel.counterEntityName, in: managedContext) {
            let counterManagedObj = NSManagedObject(entity: counterEntity, insertInto: managedContext)
            counterManagedObj.setValue(Int64(Date().timeIntervalSince1970 * 1000), forKey: "createdAt")
            counterManagedObj.setValue(counter.count, forKey: "count")
            counterManagedObj.setValue(counter.id, forKey: "id")
            counterManagedObj.setValue(counter.title, forKey: "title")
            do {
                try managedContext.save()
            } catch let error {
                print("[CoreData error] \(error)")
            }
        }
    }

    func updateLocalCounter(counter: CounterModel.Counter, increment: Bool) {
        guard let managedContext = CounterWorker.getManagedContext() else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CounterModel.counterEntityName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", counter.id)
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                if result.count > 0 {
                    let counterManagedObj = result[0]
                    counterManagedObj.setValue(increment ? counter.count + 1 : counter.count - 1, forKey: "count")
                    try managedContext.save()
                }
            }
        } catch let error {
            print("[CoreData error] \(error)")
        }
    }

    private class func getManagedContext() -> NSManagedObjectContext? {
        let appDelegate: AppDelegate?
        if Thread.current.isMainThread {
            appDelegate = UIApplication.shared.delegate as? AppDelegate

        } else {
            appDelegate = DispatchQueue.main.sync {
                return UIApplication.shared.delegate as? AppDelegate
            }
        }
        return appDelegate?.backgroundContext
    }

}
