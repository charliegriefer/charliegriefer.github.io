---
layout: post
title: "Learn the Shit out of Clojure: Update 1"
description: 

tags: [clojure, programming]
comments: true
---

Just about a week into [Learn the Shit out of Clojure Month](/2014/08/01/learn-the-sht-out-of-clojure/), and I've gotten through chapters 1-3 of [Programming Clojure](http://pragprog.com/book/shcloj/programming-clojure). I made notes as I was going through the chapters. This is not meant to be a review of the book or a review of the material. Merely how I related to the material. What clicked. What didn't.

Really it's just something for me, to hold me accountable. But hey if you're here, feel free to read on.

### Chapter 1: Getting Started

#### 1.1 Why Clojure

- Clojure is simple, powerful, elegant.  
- functional language: functions are first-class objects. Data is immutable. Functions are pure.

#### 1.2 Clojure Coding Quick Start

- grab leiningen. fire up a REPL 
- The difference between a [__symbol__](http://clojure.org/data_structures#Data%20Structures-Symbols) and a [__var__](http://clojure.org/vars) throws me a bit. 
- intro to data structures (using a [__set__](http://clojure.org/data_structures#Data Structures-Sets)), functions ([__conj__](http://clojuredocs.org/clojure_core/clojure.core/conj)), and reference types ([__atom__](http://clojure.org/atoms)). discussing state.

#### 1.3 Exploring Clojure Libraries

- Explains libraries and namespaces. using [__require__](http://clojuredocs.org/clojure_core/clojure.core/require). quoting the library name ([__quot__](http://clojuredocs.org/clojure_core/clojure.core/quot) covered later)
- needed to download code and fire up new REPL from proper location in order to require `'examples.introduction`.
- `require`-ing a library still means you have to refer to items in the library with a _namespace-qualified_ name. 
- [__refer__](http://clojuredocs.org/clojure_core/clojure.core/refer) creates mappings for all of the names in the current namespace
- can't refer without require (?)
- [__use__](http://clojuredocs.org/clojure_core/clojure.core/use) does both __require__ and __refer__ in a single step

### Chapter 2: Exploring Clojure

#### 2.1 Forms

- Talking about forms. At this point, I'd be hard pressed to clearly explain the difference between a form, a symbol, an expression, etc.
- ah, OK. So certain forms are symbols (?)
- "Strings are sequences of characters", which makes me think of [__seq__](http://clojure.org/sequences). Yet another term that I couldn't clearly define. The difference between an expression and a seq? I feel like all of these terms are so many pebbles beneath my feet preventing me from getting the traction I need to move forward. The foundation does not feel solid. *sigh*
- I'm not a Lisp programmer, but I just know that empty list not being false is going to trip me up. A lot.
- I'm not a C programmer, but I just know that zero not being false is going to trip me up. A lot.
- Having worked with [__maps__](http://clojure.org/data_structures#Data%20Structures-Maps%20(IPersistentMap)) before, seeing the examples using strings rather than keywords as keys seems odd. Suddenly I feel superior, like I know something. Savoring that feeling while it lasts.
- ...and now we’re onto [__defrecord__](http://clojuredocs.org/clojure_core/clojure.core/defrecord), which I have not yet used. Oh, well. It was nice while it lasted.
- Wondering if it's convention for the name of the defrecord to be uppercased. According to the [Clojure Style Guide](https://github.com/bbatsov/clojure-style-guide#CamelCase-for-protocols-records-structs-and-types), yup.

#### 2.2 Reader Macros

- Short and understood

#### 2.3 Functions

- This much I understand.
- Oops. I spoke to soon. `(make-greeter)`, a function that creates new functions… deep. But OK. It's starting to make sense.

#### 2.4 Vars, Bindings, and Namespaces

- Vars. that list of things that are pebbles. Oh, wait… _"…you can often simply ignore the distinction between symbols and vars."_ w00t!
- Bindings. Makes sense.
- Destructuring - I get the concept. Want to put it more into practice.
- Wondered why you couldn't use (apply str) in the destructuring sample function. You could, but you need spaces. That's what `(str/join " " […])` does. 

#### 2.5 Calling Java

- As I never worked directly i Java, I wonder how this is going to go (_This was my only note for this section. Let's assume that it went OK -CJG_)

#### 2.6 Flow control

- [__if__](http://clojuredocs.org/clojure_core/clojure.core/if) and [__do__](http://clojuredocs.org/clojure_core/clojure.core/do). got it.
- [__loop__](http://clojuredocs.org/clojure_core/clojure.core/loop)/[__recur__](http://clojuredocs.org/clojure_core/clojure.core/recur). 
- Enjoyed seeing the more concise ways of the countdown with recur. I'm looking forward to thinking in those terms.
- `(iterate dec 5)` <— oops. don’t do that.

#### 2.7 Where's my For Loop?

- In awe of how elegant and concise the Clojure code samples are. Also, reusable. Love the way that `(index-filter)` is reused in `(index-of-any)`, and the code sample to get the "nth" occurrence of "heads" in a series of coin flips

#### 2.8 Metadata

- (_No notes for this section_)

### Chapter 3: Unifying Data with Sequences

#### 3.1 Everything is a Sequence

- Reading about cons made me wonder what the difference between [__cons__](http://clojuredocs.org/clojure_core/clojure.core/cons) and [__conj__](http://clojuredocs.org/clojure_core/clojure.core/conj) was. Googled. Made it worse.
- Likewise conj vs [__into__](http://clojuredocs.org/clojure_core/clojure.core/into).
- Lots of ways to do things, all of which are similar enough to be confusing/intimidating in wondering which is the "right" way.

#### 3.2 Using the Sequence Library

- "The whole numbers are a pretty useful sequence to have around, so let’s defn them for future use: `(defn whole-numbers [] (iterate inc 1))`." Why `defn` and not `def`?
- The difference between [__repeat__](http://clojuredocs.org/clojure_core/clojure.core/repeat) and [__cycle__](http://clojuredocs.org/clojure_core/clojure.core/cycle). `(take 10 (repeat (range 3)))` vs `(take 10 (cycle (range 3)))`. Ah, the former returns 10 sequences of `(0 1 2)`. The latter returns a single sequence of the first 10 members of the collection that results from cycling over `(range 3)`. It may not sound like I get it, but I get it.
- List comprehensions and sequence comprehensions. Cool stuff.

#### 3.3 Lazy and Infinite Sequences

- I know it's not the point of the section, but trying to wrap my head around the `(def primes ...)` code did my brain in.
- Other than that, I think I understand the concept of lazy and infinite sequences.

#### 3.4 Clojure Makes Java Seq-able

- Again, not being a Java guy, not sure what I expect I'll get out of this section
- Interesting to see seq-ing a regex and seq-ing the file system, as well as XML. Surprised to see the XML examples in a Java section. Ah, because it's being read in via `java.io.File`.

#### 3.5 Calling Structure-Specific Functions

- If `(peek)` is the same as `(first)`, but `(peek)` is different across lists and vectors, why would one ever use peek in place of first? Same with `(pop)` vs `(rest)`. first and rest seem much safer?
- Vectors themselves being functions is interesting. `([:a :b :c] 2)` as opposed to `(get [:a :b :c] 2)`. Nice.
- Same with maps being functions of their keys, and keywords being functions.
- Starting to click about data being immutable:

{% highlight css %}
#container {
  float: left;
  margin: 0 -240px 0 0;
  width: 100%;
}
{% endhighlight %}

- In the code above, the `(assoc)` didn't modify __song__. It was output and then it was gone. I could have bound it to another variable (?), or even to __song__ again. Still would not have overwritten song, but would have created a new binding that happened to have the same name as the previous binding. In this context/environment, the initial binding to __song__ would no longer be accessible.

That's it for Chapters 1 - 3. Over the weekend I'll dig into Chapter 4: Functional Programming, which I'm very much looking forward to. Once I get through chapter 6, I'll post the next update. 

If you've read this far, thanks for keeping me honest and accountable.
