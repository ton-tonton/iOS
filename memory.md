#Managing Memory

##The Stack
- A part of memory called **_stack_**
- When method is executed, a chunk of memory is allocated from stack.
- Call **_frame_**.
- Frame store value for variables.
- LIFO
- Example
> `main()` run.
> The *main frame* put to stack.
> `main()` call `method()`.
> *method frame* put to stack.
> `method()` finished, pop off *method frame* and destroyed.
> `main()` finished, pop off *main frame* and destroyed.


##The Heap
- A part of memory called **_heap_**
- Dynamic allocation
- Store Objective-C Object.
- use pointer to track where object are stored in the heap.

[appledev](https://developer.apple.com/library/ios/navigation/)