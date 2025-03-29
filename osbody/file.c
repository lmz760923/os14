#include "bootpack.h"

void file_readfat(int *fat, unsigned char *img)
/*将磁盘映像中的FAT解压缩 */
{
	int i, j = 0;
	for (i = 0; i < 2880; i += 2) {
		fat[i + 0] = (img[j + 0] | img[j + 1] << 8) & 0xfff;
		fat[i + 1] = (img[j + 1] >> 4 | img[j + 2] << 4) & 0xfff;
		j += 3;
	}
	return;
}

void file_loadfile(int clustno, int size, char *buf, int *fat, char *img)
{
	int i;
	for (;;) {
		if (size <= 512) {
			for (i = 0; i < size; i++) {
				buf[i] = img[clustno * 512 + i];
			}
			break;
		}
		for (i = 0; i < 512; i++) {
			buf[i] = img[clustno * 512 + i];
		}
		size -= 512;
		buf += 512;
		clustno = fat[clustno];
	}
	return;
}

struct FILEINFO *file_search(char *name, struct FILEINFO *finfo, int max)
{
	int i, j;
	char s[12];
	for (j = 0; j < 11; j++) {
		s[j] = ' ';
	}
	j = 0;
	for (i = 0; name[i] != 0; i++) {
		if (j >= 11) { return 0; /*没有找到*/ }
		if (name[i] == '.' && j <= 8) {
			j = 8;
		} else {
			s[j] = name[i];
			if ('a' <= s[j] && s[j] <= 'z') {
				/*将小写字母转换为大写字母*/
				s[j] -= 0x20;
			}
			j++;
		}
	}
	for (i = 0; i < max; ) {
		if (finfo[i].name[0] == 0x00) {
			break;
		}
		if ((finfo[i].type & 0x18) == 0) {
			if (finfo[i].name[0]==s[0] && finfo[i].name[1]==s[1] && finfo[i].name[2]==s[2] && finfo[i].name[3]==s[3] && finfo[i].name[4]==s[4] && finfo[i].name[5]==s[5] && finfo[i].name[6]==s[6] && finfo[i].name[7]==s[7] && finfo[i].name[8]==s[8] && finfo[i].name[9]==s[9] && finfo[i].name[10]==s[10])
			return finfo + i; /*找到文件*/
		}
		
		i++;
	}
	return 0; /*没有找到*/
}
