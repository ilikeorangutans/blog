---
title: "A New Theme"
date: 2018-05-21T22:58:40-04:00
tags:
  - Hugo
  - Blog
  - Personal
---

After toying around with the really nice [Temple theme](https://github.com/aos/temple) I decided there was no better way to spend my afternoon than building my own, new theme for my blog.

If you haven't notice, I recently switched my blog from [Jekyll](https://jekyllrb.com/) to [Hugo](https://gohugo.io/). The upgrade path from the really old version of Jekyll to the latest version wasn't quite working as expected, and having to mess around with Gemfiles isn't really something I enjoy. Hugo on the other hand is written in Go and comes as a single, standalone binary. That seemed really appealing and I've had good experiences when trying to build a little [photo gallery builder](https://github.com/ilikeorangutans/hugo-photo-scanner) with it a while ago before Hugo had actual photo support. Moving the content over from the Jekyll frontmatter to the Hugo frontmatter was done easy enough, I even moved some of the good posts from my really old blog on here. I was almost perfectly happy, exception for the theme. The Temple theme is nice, but it wasn't quite what I wanted. So this weekend I built my own (yeah, you're looking at it).

There's a few things I learned:

#### 1. Making things look nice is hard

I kind of started with this idea that I wanted to use the colour teal --I really don't know why, but it just seemed like a good idea-- and I ran with it. The results were terrible. I ended up playing around with more colors and settled on this gray-steel-blue-tone. I guess it's ok.

#### 2. Why are there so many CSS frameworks?

But of course I didn't want to just use browser default themes, because what is this, the 90's? So I looked at some CSS frameworks. Searching for _lightweight CSS framework_ brings up a ton of results. I tried some of them, but in the end I picked the terrific [spectre](https://picturepan2.github.io/spectre/index.html) framework because it sets a nice, large font and has a good enough grid for my needs. Are there better CSS frameworks? Probably. Does it matter? Not really -- it does what I need and I think it looks pretty enough. I'm particularly happy with how legible the blog now is. At the end of the day HTML and especially CSS are not my strength, so this will have to do.

#### 3. Hugo's themes and templates are great

I'll admit, it took me a while to understand how Hugo's templates and themes work. In particular the [template lookup order](https://gohugo.io/templates/lookup-order/) is initially confusing, but once I had my head wrapped around it, it became straightforward to make Hugo build the markup I wanted. [Blocks](https://gohugo.io/templates/base/) make it easy to build base templates and plug different sections in, the taxonomy system is fun to work with, and even the menu system allows for easy creation of tags or other structures. And I _love_ how the [`.Render`](https://gohugo.io/templates/views/) function can be used to render different "views" of an entity.

Oh, and there is many open source themes for Hugo that can serve as inspiration or can be studied to learn more. In a way this reminds me of the time I was learning HTML.

I'm excited to use Hugo for more projects now. It seems so flexible, it really is fast, and the possibilities are limitless. I want to play with Hugo's data templates and see if I can build my own little recipe database. Another time.