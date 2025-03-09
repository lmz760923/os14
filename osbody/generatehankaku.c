#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
	FILE *fp ,*fpw;
   char str[60]={0};
   char *strto;
   char strw[60]={0};
   int i;

   /* 打开用于读取的文件 */
   fp = fopen("D:\\30dayMakeOS-Day30\\05_day\\hankaku.txt" , "r");
   if(fp == NULL) {
      perror("打开文件时发生错误");
      return(-1);
   }
   
   fpw = fopen("D:\\30dayMakeOS-Day30\\05_day\\hankaku.s" , "w");
   if(fpw == NULL) {
      perror("打开文件w时发生错误");
      return(-1);
   }
   
   fputs(".code16",fpw);
   fputs(".section		.data",fpw);
   
   
   while( fgets (str, 60, fp)!=NULL ) {
   	  
      /* 向标准输出 stdout 写入内容 */
      if (str[0]=='.' || str[0]=='*'){
      	
	  if (str[0]=='.') str[0]='0';
	  if (str[0]=='*') str[0]='1';
	  if (str[1]=='.') str[1]='0';
	  if (str[1]=='*') str[1]='1';
	  if (str[2]=='.') str[2]='0';
	  if (str[2]=='*') str[2]='1';
	  if (str[3]=='.') str[3]='0';
	  if (str[3]=='*') str[3]='1';
	  if (str[4]=='.') str[4]='0';
	  if (str[4]=='*') str[4]='1';
	  if (str[5]=='.') str[5]='0';
	  if (str[5]=='*') str[5]='1';
	  if (str[6]=='.') str[6]='0';
	  if (str[6]=='*') str[6]='1';
	  if (str[7]=='.') str[7]='0';
	  if (str[7]=='*') str[7]='1';
	  
		i=strtol(str,&strto,2);
	  puts(str);
      
      sprintf(strw,".byte   0x%x\n",i);
      fputs(strw,fpw);
      
      //fputs("....\n",fpw);
      }
      
      
   }
 
   fclose(fp);
   fclose(fpw);
   
   return(0);
	return 0;
}