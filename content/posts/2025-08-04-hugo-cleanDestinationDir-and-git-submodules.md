---
title: "Hugo --cleanDestinationDir and Git Submodules"
date: 2025-08-04T16:20:39-04:00
tags:
- hugo 
- git 
- facepalm
---

Recently I've been working on updating my blog a bit (you might have noticed?). I keep the hugo sources in a git repository and the built site in a separate repository. That repository is added as a submodule to the sources repo and during the build, the generated HTML is written into the submodule. Except the submodule kept getting messed up; git would be unable to track the changes or they'd be added to the parent repository. It was truly maddening, but as it is so often, the problem was not git but me. 

I had enabled an option `--cleanDestinationDir` so hugo during build would clean up any orphaned files. And that it did, except to hugo, this strange directory `.git` was just something to be deleted. Unsurprisingly, git doesn't really like it when you delete the `.git` directory. 

Mystery solved. 
