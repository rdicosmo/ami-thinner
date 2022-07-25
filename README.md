ami-thinner
===========

Combining Mancoosi and Misc tools to produce AMI with minimal disk footprint.

See here beloe a detailed explanation and use cases from [a blog post](https://www.dicosmo.org/MyOpinions/index.php?post/2013/02/08/131-optimising-the-disk-footprint-of-gnu-linux-distributions) *Published February 8 2013, 12:59*.

# Optimising the disk footprint of GNU/Linux distributions for the Cloud

Did you know that the standard, off the shelf GNU/Linux instances you can get on Amazon are usually largely bigger than waht you actually need?
Well, our well established Mancoosi tools can help you (again!).

Quinton, Rouvoy and Duchien remarked in [their recent work presented at CloudPC 2012](http://dl.acm.org/citation.cfm?doid=2168697.2168699) that the stock virtual machine images pre-installed with some GNU/Linux distribution contain a lot of packages that you do not really need for your standard use, even when this particular image is advertised specifically for your precise purpose.
As a consequence, you end up paying for storage that you do not need at all, just to save a copy of your nice instance.

After seeing a presentation on this issue by [Clement Quinton](http://chercheurs.lille.inria.fr/~cquinton/index.html), that visited [Irill](http://www.irill.org) recently, we decided to see with [Pietro](http://mancoosi.org/~abate/) how strightforward it is to use our Mancoosi tools to solve this issue.

Well, it turns out that this is basically a trivial task, that can simply become a one-liner.

First of all, make sure that you have installed, on your Debian box, the following pieces of code from the Mancoosi project:

1. __aspcud__, version 1.7 or later, from [http://www.cs.uni-potsdam.de/wv/aspcud/](http://www.cs.uni-potsdam.de/wv/aspcud/) and make sure the executable aspcud is the aspcud-full one (the aspcud version in Debian experimental, as of 2012.10.24-1 is fine); 
2. __ceve__, which is one of the applications compiled by default in the Dose library from [https://gforge.inria.fr/projects/dose/](https://gforge.inria.fr/projects/dose/) (the version of ceve in Debian as of 1.4-2 is not recent enough)
3. __cudf_solution_checker__ from [https://gforge.inria.fr/projects/misc-competitio/](https://gforge.inria.fr/projects/misc-competitio/)
Then just checkout the script [thinnit.sh](https://github.com/rdicosmo/ami-thinner/blob/master/thinnit.sh) from its [git repository](https://github.com/rdicosmo/ami-thinner), and you can now ask interesting questions like:

### __what is the smallest installation containing all packages needed to make an apache2 web server using Debian testing__? The answer is, __you need 154 packages, totalling 181Mb of disk space once installed__, and the list of these packages is left in a CUDF file named __thinned.cudf__
```
 ./thinnit.sh /var/lib/apt/lists/ftp.fr.debian.org_debian_dists_testing_main_binary-amd64_Packages apache2
  <snip>
 -181008,-154
```
### __and if I want tomcat and php__? Then __you need 176 packages, for a total of 258Mb__, and the list of these packages is left in a CUDF file named __thinned.cudf__
```
 ./thinnit.sh /var/lib/apt/lists/ftp.fr.debian.org_debian_dists_testing_main_binary-amd64_Packages "tomcat6,php5"
  <snip>
 -258482,-176
```
Well, I think you get the idea... and by the way you can modify the script to play with [the full rich user preference language supported by the entrants of the latest MISC competition](http://www.mancoosi.org/misc-2012/results/index.html)!

And the good news is... on a stock laptop all this takes less then 10 seconds.

Please let us know if you use this code, and... enjoy!

*Acknowledgement:* if this is just one line, now, it is because of all the wonderful people that worked on Mancoosi and participated in MISC over the past years.

There are so many to thank that it wont fit in the blog entry, but you can find them on the [Mancoosi website](http://www.mancoosi.org), on the list of participants to the [MISC competition](http://www.mancoosi.org/misc/), and mentioned in my previous posts on [Mancoosi tools](http://www.dicosmo.org/MyOpinions/index.php/Mancoosi).

