# Recent image of Facebook mcrouter

There is a version to build from the facebook package into ubuntu18.04. (mcrouter 0.40.0)
So you do not get the patch for https://github.com/facebook/mcrouter/issues/45

Also a version to build it from newer code in ubuntu20.04. To get that version,
it is a matter of finding the right combination to get the build to success.
```bash
docker build -t mcrouter:20210524 . -f mc01.Dockerfile
```
But there is an optimisation work to do, the image size makes it unusable.

More info at :

https://github.com/facebook/mcrouter/commit/021d6f01c002100adf92cb9fbb379f3fea01afde

The file `mc02.Dockerfile` builds an 18.04 based image with a mcrouter version that includes
the solution for `issue/45` and we have a raisonable size for the image.