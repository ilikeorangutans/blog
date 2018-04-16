---
title: "Building a CMS with XML, XSLT, Ant, and ImageMagik"
date: 2010-01-03T11:37:30-04:00
tags:
  - XSLT
  - XML
  - Ant
  - Air
  - CMS
  - Content Management
  - ImageMagik
  - Saxon
  - Web Development
  - XHTML
  - XSLT2.0
---

Not so long ago a freelance client approached me with some updates for their website. The site has been growing organically since 2000 and therefore was a big mess. Several attempts to port the site to a CMS driven system failed largely because those CMS systems are usually to complex for our needs (Typo3) or not flexible enough (Joomla, WordPress). So as I was faced with updates to all the updates including image updates which in turn needed thumbnails to be generated. The same day I stumbled randomly over the [xsl:result-document](http://www.w3.org/TR/xslt20/) function in XSLT 2.0 which allows you to transform a single XML file into several output files. That sparked an idea with me: why not use that to build a CMS system using XML technologies? I've toyed around with [Cocoon](http://cocoon.apache.org/) a couple of years ago but that was not what I was looking for. So I looked for other technologies...

This post is a write-down of my experiences building a XML/XSLT driven simple CMS system. In it I will show you the required technologies, my approaches and my solutions to problems I've encountered. You'll need a solid understanding of XML at least, understanding of Ant and XSLT helps a lot, too.

This post contains tons of XML and I tried my best to format it in a readable way — in fact I've spent hours to get everything nicely on the screen.

## Requirements to the CMS

I had several objectives when I built my system:

* All mundane and repetitive tasks should be automated, including thumbnail generation, creation of a global navigation, synchronizing with a live site
* Flexible enough to support new "content types" and new views
* Versionable with Git, Subversion or other SCMs
* Creation of output artifacts should be a single command

## Technologies

The most prominent and important technology I used is XSLT 2.0. If you don't know what XSLT is, here is XSLT in a nutshell.

XSLT stands for eXtensible Stylesheet Language Transformations. What it does is surprisingly simple. It takes a piece of XML as input (aka source tree or input tree), applies some transformations on it and outputs a new piece of XML. Sounds simple in theory, however in practice it is usually somewhat more complicated because XSLT is a functional language and sometimes requires you to solve problems backwards and don't even get me started on XML [namespaces](http://www.w3.org/TR/xml-names11/)...

Traditionally you'd have one input XML file, one XSL stylesheet and accordingly one single XML output file. However with the new xsl:result-document I can suddenly output into several files.

As I'm using XSLT the next technology used is XML of course. Not much to say about this except that it is involved in pretty much every step. To bind everything together I'm using [Apache Ant](http://ant.apache.org/), an incredibly flexible tool. Interestingly enough Ant uses XML files for its build files which comes in handy later on. Also it solves one of my requirements: it is just plain text and therefor versionable.

Last there is image manipulation. I've experimented a bit with the Ant image tasks that use JAI to perform manipulation but quickly dropped that approach as this task won't even let you specify a quality parameter for image manipulations. I've ended up using an old friend: [ImageMagick](http://www.imagemagick.org/script/index.php). ImageMagick is an amazing toolkit of versatile command line tools to modify images. It allows to modify images in many different ways from resizing to colour correction or combining them.

## Basic Structure

The basic structure of an XML/XSLT driven CMS contains one or more XML files that contain the "raw" data for the website, XSLT to transform it into XHTML and assets. More on assets later.

### The XML Part

The XML file used in my project is a very simple one. It defines "pages" that get translated into real HTML pages. Each page has a section called contents which in turn contain the actual page contents. Let's have a look at a short sample:

```
<?xml version="1.0" encoding="utf-8"?>
<s:site title="My XSLT Generated website"
   xmlns:s="http://www.jakusys.de/xslt-cms"
   xmlns="http://www.w3.org/1999/xhtml">

    <s:page title="Home" filename="index.html" showTitle="false">
        <s:contents>
            <s:html>
                <h1>Welcome to my XSLT generated page!</h1>
                <p>Bla bla bla </p>
            </s:html>
        </s:contents>
    </s:page>
    <s:page title="Contact Me" filename="contactme.html">
        <s:contents>
            <s:html>
                <h1>Contact Me</h1>
                <p>Send me an <a href="">email</a>!</p>
            </s:html>
        </s:contents>
    </s:page>
</s:site>
```

Well, so far nothing impressive. Actually it looks like more work compared to typing out the actual pages themselves. But behold, here comes the stylesheet to actually turn the above XML into nice websites (XHTML):

```
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="2.0" exclude-result-prefixes="#all"
   xmlns="http://www.w3.org/1999/xhtml"
   xpath-default-namespace="http://www.jakusys.de/">

    <xsl:output method="html" indent="yes" name="html"
       omit-xml-declaration="yes"/>

    <xsl:template match="/">
        <xsl:apply-templates select="site"/>
    </xsl:template>

    <xsl:template match="site">
        <xsl:apply-templates select="page"/>
    </xsl:template>

    <xsl:template match="page">
        <xsl:variable name="filename" select="@filename"/>
        <xsl:result-document omit-xml-declaration="yes" indent="yes"
           href="{$filename}" format="html" encoding="UTF-8"
           doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
           doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type"
                        content="text/html; charset=utf-8"/>
                    <title>
                        <xsl:value-of select="@title"/>
                    </title>
                </head>
                <body>
                    <div class="container">
                        <xsl:apply-templates select="contents/*"/>
                    </div>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

     <xsl:template match="*" mode="html">
         <xsl:copy copy-namespaces="no">
             <xsl:copy-of select="@*"/>
                 <xsl:apply-templates mode="html"/>
         </xsl:copy>
     </xsl:template>

</xsl:stylesheet>
```

Now it get's more interesting. Let's dissect what the above XSLT does. The blocks in line 10 to 12 are a template that matches the root level element in the source XML tree. All it does is to call the next matching stylesheets which are in lines 14 to 19. This template does exactly the same and passes on. Then we reach line 18 with the template matching page elements.

```
18
<xsl:variable name="filename" select="@filename"/>
<xsl:result-document omit-xml-declaration="yes"
  indent="yes" href="{$filename}" format="html"
  doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
  encoding="UTF-8">
```

Line 18 defines a variable called filename which is prefilled with with the filename attribute from the XML page element. The next line sports the so much praised (at least by me) `xsl:result-document` element. If you read the line it gets clear very fast that it should output a new HTML file (`format="html" href="$filename"`), nicely formatted (`indent="yes"`) and with the appropriate DOCTYPE declaration. The  next lines are just an HTML boilerplate with head and content type. Please note that this is a very minimalistic example. Usually you would include stylesheets, JavaScript includes and other additional headers there. For simplicity they are omitted.

```
28
<title>
    <xsl:value-of select="@title"/> - <xsl:value-of select="/site/@title"/>
</title>
```

Lines 28 to 31 output a new title tag populated with the title attribute from our source attribute. Convenient. The CMS is starting to take shape.

```
33
<div class="container">
    <xsl:apply-templates select="contents/*"/>
</div>
```

And finally lines 33 to 35 will call another template lines 41 to 46 which just copies the HTML into the output document.

So far so good. What have we achieved? The stylesheet creates a new page based on boilerplate HTML - which can be arbitrarily complex with CSS stylesheets, JavaScript and more - and pre-fills the title and the actual body. Now let's add more functionality. Every good website needs a navigation. We can achieve that easily by adding another template that matches all page elements. We add a few new lines to the boilerplate HTML:

```
<div class="navigation">
    <ul>
        <xsl:apply-templates select="/site/page" mode="navigation"/>
    </ul>
</div>
```

Looks simple enough. This will output a new DIV, fill it with a unordered list and calls another template.  The interesting part is the select attribute: it tells the XSLT processor to select all root level page elements. Now let's have a look at how the called template looks like:

```
<xsl:template match="page" mode="navigation">
    <li>
        <a href="{@filename}" title="{@title}">
            <xsl:value-of select="@title"/>
        </a>
    </li>
</xsl:template>
```

The XSLT processor will translate this into global navigation of our site. All top level pages will be listed with the correct title and the correct filename.

### The Ant Part

Now that we have the stylesheets and the input XML files in place, we'll need an elegant way to transform the whole site with on simple command. As discussed earlier Ant is a good choice for this. I won't delve into the actual ANT buildfile as it is pretty straightforward. What I want to show is how to use XSLT to generate ANT buildfiles from other XML. This is actually a pretty powerful technique as I can custom tailor ANT files to whatever need I have. In this particular example I want to show how to create image thumbnails.

Here is what we have. In our input XML file, we reference images. For those images, let's say, product shots, we have the originals lying in some location in the filesystem. Those images need to be scaled down to a high res view (800×600) and to a thumbnail (128×128). We could do that with an ANT pathmatcher, but that would just take all the images it can find, not just the referenced ones. Bad and slow. And how do we keep the build directory free of old and unused pictures then?

What we'll do instead is we'll take the input XML file, create a XSLT stylesheet that will grab all the image references and put them into a custom ANT build file which in turn calls an image manipulation program (ImageMagick) to scale down the pictures. There's a few other goodies in here too, e.g. automatic file name cleanup. Here is the images.xsl:

```
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0" xpath-default-namespace="http://www.jakusys.de/">

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <xsl:template match="/">
        <project name="Image Processing" default="prepare-images">

            <target name="prepare-images" depends="copy-originals,scale"> </target>

            <target name="copy-originals">
                <xsl:element name="copy">
                    <xsl:attribute name="todir">
                        <xsl:text>${build.dir}/images</xsl:text>
                    </xsl:attribute>
                    <xsl:element name="fileset">
                        <xsl:attribute name="dir">
                            <xsl:text>${assets.dir}/images</xsl:text>
                        </xsl:attribute>
                        <xsl:apply-templates select="//image" mode="copy-original"/>
                    </xsl:element>
                </xsl:element>
            </target>

            <target name="scale">
                <xsl:apply-templates select="//image" mode="thumbnail"/>
            </target>
        </project>
    </xsl:template>

    <xsl:template match="image" mode="thumbnail">
        <exec executable="/opt/local/bin/convert">
            <arg line="-thumbnail 128x128 -quality 0.85 assets/images/{@src}.jpg build/images/{lower-case(@src)}_thumb.jpg"/>
        </exec>
    </xsl:template>

    <xsl:template match="image" mode="copy-original">
        <include name="{lower-case(@src)}.jpg"/>
    </xsl:template>

</xsl:stylesheet>
```

### Google Sitemaps

Most people that have used Google's Webmaster Tools know about the sitemap. No need to write them manually any more, you can easily use the XML representation and a XSLT stylesheet to generate it for you:

```
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="2.0" xpath-default-namespace="http://www.jakusys.de/"
   xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <xsl:template match="/">
        <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
            <xsl:apply-templates select="site/page"/>
        </urlset>
    </xsl:template>

    <xsl:template match="page">
        <url>
            <loc>http://www.my-website.com/<xsl:value-of select="@filename"/></loc>
            <lastmod>2009-09-10</lastmod>
            <changefreq>monthly</changefreq>
        </url>
    </xsl:template>

</xsl:stylesheet>
```

## Issues

So with all the technologies in place, I ran into some issues but all of them could be solved quickly. I'm listing them here hoping they'll help other people.

### XSLT 2.0 with Ant

This one was most annoying. Per default Ant has an [xslt-task](http://ant.apache.org/manual/CoreTasks/style.html) which allows you to transform XML but it is limited to XSLT 1.0. If you read the documentation you'll find out that you can plug in different XSLT processors but you are still quite limited. If you want to use XSLT 2.0 with Ant get the amazing [Saxon processor](http://saxon.sourceforge.net/) and use their Ant task which is a bit hidden on their page. Get it from the Sourceforge [download site](http://sourceforge.net/projects/saxon/files/saxon%20ant%20task/). This task lets you leverage the full functionality of XSLT 2.0 including the xsl:result-document.

### XML Namespaces in HTML

This was a tricky one. The problem was that in my custom XML I had snippets of HTML which I wanted to mirror into the output documents. I used the xsl:copy-of function which basically did what it was supposed to. It copied the (X)HTML over but by doing so, it had to adjust the namespaces for the XML. The input document had no namespace declarations at all and the output document was bound to the XHTML namespace. So the processor did exactly what it is supposed to: it added null namespace  declarations to the copied elements which looked like this:

```
<p xmlns="null">Bla bla bla</p>
```

Not a problem per se but unfortunately invalid XHTML. The solution to this problem is surprisingly simple: Add namespace declarations to the input document:

```
<?xml version="1.0" encoding="utf-8"?>
<s:site title="My XSLT Generated website"
   xmlns:s="http://www.jakusys.de/xslt-cms"
   xmlns="http://www.w3.org/1999/xhtml">
```

The above lines will put the input document per default into the XHTML namespace and everything else in my own, personal namespace. Regular (X)HTML markup however does not get any namespace prefixes, so it will be put into the XHTML namespace:

```
    <s:page title="Home" filename="index.html" showTitle="false">
        <s:contents>
            <s:html>
                <h1>Welcome to my XSLT generated page!</h1>
            </s:html>
        </s:contents>
    </s:page>
```

## Conclusion

The one big problem I still have with this system is that it does not support hierarchical pages yet. But if the need arises it could be added without too much effort. Another moose with the system is that it still requires editing XML which is neither user-friendly nor easy for non technical users. But one could easily create a Flex or AIR app to modify and edit those files. Thanks to Flex' really good XML support it should not be hard to do that. I could even think of a Grails Webapp generating the XML for this (using the brilliant XML markup builder).

In general it is a really powerful and flexible system. As I am running this on a UNIX system I can harness all the tools and goodies that are there. Ant and Java give me whatever power and libraries I need. So I can steer this thing in whichever direction I want.

If you have any questions feel free to comment below or drop me an email.
