# Bytedump - Bash Version

A big bash script with lots of comments that basically just postprocesses the
output of xxd. Even though it works (on Linux) it's definitely not supposed to
be used to dump the bytes in anything other than very small files. Instead, my
hope is that parts of the source code might be useful to people writing bash
scripts. I think there are some worthwhile things in the script - hopefully
the comments in the code will help you find them.

At the very least this is an excellent example of something that should not be
tackled by a bash script. I'm retired, so that doesn't make a difference to me,
but I'm sure the bosses I had over the years would not have approved if I spent
any work time on this script. Bash is fine for small scripts, but this is way
beyond that.

# Coming Soon (hopefully by July 22)

I have a Java implementation that works well. The performance usually seems to
be equivalent to the hexdump or od Linux commands. xxd, which is almost always
the fastest, easily outperforms hexdump, od, and my Java implementation, but
any of them can handle big files in a reasonable amount of time. I expect the
Java implementation will be available in June, but while I'm working on it I'll
occasionally update the bash version in this repository with changes that I've
made to align it with the Java version.

The Java implementation is a straightforward translation of the bash version of
bytedump and my hope is that understanding either one will make it a bit easier
to follow the other. After that it should be fairly easy to translate that Java
version into a good, solid Java program. New features could be added to it, but
at this point I've convinced myself that different Java implementations could
both be useful.

Well those were my plans, but as usual things have slipped a little. The Java
and Bash versions are basically done, but I'm still working on documentation
that hopefully will help anyone who decides to dive into the source code. It's
a painful process for me that takes quite a bit longer than writing the code,
but I'm making slow progress and I originally thought mid July was a realistic
date, but it now looks like I'll need an extra week.

