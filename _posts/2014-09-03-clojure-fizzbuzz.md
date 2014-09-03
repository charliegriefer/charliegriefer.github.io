---
layout: post
title: "Fizz Buzz in Clojure"
description: 

tags: [clojure, programming]
comments: true
---

This morning I came across a Daily WTF article entitled [The Fizz Buzz from Outer Space](http://thedailywtf.com/Articles/The-Fizz-Buzz-from-Outer-Space.aspx). It was amusing, as Daily WTF articles usually are. But it got me thinking about doing a Fizz Buzz implementation in Clojure.

I'm certain there are a ton of them out there, as [Fizz Buzz](http://en.wikipedia.org/wiki/Fizz_buzz) is akin to "Hello World" in programming circles. But I thought it would be an interesting exercise for me. Reading books is great, but for me especially, there's no greater way to learn than to put pen to paper. So to speak.

At first, I wanted to be concise. I came up with the following:

    {% highlight Clojure %}
(defn fizzbuzz []
  (let [nums (range 1 101)]
    (map #(cond (and (= 0 (rem % 3)) (= 0 (rem % 5))) (println "fizzbuzz") (= 0 (rem % 3)) (println "fizz") (= 0 (rem % 5)) (println "buzz") :else (println %)) nums)))
    {% endhighlight %}

Well, that worked. Mostly. The output looked something like this:

    {% raw %}
    (1
2
fizz
4
buzz
fizz
7
8
fizz
buzz
11
fizz
13
14
fizzbuzz
16
17
fizz
19
buzz
fizz
22
23
fizz
buzz
26
fizz
28
29
fizzbuzz
31
32
nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil fizz
34
buzz
fizz
37
38
fizz
buzz
41
fizz
43
44
fizzbuzz
46
47
fizz
49
buzz
fizz
52
53
fizz
buzz
56
fizz
58
59
fizzbuzz
61
62
fizz
64
nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil buzz
fizz
67
68
fizz
buzz
71
fizz
73
74
fizzbuzz
76
77
fizz
79
buzz
fizz
82
83
fizz
buzz
86
fizz
88
89
fizzbuzz
91
92
fizz
94
buzz
fizz
nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 97
98
fizz
buzz
nil nil nil nil nil)
    {% endraw %}

Notice that after the number 32 is output, I get 31 `nil` values output. That pattern repeats itself. It occurs after 64 and after 96 as well. It must be the function actually returning `nil`. Although I don't know why it's every 32nd time. Something to do with how Clojure processes sequences in chunks?

Also, while this mostly worked, I felt like the anonymous function in `(map)` was much too busy. I wanted to clean it up a bit. So I abastracted out some of the functionality into three new helper functions:

    {% highlight Clojure %}
(defn fizz? [n] (= 0 (rem n 3)))
(defn buzz? [n] (= 0 (rem n 5)))
(defn fizzbuzz? [n] (and (fizz? n) (buzz? n)))
    {% endhighlight %}

And the updated `(fizzbuzz)` function:

    {% highlight Clojure %}
(defn fizzbuzz []
  (let [nums (range 1 101)]
    (map #(cond (fizzbuzz? %) (println "fizzbuzz") (fizz? %) (println "fizz") (buzz? %) (println "buzz") :else (println %)) nums)))
    {% endhighlight %}

Not only do I still have all of those `nil` values being output, but that's not really any cleaner now, is it? In thinking about cleaning it up further, I realize that I'm going to need to test 3 conditions. That may just be too much for an anonymous inline function. So I pulled that out as well:

    {% highlight Clojure %}
(defn fizz? [n] (= 0 (rem n 3)))
(defn buzz? [n] (= 0 (rem n 5)))
(defn fizzbuzz? [n] (and (fizz? n) (buzz? n)))

(defn fb [n]
  (cond
   (fizzbuzz? n) (println "fizzbuzz")
   (fizz? n) (println "fizz")
   (buzz? n) (println "buzz")
   :else (println n)))

(defn fizzbuzz []
  (let [nums (range 1 101)]
    (map fb nums)))
    {% endhighlight %}

That's definitely a much cleaner-looking `(fizzbuzz)` function. But my output still has all of those `nil` values.

That's when I realized that there was absolutely no reason for using `(println)`. I'm running into issues because the functions aren't returning the numeric or "fizz"/"buzz"/"fizzbuzz" values. They're _printing_ the values and then returning `nil`. So I need to _return_ the appropriate values:

    {% highlight Clojure %}
(defn fb [n]
  (cond
   (fizzbuzz? n) "fizzbuzz"
   (fizz? n) "fizz"
   (buzz? n) "buzz"
   :else n))
    {% endhighlight %}

The final full Fizz Buzz implementation (also available as a [Gist](https://gist.github.com/charliegriefer/9fb301f499f22360b0a7)):

    {% highlight Clojure %}
(defn fizz? [n] (= 0 (rem n 3)))
(defn buzz? [n] (= 0 (rem n 5)))
(defn fizzbuzz? [n] (and (fizz? n) (buzz? n)))

(defn fb [n]
  (cond
   (fizzbuzz? n) "fizzbuzz"
   (fizz? n) "fizz"
   (buzz? n) "buzz"
   :else n))

(defn fizzbuzz []
  (map fb (range 1 101)))
    {% endhighlight %}

The only other change above is that I removed the `(let)` binding from the `(fizzbuzz)` function. I added it initially because there was so much noise in the anonymous function that I thought it would help declutter the `(map)`. But now that I've extracted everything out into separate functions, there was no need for the `let`, and the code is cleaner without it.

I'm not sure how "good" this is yet. I've not yet looked at other Clojure Fizz Buzz implementations. A couple of things that I thought about:

- Could `(fizzbuzz?)` be implemented more cleanly? I thought about using `(juxt)` or `(comp)` in conjunction with `(fizz?)` and `(buzz?)`, but not sure those really work?
- Is `(cond)` what I want in the `(fb)` function? It reads easily, but I feel like there must be a more "concise" Clojure way.
- I could remove the conditional processing from `(fb)` and use `(if)` functions in `(fizz?)` and `(buzz?)`, returning either the string or the number. But that would mean I'd return `n` twice. Once in each function. With the `(cond)` in `(fb)`, I'm only ever returning `n` once. Seems more DRY?

Overall I'm pretty happy with this. It was a great exercise in writing that I think is clean, idiomatic, easy-to-read Clojure. The end result may not be as concise as I had expected going in, but it works and I think anybody should be able to read and understand it.
