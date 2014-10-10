---
layout: post
title: "WordPress No More"
description: "Why I finally moved all of my sites off of WordPress"

tags: [wordpress, jekyll, blogging]
comments: true
---

When I started this blog, it marked the end of my previous blog, which was running WordPress. The previous blog was a mix of technical and personal posts. 
And very little of either were relevant today. I had a new blog for personal posts, and this blog for tech posts. I effectively deprecated the old blog.

By "deprecated" I mean ignored. I planned to leave it as-is, and if anybody left a comment, I'd do my best to reply.

But then a funny thing happened.

I got a notification from my hosting company that spam emails were originating from the old blog's domain. Clearly, I needed to tighten things up.

I disabled comments for all of the posts. I removed the contact form. I thought that would have done it. It did not.

I got another notification from the hosting company.

I disabled all plugins that sent emails. I didn't need them anymore anyway. I thought that would have done it. It did not.

I got another notification from the hosting company.

It would be easy to blame WordPress. But the fact of the matter is that I wasn't putting in the effort to make sure the WordPress install was up to date. Same with the plugins. It just wasn't time I wanted to invest in a deprecated site.

Both this blog and [Second Half Charlie](http://www.secondhalfcharlie.com) run on [Jekyll](http://jekyllrb.com/). I've become a big fan of Jekyll since first finding out about it. 
I considered converting the old blog over... but that would mean a decent amount of work for a site that was no longer particularly relevant (as if it ever was).

I decided to see if I could find an app that would crawl the site and save all of the static pages. I could then just throw them up on Amazon S3, where Second Half Charlie is hosted.

As luck would have it, there's a pretty decent utility called [HTTrack](http://www.httrack.com/). I installed it, pointed it towards the old blog, and four hours later (seriously!), had a static version of the site locally.

I also ran the utility on two other WordPress blogs that my wife and eldest daughter have ignored for years. Grabbed static versions of them, and put them up on S3 as well. 
After setting up some Hosted Zones with Amazon's Route 53, the sites were up and running. Non-functional versions, of course. No contact forms, no emailing. But the information is there. 
Nothing's been lost, and I no longer have to worry about an old site causing issues.

I was very impressed with HTTrack. It does a _very_ thorough job of copying web sites. This experiment also gave me a bit more exposure to Amazon Web Services. I moved the DNS for `griefer.com` over completely from NameCheap. 
Getting the DNS up and running in Route 53, along with the various subdomains, was a bit of a challenge if only because of my lack of familiarity with AWS. I'm pretty sure that my efforts have only scratched the surface, but it was enjoyable learning something new.

If you're so inclined, feel free to visit [http://charlie.griefer.com/blog](http://charlie.griefer.com/blog). 100% static. 100% AWS hosted. 99.99% maintenance and worry free :)