/*:
 > # IMPORTANT: To use **Rx.playground**:
 1. Open **Rx.xcworkspace**.
 1. Build the **RxSwift-macOS** scheme (**Product** → **Build**).
 1. Open **Rx** playground in the **Project navigator**.
 1. Show the Debug Area (**View** → **Debug Area** → **Show Debug Area**).
 ----
 ## Table of Contents:
 1. [Introduction](Introduction)
 1. [Creating and Subscribing to Observables](Creating_and_Subscribing_to_Observables)
 1. [Working with Subjects](Working_with_Subjects)
 1. [Combining Operators](Combining_Operators)
 1. [Transforming Operators](Transforming_Operators)
 1. [Filtering and Conditional Operators](Filtering_and_Conditional_Operators)
 1. [Mathematical and Aggregate Operators](Mathematical_and_Aggregate_Operators)
 1. [Connectable Operators](Connectable_Operators)
 1. [Error Handling Operators](Error_Handling_Operators)
 1. [Debugging Operators](Debugging_Operators)
 */

//: [Next](@next)
import RxSwift

enum MyError: Error {
    case anError
}
// 2
func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}

extension Observable {
    func sub() {
        let bag = DisposeBag()
        return self.subscribe({print($0)}).disposed(by: bag)
    }
}

let exampleIntOb = Observable.of(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
let exampleStringOb = Observable.of("A", "B", "C", "D", "E", "F", "G", "H")

example("toArray") {
    exampleStringOb.toArray().sub()
}

example("map") {
    exampleIntOb.map({$0 * 2}).sub()
}

example("mapWithIndex") {
    exampleStringOb.enumerated().map({ (index, element) -> String in
        return index % 2 == 0 ? element : element + "suffix"
    }).sub()
}

struct Student {
    var score: Variable<Int>
}

example("flatmap") {

    let disposeBag = DisposeBag()
    // 1
    let ryan = Student(score: Variable(80))
    let charlotte = Student(score: Variable(90))
    // 2
    let student = PublishSubject<Student>()
    // 3
    student.asObservable()
        .flatMap {
            $0.score.asObservable()
        }
        // 4
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
    student.onNext(ryan)
    ryan.score.value = 85
    student.onNext(charlotte)
}

example("flatMapLatest") {
    let disposebag = DisposeBag()
    let ryan = Student(score: Variable(80))
    let charlotte = Student(score: Variable(90))
    let student = PublishSubject<Student>()
    student.asObservable().flatMapLatest({ $0.score.asObservable() }).subscribe(onNext: { (score) in
        print("Score", score)
    }).disposed(by: disposebag)
    student.onNext(ryan)
    ryan.score.value = 85
    student.onNext(charlotte)
    // 1
    ryan.score.value = 95
    charlotte.score.value = 100
}
