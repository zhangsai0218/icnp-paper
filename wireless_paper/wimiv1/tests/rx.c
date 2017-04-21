#include "mex.h"
#include <assert.h>
#include <fcntl.h>
#include <getopt.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <sched.h>


#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#define RX_NAME_DEFAULT "/dev/xdma0_c2h_0"
#define TX_NAME_DEFAULT "/dev/xdma0_h2c_0"
#define TRIGGER_NAME_DEFAULT "/dev/xdma0_user"
#define MAP_SIZE (32*1024UL)
#define BUF_SIZE (4096*128)
#define NUM_SAMPLE (262144)
void mexFunction(int nlhs, mxArray *plhs[],
               int nrhs, const mxArray *prhs[])
{
/* variable declarations here */
  int rx_fd = -1;
  int tx_fd = -1;
  int trigger_fd=-1;
  int16_t *buf,*buf0;
  int i;
  void* map_base;
  int rc=-1;
  int16_t *buf_in; 
/* code here */
  buf_in= mxGetData(prhs[0]);
  buf= (int16_t*)mxCalloc(NUM_SAMPLE,sizeof(int16_t*));
  plhs[0] = mxCreateNumericMatrix(2, NUM_SAMPLE/2, mxINT16_CLASS, mxREAL);

  //for (i=0; i<=15;i++)  {
  //  printf("%x \n", buf_in[i]);
  //}

  
  rx_fd = open(RX_NAME_DEFAULT, O_RDWR);
  assert(rx_fd >= 0);
  tx_fd = open(TX_NAME_DEFAULT, O_RDWR);
  assert(tx_fd >= 0);
  trigger_fd = open(TRIGGER_NAME_DEFAULT, O_RDWR| O_SYNC);
  assert(trigger_fd >= 0);
  map_base = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, trigger_fd,  0);
  buf0 = mmap(0,BUF_SIZE,PROT_READ , MAP_PRIVATE, rx_fd,  0);

  
  
  *((uint32_t *)  map_base + (0x1008>>2) ) = 0x1;
  rc = write(tx_fd,buf_in,BUF_SIZE);
  *((uint32_t *)  map_base + (0x1000>>2) ) = NUM_SAMPLE/8;
  *((uint32_t *)  map_base + (0x1004>>2) ) = 0x3;

   /* rc = read(fpga_fd, buf, 4096*128); */

  memcpy(buf,buf0,BUF_SIZE);

//for (i=0; i<=15;i++)  {
//printf("%x \n", buf0[i]);
//}
   mxSetData(plhs[0],buf) ;
//   mxSetM(plhs[0], 1);
//   mxSetN(plhs[0], 512);

munmap(map_base,MAP_SIZE);
munmap(buf0,BUF_SIZE);
close(trigger_fd);
close(rx_fd);
close(tx_fd);

}