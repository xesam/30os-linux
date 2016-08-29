#include "stdio.h"
#include "stdlib.h"

#ifndef MAX_LEN
#define MAX_LEN 1024
#endif

int main(int argc, char **argv){
  if (argc < 3) {
    printf("usage: %s %s\n", argv[0], "infile outfile");
    exit(1);
  }
  FILE * outfile, *infile;
  infile = fopen(argv[1], "rb");
  outfile = fopen(argv[2], "wb");
  unsigned char buf[MAX_LEN];
  if(infile == NULL){
    printf("infile not exit\n");
    exit(1);
  }
  if(outfile == NULL){
    printf("outfile not exit\n");
    exit(1);
  }
  int rc;
  while( (rc = fread(buf, sizeof(unsigned char), MAX_LEN, infile)) != 0 ){
    fwrite(buf, sizeof(unsigned char), rc, outfile );
  }
  fclose(infile);
  fclose(outfile);
  return 0;
}
