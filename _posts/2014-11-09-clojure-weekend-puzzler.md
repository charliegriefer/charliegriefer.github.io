---
layout: post
title: "A Clojure Weekend Puzzler"
description: "A coding challenge is issued. This is my response."

tags: [clojure]
comments: true
---

On Friday morning, I was fortunate (?) enough to come across a [blog post by Adam Cameron](http://blog.adamcameron.me/2014/11/something-for-weekend-wee-code-quiz-in.html) in which he issued the following coding challenge:

> For a given array and a given threshold, return the subarray which contains the longest run of consecutive numbers which - in total - are equal-to or less than the threshold. For example:

    series = [100, 300, 100, 50, 50, 50, 50, 50, 500, 200, 100]
    threshold = 500
    subseries = getSubseries(series,threshold) // [100, 50, 50, 50, 50, 50]

By the time I saw the article, there were already answers for CMFL, Python, and Go. Of course, I chose to go with Clojure.

As a quick "out" for those that just want to see the code, you can see my solution as [a gist](https://gist.github.com/charliegriefer/3980e519ddbe6d04d297), or if you're really curious, [a full github project/repo](https://github.com/charliegriefer/cameron141107).

For those of you that are inclined to stay, I'm going to do my best to break down the Clojure code.

From a 30,000 foot perspective, I needed to do the following:

- from the first element, start summing the elements of the vector up until the threshold was met and not exceeded
- take note of how many elements it took to reach the threshold
- drop the first element of the vector, and repeat the process
- once the vector has been exhausted, find the longest sequence and return it

I knew that I could use [`(reduce)`](https://clojuredocs.org/clojure.core/reduce) to get the sum of the vector elements:

{% highlight Clojure %}
(def series [100 300 100 50 50 50 50 50 500 200 100])
(reduce + series) ;; 1550
{% endhighlight %}

But what I really need is how many times `(reduce)` had to run. My non-functional brain immediately went to thinking about loops and counters and storing values in variables. But of course, Clojure eliminates the need for that. It didn't take long for me to come across [`(reductions)`](https://clojuredocs.org/clojure.core/reductions). As per the docs:

> Returns a lazy seq of the intermediate values of the reduction (as
per reduce) of coll by f, starting with init.

{% highlight Clojure %}(reductions + series) ;; (100 400 500 550 600 650 700 750 1250 1450 1550){% endhighlight %}

That's great, but I only need the reductions up to the threshold. I remember that [`(take)`](https://clojuredocs.org/clojure.core/take) returns a specified subset of a collection. For example:

{% highlight Clojure %}(take 3 '(100 200 300 400 500)) ;; (100 200 300){% endhighlight %}

But I don't know how many element I'll need. Forutnately, in addition to `(take)`, there's [`(take-while)`](https://clojuredocs.org/clojure.core/take-while), which returns elements from a collection while `pred` is true. I need to pass `(take-while)` a predicate function that ensures the value is less-than-or-equal-to the specified threshold.

{% highlight Clojure %}(take-while (partial >= threshold) (reductions + series)) ;; (100 400 500){% endhighlight %}

Progress. Now I know that it took 3 reductions of `(+)` across `series` before the threshold was met or exceeded. In order to return 3, I just add [`(count)`](https://clojuredocs.org/clojure.core/count) to my existing code:

{% highlight Clojure %}(count (take-while (partial >= threshold) (reductions + series))) ;; 3 {% endhighlight %}

Before going any further, let's discuss the use of [`(partial)`](https://clojuredocs.org/clojure.core/partial) in the code above. `(partial`) takes a function and fewer than normal arguments to that function. Remember that in Clojure, everything is a function. `[(>=)](https://clojuredocs.org/clojure.core/%3E=)` is a function that generally expects 2 characters.

{% highlight Clojure %}
(>= 10 20) ;; false
(>= 20 10) ;; true
{% endhighlight %}

`(partial >= threshold)` is essentially a function that could be named "is-argument-less-than-or-equal-to-threshold?", and will be used as such.

I now know that given the original collection, it takes 3 reductions before reaching the threshold. What I need to do now is drop the first element of the collection, and see how many reductions it takes before reaching the threshold. I need to repeat this process until the original collection is exhausted.

I had found a "recursive map" function in a Stack Overflow answer. But after posting my gist, I got a comment from [Steve Miner](https://github.com/miner) showing a much improved method. Steve's well-known within the Clojure community. I truly appreciate that he took the time to check out the code and offer up this improvement:

{% highlight Clojure %}(defn map-rest [f coll] (map f (take-while seq (iterate rest coll)))){% endhighlight %}

You can see my original version in the [gist revision history](https://gist.github.com/charliegriefer/3980e519ddbe6d04d297/revisions). I won't go into it here, but will say that using explicit recursion is generally frowned upon in Clojure. Steve's version is much more efficient, as well as being elegant and concise.

Steve's version takes two arguments, a function and a collection. It then maps the function over the collection recursively. `(iterate rest coll)` is the key to avoiding the explicit recursion. In conjunction with `(take-while seq ... )` it generates a sequence as follows:

{% highlight Clojure %}(take-while seq (iterate rest '(1 2 3 4 5))) ;; ((1 2 3 4 5) (2 3 4 5) (3 4 5) (4 5) (5)){% endhighlight %}

At this point, I think it's easy enough to explain the solution in its entirety.

{% highlight Clojure %}
(defn map-rest [f coll] (map f (take-while seq (iterate rest coll))))

(defn get-subseries
  "For a given series, return a vector which contains the longest run of consecutive numbers 
   which - in total - are equal-to or less than the threshold."
  [s t]
  (if (empty? s)
      []
      (let [get-count-until-threshold (fn [series] 
                                        (count (take-while (partial >= t)
                                                           (reductions + series))))
            counts (map-rest get-count-until-threshold s)
            max-num (apply max counts)
            max-index (.indexOf counts max-num)]
       (subvec s max-index (+ max-index max-num)))))
{% endhighlight %}

`(get-subseries)` takes a sequence (the original array) and a threshold. If the array is empty, simply return an empty vector. Otherwise...

1. Define a function-local _function_ named `(get-count-until-threshold)`. This is the first issue that I discussed above. The function takes a series, and returns the count of reductions that it took to reach the threshold while applying `+` to the series.
2. Define a function-local _variable_ `counts` that calls `(map-rest)` (discussed above) passing the function described in item #1 above, and the vector. Given the series `[100 300 100 50 50 50 50 50 500 200 100]` and the threshold `500`, `counts` becomes `(3 4 6 5 4 3 2 1 1 2 1)`. I now know that the longest sequence that does not sum to more than 500 is 6 elements long.
3. Use Clojure's built-in [`(max)`](https://clojuredocs.org/clojure.core/max) function in conjunction with [`(apply)`](https://clojuredocs.org/clojure.core/apply) in order to determine the longest sequence that meets our requirements. (The need for `(apply)` here is actually explained in [an example on `(apply)`'s docs page](https://clojuredocs.org/clojure.core/apply#example_542692cdc026201cdc326d49)).
4. A bit of Java interop makes use of `.indexOf` to determine where in the sequence the max number resides. 
5. With the let-bindings done, use [`(subvec)`](https://clojuredocs.org/clojure.core/subvec) to return the solution. `(subvec)`, in this case, takes 3 arguments: _v_, _start_, and _end_:
- _v_: An existing vector. In this case, the original series/vector.
- _start_: This is what I defined as `max-index`. It's the element in the vector from which the longest series was generated before exceeding the specified threshold.
- _end_: An optional argument to `(subvec)`. In this case I start at `max-index`, and end at `max-index` + `max-num`. Or in Clojure syntax, `(+ max-index max-num)`.

All of which finally leads to:

{% highlight Clojure %}
(def series [100 300 100 50 50 50 50 50 500 200 100])
(def threshold 500)

(get-subseries series threshold) ;;[100 50 50 50 50 50]
{% endhighlight %}
