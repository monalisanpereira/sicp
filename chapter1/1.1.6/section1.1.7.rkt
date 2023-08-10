#lang sicp
#|

Exercise 1.6: Alyssa P. Hacker doesn’t see why if needs to be provided as a special form. “Why can’t I just define it as an ordinary procedure in terms of cond?” she asks. Alyssa’s friend Eva Lu Ator claims this can indeed be done, and she defines a new version of if:

(define (new-if predicate 
                then-clause 
                else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

Eva demonstrates the program for Alyssa:

(new-if (= 2 3) 0 5)
5

(new-if (= 1 1) 0 5)
0

Delighted, Alyssa uses new-if to rewrite the square-root program:

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x) x)))

What happens when Alyssa attempts to use this to compute square roots? Explain.

LISP uses applicative-order evaluation, and since `if` would no longer be a primitive operator, in `new-if` all of the operators inside the body of the procedure would be evaluated first, leading to `sqrt-iter` and `improve` being evaluated anyway.

Exercise 1.7: The good-enough? test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. This makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails for small and large numbers.

Since the tolerance for the difference is 0.001, it is either not small enough for smaller numbers or not significant for bigger numbers, causing the following behaviors:
Should return 31622776.6017
> (sqrt 1000000000000000)
(does not finish)
Should return 0.002
> (sqrt 0.000004)
0.007982415444266144

An alternative strategy for implementing good-enough? is to watch how guess changes from one iteration to the next and to stop when the change is a very small fraction of the guess. Design a square-root procedure that uses this kind of end test. Does this work better for small and large numbers? |#

(define (good-enough? guess improved-guess)
  (< (abs (- guess improved-guess)) (* guess 0.0001)))

(define (sqrt-iter guess x)
  (if (good-enough? guess (improve guess x))
       guess
       (sqrt-iter (improve guess x) x)))

#| It works better for small and large numbers.

> (sqrt 0.000004)
0.0020000003065983023
> (sqrt 1000000000000000)
31622779.27999515

Exercise 1.8: Newton’s method for cube roots is based on the fact that if y is an approximation to the cube root of x, then a better approximation is given by the value (x/y^2+2y)/3.
Use this formula to implement a cube-root procedure analogous to the square-root procedure. (In 1.3.4 we will see how to implement Newton’s method in general as an abstraction of these square-root and cube-root procedures.) |#

(define (square x)
  (* x x))

(define (cube x)
  (* x x x))

(define (improve guess x)
  (/ (+ (/ x (square guess)) (* 2 guess)) 3))

(define (good-enough? guess improved-guess)
  (< (abs (- guess improved-guess)) (* guess 0.0001)))

(define (cbrt-iter guess x)
  (if (good-enough? guess (improve guess x))
       guess
       (cbrt-iter (improve guess x) x)))

(define (cbrt x)
  (cbrt-iter 1.0 x))