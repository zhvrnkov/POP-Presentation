# Protocol-oriented programming

1. Why do I need it? Briefly mention the following topics:
   + Stack vs. Heap
   + Reference counting
   + Method dispatch

2. How can I solve it by P.O.P?
   + How protocols work:
	 - Existential container
	 - Protocol/Value Witness Tables
	
3. Show it in action:
   + Size of protocol type and just value type
   + Existential Container in action
   + Protocol type stored properties. Indirect storage as a solution (cow)
   
4. Summary
   
5. Generic code as major and integral part of P.O.P:
   + Part of existential container in generic code
   + Compiler optimization and generic specialization in generic code
   + Protocol type generic stored properties
   
6. Summary

7. Not covered topics:
   + At which moment specialization of generics does happen
   + Whole module optimization (final, private, public in terms of compiler optimization)
   + Memory layouts for parameters in generic methods.

P.S: [source](https://developer.apple.com/videos/play/wwdc2016/416/)
