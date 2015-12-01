---
layout: post
title: "Advent of Code - Day 01"
description: "Honing my Clojure skills a day at a time."

tags: [clojure]
comments: true
---

Perusing [/r/programming](https://www.reddit.com/r/programming/) on Reddit this morning, I came across [Advent of Code](http://adventofcode.com/). From the site:

> Advent of Code is a series of small programming puzzles for a variety of skill levels. They are self-contained and are just as appropriate for an expert who wants to stay sharp as they are for a beginner who is just learning to code. Each puzzle calls upon different skills and has two parts that build on a theme.

I'm in!

**Spoilers abound**... I'm going to post my solutions to each day's problems. If you want to do them on your own first, I'd highly recommend doing so prior to reading on.

With that out of the way, here's my approach/solution to [Day 1](http://adventofcode.com/day/1).

Given a string of opening and closing parens, where each opening paren represents going _up_ one floor, and each closing paren represents going _down_ one floor, determine the floor on which Santa ends up.

My first step was to assign the string of parens to a name. 

{% highlight Clojure %}
(def parens "((((()(()(((((((()))(((()((((()())(())()(((()((((((()((()(()(((()(()((())))()((()()())))))))))()((((((())((()..."
;; there are 7000 parens in the string, so it's shortened a bit here.
{% endhighlight %}

Working with a string in Clojure isn't nearly as easy as working with a collection. I can use [(seq)](https://clojuredocs.org/clojure.core/seq) to convert that string to a collection. In this case, a collection of characters:

{% highlight Clojure %}
(seq "((((()(()(((((((()))(((()((((()())(())()(((()((((((()((()(()(((()(()((())))()((()()())))))))))()((((((())((()...")

=> (\( \( \( \( \( \) \( \( \) \( \( \( \( \( \( \( \( \) \) \) \( \( \( \( \) \( \( \( \( \( \) \( \) \) \( \( \) \) \( \) \( \( \( \( \) \( \( \( \( \( \( \( \) \( \( \( \) \( \( \) \( \( \( \( \) \( \( \) \( \( \( \) \) \) \) \( \) \( \( \( \) \( \) \( \) \) \) \) \) \) \) \) \) \) \( \) \( \( \( \( \( \( \( \) \) \( \( \( \))
{% endhighlight %}

So I'll update that `parens` binding:

{% highlight Clojure %}
(def parens (seq "((((()(()(((((((()))(((()((((()())(())()(((()((((((()((()(()(((()(()((())))()((()()())))))))))()((((((())((()..."
;; there are 7000 parens in the string, so it's shortened a bit here.
{% endhighlight %}

Since each opening paren represents going _up_, and each closing paren represents going _down_, I replaced the parens with _1_ or _-1_ accordingly:

{% highlight Clojure %}
(map #(if (= \( %) 1 -1) parens)
{% endhighlight %}


{% highlight Clojure %}
(1 1 1 1 1 -1 1 1 -1 1 1 1 1 1 1 1 1 -1 -1 -1 1 1 1 1 -1 1 1 1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 1 1 -1 1 1 1 1 ... 
{% endhighlight %}

Now it's just a simple matter of `apply`ing `+` over that collection.

Using the [thread-last macro](https://clojuredocs.org/clojure.core/-%3E%3E) to pretty it up, I ended up with:

{% highlight Clojure %}
(->> parens 
     (map #(if (= \( %) 1 -1)) 
     (apply +))
    
=> 74
{% endhighlight %}

That's the first half of Day 1. The second half asks to determine at which point Santa goes below the first floor. Or in this case, the point at which we end up below _0_ while adding all of the numbers together.

Once again, I converted the string to a sequence of _1_ s and _-1_ s via [(map)](https://clojuredocs.org/clojure.core/map). But rather than [apply](https://clojuredocs.org/clojure.core/apply)ing [+](https://clojuredocs.org/clojure.core/+) across the collection, I used [(reductions)](https://clojuredocs.org/clojure.core/reductions). Reductions is a neat little function that, as per the docs:

> Returns a lazy seq of the intermediate values of the reduction (as per reduce) of coll by f, starting with init.

Calling `(reductions + ...)` over the collection of _1_ s and _-1_ s results in:

{% highlight Clojure %}
(1 2 3 4 5 4 5 6 5 6 7 8 9 10 11 12 13 12 11 10 11 12 13 14 13 14 15 16 17 18 17 18 17 16 17 18 17 16 17 16 ...
{% endhighlight %}

With that, I just needed to see how many reductions it took before I encountered a -1 in the collection. Enter [take-while](https://clojuredocs.org/clojure.core/take-while). Again, as per the docs:

> Returns a lazy sequence of successive items from coll while (pred item) returns true. pred must be free of side-effects. Returns a transducer when no collection is provided.

{% highlight Clojure %}
(take-while (partial <= -1) ...)
{% endhighlight %}

The `(take-while)` above returns the sequence of numbers that it took until the predicate function returns false. Then the solution to part 2 can be obtained with a simple [(count)](https://clojuredocs.org/clojure.core/count) over that collection.

Putting it all together, once again using the thread-last macro:

{% highlight Clojure %}
(->> parens
     (map #(if (= \( %) 1 -1))
     (reductions +)
     (take-while (partial <= -1))
     count)

=> 1795
{% endhighlight %}

I'm looking forward to seeing other solutions, both in Clojure as well as other languages. If you're playing along at home, feel free to comment with links to your solutions.