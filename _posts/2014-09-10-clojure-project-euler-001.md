---
layout: post
title: "Project Euler: Problem 1"
description: "My attempt at solving Project Euler's problem #1 using Clojure"

tags: [clojure, programming, project euler]
comments: true
---

**Multiples of 3 and 5**  
If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.  
Find the sum of all the multiples of 3 or 5 below 1000.
{: .notice}

From my [Fizz Buzz in Clojure](/2014/09/03/clojure-fizzbuzz/) post, I knew that getting the range of numbers below 1000 was as easy as
{% highlight Clojure %}
(range 1 1000)
{% endhighlight %}

I also knew that I'd need a function that would test whether or not a number is divisible by 3 or 5.

{% highlight Clojure %}
(defn is-multiple? [n]
    (when 
       (zero? (or (rem n 3) (rem n 5))) n))
{% endhighlight %}

I thought I'd need to explicitly return the numbers that were divisible by 3 or by 5. Hence the use of `(when)`. Sure enough calling `(is-multiple? 2)` returned `nil`, and calling `(is-multiple 3)` returned `3`. So far, so good. Then of course, I called `(is-multiple? 5)`. I expected `5`, but got `nil`. So what's going on there?

As per the docs for `or`:

> "Evaluates exprs one at a time, from left to right. If a form
  returns a **logical true** value, or returns that value and doesn't
  evaluate any of the other expressions, otherwise it returns the
  value of the last expression. (or) returns nil."

So in the case where I was passing 5 to `(is-multiple?)`, the `or` looked like

{% highlight Clojure %}
(zero? (or (rem 5 3) (rem 5 5)))

;; ...which evaluates to
(zero? (or 2 0))

;; ...which evaluates to 
(zero? 2)

;; ...which evaluates to
false
{% endhighlight %}

In fact, my `(is-multiple)` would only ever return a number for multiples of 3. In those cases the 0 from evaluating `(rem n 3)` would be returned from the `(or)` to `(zero?)`, and return true.

**Takeaway**: 0 is a _logical true_ value in Clojure. The only _logical false_ values are `nil` and `false`.
{: .notice}

So I needed to change my `(is-multiple)` function, and came up with

{% highlight Clojure %}
(defn is-multiple? [n]
    (when 
       (or (zero? (rem n 3)) (zero? (rem n 5))) n))
{% endhighlight %}

This function worked as expected, returning `3` or `5` for multiples of 3 or 5, and `nil` for any other number.

Moving ahead, the following

{% highlight Clojure %}
(map is-multiple? (range 1 10))
{% endhighlight %}

yielded: `(nil nil 3 nil 5 6 nil nil 9)`

Based on the problem definition, this looked correct. Now I just needed to add them together. `(apply +)` should work.

{% highlight Clojure %}
(apply + (map is-multiple? (range 1 10)))
{% endhighlight %}

However, that yields a big fat NPE. Apparently `nil` is not compatible with Clojure's `(+)` function. I thought it might have been coerced to zero, but that's incorrect.

Hm... what about

{% highlight Clojure %}
(filter is-multiple? (range 1 10))
{% endhighlight %}

yielded: `(3 5 6 9)`

Much better. And in fact

{% highlight Clojure %}
(apply + (filter is-multiple? (range 1 10)))
{% endhighlight %}

yielded 23, which we know is the correct answer.

But now that I'm using `(filter)` as opposed to `(map)`, it occurs to me that I can clean up the `(is-multiple?)` function. I don't need to return the number when it's divisible to 3 or 5. I just need to return `true` or `false` in all cases. So I refactored `(is-multiple?)` a bit.

{% highlight Clojure %}
(defn is-multiple? [n]
    (or (zero? (rem n 3)) (zero? (rem n 5))))
{% endhighlight %}

I don't like the fact that I'm testing for `(zero?)` twice. I'm certain there's a more concise way to do that, but I have yet to think of it.

The final implementation (also available as a [Gist](https://gist.github.com/charliegriefer/b14765423a7ec5f400cf)):

{% highlight Clojure %}
(defn is-multiple? [n]
  (or (zero? (rem n 3)) (zero? (rem n 5))))
 
(apply + (filter is-multiple? (range 1 1000)))

;; => 233168
{% endhighlight %}