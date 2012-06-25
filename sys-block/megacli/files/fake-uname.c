#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/utsname.h>

#include <stdio.h>
#include <string.h>

int uname(struct utsname *buf)
{
 int ret;

 ret = syscall(SYS_uname, buf);

 printf("uname release: \"%s\"\n", buf->release);
 strcpy(buf->release, "2.6.40");
 printf("uname release set to: \"%s\"\n", buf->release);
 printf("uname version: \"%s\"\n", buf->version);

 return ret;
}
