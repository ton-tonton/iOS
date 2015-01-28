#Managing Memory

##The Stack
- A part of memory called **_stack_**
- When method is executed, a chunk of memory is allocated from stack.
- Call **_frame_**.
- Frame store value for variables.
- LIFO
- Example
    * `main()` run.
    * The *main frame* put to stack.
    * `main()` call `method()`.
    * *method frame* put to stack.
    * `method()` finished, pop off *method frame* and destroyed.
    * `main()` finished, pop off *main frame* and destroyed.


##The Heap
- A part of memory called **_heap_**
- Dynamic allocation
- Store Objective-C Object.
- use pointer to track where object are stored in the heap.

---

#View Controller

###loadView
- Overridden to create a view controller's view.

###viewDidLoad
- Overridden to configure views created by loading a NIB file.
- Called after the view of a view controller is created.
- Run one time.

###viewWillAppear
- Overridden to configure views created by loading a NIB file.
- Called every time your view controller is moved on screen.

###viewWillDisappear
- Overridden to set properties before view poped off.
- Called every time your view controller is move off screen.
