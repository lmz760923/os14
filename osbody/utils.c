#include "bootpack.h"
int mystrcmp(char * cs,char * ct)
{
  char __res;

  while (1) {
    if ((__res = *cs - *ct++) != 0 || !*cs++)
      break;
  }

  return __res;
}


int mystrncmp(char * cs,char * ct,size_t count)
{
  char __res = 0;

  while (count) {
    if ((__res = *cs - *ct++) != 0 || !*cs++)
      break;
    count--;
  }

  return __res;
}



void int2str(int n, char str[])
{
 char buf[10] = {0};
int i = 0;
int len = 0;
int temp = n < 0 ? -n: n;  // temp为n的绝对值

if (!str)
{
       return;
   }
   while(temp)
   {
      buf[i++] = (temp % 10) + '0';  //把temp的每一位上的数存入buf
      temp = temp / 10;
  }

      len = n < 0 ? ++i: i;  //如果n是负数，则多需要一位来存储负号
      str[i] = 0;            //末尾是结束符0
      while(1)
      {
          i--;
          if (buf[len-i-1] ==0)
          {
              break;
          }
          str[i] = buf[len-i-1]; 
       }
      if (i == 0 )
      {
          str[i] = '-';          //如果是负数，添加一个负号
     }
  }

void mysprintf(char *buf, char *fmt, ...)
 {

     char* args;
     char *str;
     char buff[20];
	 char *p;
	 
     args=(char*)&fmt;

    for (str = buf; *fmt; fmt++)
     {
         if (*fmt=='%'){fmt++;
			args=args+4;
		    int2str((*((int*)args)),buff);
			p=buff;
			while (*p){
				*str=*p;
				str++;
				p++;}
		 
		 }
		 else{
			 *str=*fmt;
			 str++;
		 }
		
     } 

    *str = '\0';
	
    
 }