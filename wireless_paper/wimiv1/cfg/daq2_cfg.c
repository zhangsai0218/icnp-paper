#include <unistd.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <byteswap.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <time.h>

#include <ctype.h>
#include <termios.h>
#include <sys/types.h>
#include <sys/mman.h>

#define MAP_MASK (MAP_SIZE - 1)
#define SRC_LANE1(x)                         (((x) & 0x7) << 3) /* Logic Lane 1 source */
#define SRC_LANE0(x)                         (((x) & 0x7) << 0) /* Logic Lane 0 source */
#define SRC_LANE3(x)                         (((x) & 0x7) << 3) /* Logic Lane 3 source */
#define SRC_LANE2(x)                         (((x) & 0x7) << 0) /* Logic Lane 2 source */


#define MAP_SIZE (32*1024UL)
#define MAP_MASK (MAP_SIZE - 1)
#define AD_IFE(_pde, _a, _b) ((pdata->_pde) ? _a : _b)
#define AD_IF(_pde, _a) AD_IFE(_pde, _a, 0)
int fd = 0;
void *map_base, *virt_addr; 
struct ad9523_state
{
    struct ad9523_platform_data *pdata;
    uint32_t vcxo_freq;
    uint32_t vco_freq;
    uint32_t vco_out_freq[3];
    uint8_t vco_out_map[14];
}ad9523_st;

enum
{
	AD9523_VCO1,
	AD9523_VCO2,
	AD9523_VCXO,
	AD9523_NUM_CLK_SRC,
};

int wr_reg_spi (int dev, unsigned long offset, unsigned long data)
{
	//ioctl ( 3, 0xffff & (~(0x1 << (dev-1))));
    *((uint32_t *)  map_base + (0x0002) ) = 0xffff & (~(0x1 << (dev-1)));
	usleep(1000);
	//printf("wr_reg:%X\n", 0xffff & (~(0x1 << (dev-1))));
	//ioctl ( 4, ((offset<<8)+data)<<8);
    *((uint32_t *)  map_base + (0x0000) ) = ((offset<<8)+data);
    *((uint32_t *)  map_base + (0x0001) ) = 0x1;

    usleep(1000);
	//printf("wr_reg:%X\n",((offset<<8)+data)<<8);
	//ioctl ( 3, 0xffff);
	*((uint32_t *)  map_base + (0x0002) ) = 0xffff ;
	usleep(1000);
	//printf("wr_reg:%X\n",0xffff);

	return 0;

}


int cfg_CLK()
{
	wr_reg_spi(3,0x000,0x24); //soft rst
	wr_reg_spi(3,0x004,0x01); //buffer readback
    wr_reg_spi(3,0x233,0x00);

	wr_reg_spi(3,0x234,0x01); //write reg

	/*
	 * PLL1 Setup
	 */
	wr_reg_spi(3,0x011,0x0);//refa div
	wr_reg_spi(3,0x010,0x01);//refa div
	wr_reg_spi(3,0x012,0x0);//refb div
	wr_reg_spi(3,0x013,0x01);//refb div
	wr_reg_spi(3,0x017,0x0);//pll1 feedback
	wr_reg_spi(3,0x016,0x01);
	wr_reg_spi(3,0x018,0x80);
	wr_reg_spi(3,0x019,0x00);
	wr_reg_spi(3,0x01a,0x01);
	wr_reg_spi(3,0x01b,0x00);
	wr_reg_spi(3,0x01c,0x00);
	wr_reg_spi(3,0x01d,0x01);


	wr_reg_spi(3,0x234,0x01);


	/*
	 * PLL2 Setup
	 */
	wr_reg_spi(3,0x0f0,0x7f);
	wr_reg_spi(3,0x0f1,0x06); //NDivider=24,REF=125M,VCO=3G VCODIV=1G
	wr_reg_spi(3,0x0f2,0x0b);
	wr_reg_spi(3,0x0f3,0x08);



	wr_reg_spi(3,0x0f4,0x00);
	wr_reg_spi(3,0x0f5,0x2a);
	wr_reg_spi(3,0x0f6,0x00);
	wr_reg_spi(3,0x0f7,0x01);
	wr_reg_spi(3,0x234,0x01);

//channel 1 DAC_CLK
	wr_reg_spi(3,0x193,0x03);
	wr_reg_spi(3,0x194,0x00);
	wr_reg_spi(3,0x195,0x00);
//channel 4 ADC_CLK_FMC
	wr_reg_spi(3,0x19c,0x03);
	wr_reg_spi(3,0x19d,0x03);
	wr_reg_spi(3,0x19e,0x00);
//channel 5 ADC_sysref
	wr_reg_spi(3,0x19f,0x03);
	wr_reg_spi(3,0x1a0,0x7f);
	wr_reg_spi(3,0x1a1,0x00);
//channel 6 fmc_adc_sysref
	wr_reg_spi(3,0x1a2,0x03);
	wr_reg_spi(3,0x1a3,0x7f);
	wr_reg_spi(3,0x1a4,0x00);
//channel 7 fmc_DAC_sysref
	wr_reg_spi(3,0x1a5,0x03);
	wr_reg_spi(3,0x1a6,0x7f);
	wr_reg_spi(3,0x1a7,0x00);
//channel 8 DAC_sysref
	wr_reg_spi(3,0x1a8,0x03);
	wr_reg_spi(3,0x1a9,0x7f);
	wr_reg_spi(3,0x1aa,0x00);
//channel 9 FMC_DAC_REF_CLK
	wr_reg_spi(3,0x1ab,0x03);
	wr_reg_spi(3,0x1ac,0x03);
	wr_reg_spi(3,0x1ad,0x00);
//channel 13 ADC_CLK
	wr_reg_spi(3,0x1b7,0x03);
	wr_reg_spi(3,0x1b8,0x00);
	wr_reg_spi(3,0x1b9,0x00);

	wr_reg_spi(3,0x1bb,0x00);

	wr_reg_spi(3,0x234,0x01);


    wr_reg_spi(3,0x233,0x00);
	wr_reg_spi(3,0x230,0x03);
	wr_reg_spi(3,0x231,0x03);
	wr_reg_spi(3,0x234,0x01);
	wr_reg_spi(3,0x0f3,0x08);
	wr_reg_spi(3,0x234,0x01);
	wr_reg_spi(3,0x0f3,0x0a);
	wr_reg_spi(3,0x234,0x01);

	return 0;
}
int cfg_spi(fd)
{
	//ioctl ( 5,0x86 );
	 *((uint32_t *)  map_base + (0x1060>>2) ) = 0x86;
usleep(100);

	return 0;

}
int cfg_DAC_JESD()
{
	unsigned long error;

	error=ioctl ( 6,0x86 );
	printf("DAC_JESD_core_error=%x \n",error);

	return 0;

}
int cfg_ADC_JESD()
{
	unsigned long error;
	error= ioctl ( 7,0x86 );
	printf("ADC_JESD_core_error=%x \n",error);
	return 0;

}
int cfg_DAC()
{
	wr_reg_spi(1,0x000, 0x81);	// reset
	wr_reg_spi(1,0x000, 0x00);	// reset


	wr_reg_spi(1,0x011, 0x00);	// dacs - power up everything
	wr_reg_spi(1,0x080, 0x00);	// clocks - power up everything
	wr_reg_spi(1,0x081, 0x00);	// sysref - power up/falling edge

	// required device configurations

	wr_reg_spi(1,0x12d, 0x8b);	// data-path
	wr_reg_spi(1,0x146, 0x01);	// data-path
  	wr_reg_spi(1,0x520, 0x1c);	// sysref-armed

	wr_reg_spi(1,0x040, 0x00);	// current
	wr_reg_spi(1,0x041, 0x02);	// 
  	wr_reg_spi(1,0x042, 0x00);	// 
  	wr_reg_spi(1,0x043, 0x02);	// 



 //    wr_reg_spi(1,0x146, 0x00);	// 
	// wr_reg_spi(1,0x520, 0x1e);	// 
	// wr_reg_spi(1,0x521, 0x00);	// 
	// wr_reg_spi(1,0x522, 0x00);	// 
	// wr_reg_spi(1,0x523, 0x00);	// 
	// wr_reg_spi(1,0x524, 0x00);	// 

	wr_reg_spi(1,0x2a4, 0xff);	// clock
	wr_reg_spi(1,0x1c4, 0x73);	// dac-pll
	wr_reg_spi(1,0x291, 0x49);	// serde-pll
	wr_reg_spi(1,0x29c, 0x24);	// serde-pll
	wr_reg_spi(1,0x29f, 0x73);	// serde-pll
	wr_reg_spi(1,0x232, 0xff);	// jesd
	wr_reg_spi(1,0x333, 0x01);	// jesd

	// digital data path

	wr_reg_spi(1,0x112, 0x00);	// 2x interpolation 
	wr_reg_spi(1,0x110, 0x00);	// 2's complement
	wr_reg_spi(1,0x111, 0xa0);	// fdac/4 modulation
	wr_reg_spi(1,0x13c, 0xff);	// I gain
	wr_reg_spi(1,0x13d, 0x07);	// I gain
	wr_reg_spi(1,0x13e, 0xff);	// Q gain
	wr_reg_spi(1,0x13f, 0x07);	// Q gain




	// transport layer

	wr_reg_spi(1,0x200, 0x00);	// phy - power up
	wr_reg_spi(1,0x201, 0x00);	// phy - power up
	wr_reg_spi(1,0x300, 0x01);	// single link - link 0
	wr_reg_spi(1,0x450, 0x00);	// device id (0x400)
	wr_reg_spi(1,0x451, 0x00);	// bank id (0x401)
	wr_reg_spi(1,0x452, 0x04);	// lane-id (0x402)
	wr_reg_spi(1,0x453, 0x83);	// descrambling, 4 lanes
	wr_reg_spi(1,0x454, 0x00);	// octects per frame per lane (1)
	wr_reg_spi(1,0x455, 0x1f);	// mult-frame - framecount (32)
	wr_reg_spi(1,0x456, 0x01);	// no-of-converters (2)
	wr_reg_spi(1,0x457, 0x0f);	// no CS bits, 16bit dac
	wr_reg_spi(1,0x458, 0x2f);	// subclass 1, 16bits per sample
	wr_reg_spi(1,0x459, 0x20);	// jesd204b, 1 samples per converter per device
	wr_reg_spi(1,0x45a, 0x0a);	// HD mode, no CS bits
	wr_reg_spi(1,0x45d, 0x49);	// check-sum of 0x450 to 0x45c
	wr_reg_spi(1,0x46c, 0x0f);	// enable deskew for all lanes
	wr_reg_spi(1,0x03a, 0xc1);	// sysref-armed
    wr_reg_spi(1,0x476, 0x01);	// frame - bytecount (1)
	wr_reg_spi(1,0x47d, 0x0f);	// enable all lanes

	// physical layer

	wr_reg_spi(1,0x2aa, 0xb7);	// jesd termination
	wr_reg_spi(1,0x2ab, 0x87);	// jesd termination
	wr_reg_spi(1,0x2b1, 0xb7);	// jesd termination
	wr_reg_spi(1,0x2b2, 0x87);	// jesd termination
	wr_reg_spi(1,0x2a7, 0x01);	// input termination calibration
	wr_reg_spi(1,0x2ae, 0x01);	// input termination calibration
	wr_reg_spi(1,0x314, 0x01);	// pclk == qbd master clock
	wr_reg_spi(1,0x230, 0x28);	// cdr mode - halfrate, no division
	wr_reg_spi(1,0x206, 0x00);	// cdr reset
	wr_reg_spi(1,0x206, 0x01);	// cdr reset
	wr_reg_spi(1,0x289, 0x04);	// data-rate == 10Gbps
	wr_reg_spi(1,0x280, 0x01);	// enable serdes pll
	wr_reg_spi(1,0x280, 0x05);	// enable serdes calibration


	wr_reg_spi(1,0x268, 0x62);	// equalizer

	// cross-bar

	wr_reg_spi(1,0x308,0x11);	// lane selects
	wr_reg_spi(1,0x309,0x03);	// lane selects

	// data link layer

	wr_reg_spi(1,0x301, 0x01);	// subclass-1
	wr_reg_spi(1,0x304, 0x00);	// lmfc delay
	wr_reg_spi(1,0x305, 0x00);	// lmfc delay
	wr_reg_spi(1,0x306, 0x0a);	// receive buffer delay
	wr_reg_spi(1,0x307, 0x0a);	// receive buffer delay
	wr_reg_spi(1,0x03a, 0x01);	// sync-oneshot mode
	wr_reg_spi(1,0x03a, 0x81);	// sync-enable
	wr_reg_spi(1,0x03a, 0xc1);	// sysref-armed
	wr_reg_spi(1,0x300, 0x01);	// enable link

	// dac calibration

	wr_reg_spi(1,0x0e7, 0x38);	// set calibration clock to 1m
	wr_reg_spi(1,0x0ed, 0xa6);	// use isb reference of 38 to set cal
	wr_reg_spi(1,0x0e8, 0x03);	// cal 2 dacs at once
	wr_reg_spi(1,0x0e9, 0x01);	// single cal enable
	wr_reg_spi(1,0x0e9, 0x03);	// single cal start


	wr_reg_spi(1,0x0e7, 0x30);	// turn off cal clock



	return 0;
}

int cfg_ADC()
{
	wr_reg_spi(2,0x000, 0x81);	// RESET
	wr_reg_spi(2,0x001, 0x02);	// RESET
	wr_reg_spi(2,0x008, 0x03);	// select both channels
	wr_reg_spi(2,0x03f, 0x80);	// disable powerdown
	wr_reg_spi(2,0x040, 0x8a);	// disable powerdown fda=LMFC output fdb=jesd sync
//	wr_reg_spi(2,0x040, 0x80);	// disable powerdown fda en fdb en
	wr_reg_spi(2,0x201, 0x00);	// full sample rate (decimation = 1)

//	wr_reg_spi(2,0x245, 0x0d);	// fda=fdb=1
//	wr_reg_spi(2,0x245, 0x09);	// fda=fdb=0
	wr_reg_spi(2,0x245, 0x01);	// fda=fdb normal

	wr_reg_spi(2,0x550, 0x00);	// test pattern off
//	wr_reg_spi(2,0x550, 0x02);	// test pattern full+
//	wr_reg_spi(2,0x550, 0x01);	// test pattern full-
//	wr_reg_spi(2,0x550, 0x07);	// test pattern 10101010
//	wr_reg_spi(2,0x550, 0x0f);	// test pattern=ramp

	wr_reg_spi(2,0x561, 0x01);	// twos complement
//	wr_reg_spi(2,0x561, 0x00);	// offset binary

	wr_reg_spi(2,0x570, 0x88);	// m=2, l=4, f= 1
	wr_reg_spi(2,0x571, 0x16);	// disable FACI

	wr_reg_spi(2,0x573, 0x00);	// jesd test pattern normal
//	wr_reg_spi(2,0x573, 0x07);	// jesd test pattern ramp
//	wr_reg_spi(2,0x573, 0x02);	// jesd test pattern 1010


	wr_reg_spi(2,0x58f, 0x0d);	// 14-bit
	wr_reg_spi(2,0x58d, 0x1f);	// 14-bit
	wr_reg_spi(2,0x5b2, 0x33);	// serdes-0 = lane 3
	wr_reg_spi(2,0x5b3, 0x00);	// serdes-1 = lane 0
	wr_reg_spi(2,0x5b5, 0x22);	// serdes-2 = lane 2
	wr_reg_spi(2,0x5b6, 0x11);	// serdes-3 = lane 1
	return 0;
}

//int write_gpio1(int bit,int val)
//{
//	char val_gpio1;
//	val_gpio1 = ioctl ( 8,0);
//	printf("Read:%x, write %x \n",val_gpio1,val_gpio1 | (1<<bit));
//	if (val) ioctl ( 1, val_gpio1 | (1<<bit));
//	else ioctl ( 1, val_gpio1 & (~(1<<bit)));
//	return (0);
//}




int status()
{
	char val;
	val = *((uint32_t *)  map_base + (4) );
	printf("clk_locked=%x\n",val);

	val = *((uint32_t *)  map_base + (5) );
	printf("{tx,rx}_rst_done=%x\n",val);
	
	val = *((uint32_t *)  map_base + (6) );
	printf("clk_status=%x\n",val);

	val = *((uint32_t *)  map_base + (7) );
	printf("adc_status=%x\n",val);	

	val = *((uint32_t *)  map_base + (8) );
	printf("dac_irq=%x\n",val);

	val = *((uint32_t *)  map_base + (20) );
	printf("LED=%x\n",val);



	return 0;
}

int main()
{
	fd = open("/dev/xdma0_user",O_RDWR | O_SYNC);
	if (fd <0)
	{
		perror("Open Dev Error:");
	}
	map_base = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd,  0);
	*((uint32_t *)  map_base + (24) ) = 0x0; //ADC_PD_n=0
		*((uint32_t *)  map_base + (23) ) = 0x0; //DAC_rstn=0
		*((uint32_t *)  map_base + (23) ) = 0x1; //DAC_rstn=1
    *((uint32_t *)  map_base + (22) ) = 0x1; //TXEN

    cfg_CLK();
    usleep(1000);
    *((uint32_t *)  map_base + (21) ) = 0x1; //clk_d_sync=1    
    usleep(1000);
    *((uint32_t *)  map_base + (16) ) = 0x1; //tx_rst=1
    *((uint32_t *)  map_base + (19) ) = 0x1; //tx_sys_rst=1
    *((uint32_t *)  map_base + (17) ) = 0x1; //rx_rst=1
    *((uint32_t *)  map_base + (18) ) = 0x1; //rx_sys_rst=1
    usleep(1000);

    cfg_DAC();
    usleep(1000);
    cfg_ADC();
    usleep(1000);
        *((uint32_t *)  map_base + (16) ) = 0x0; //tx_rst=0
    *((uint32_t *)  map_base + (19) ) = 0x0; //tx_sys_rst=0
    usleep(1000);
    *((uint32_t *)  map_base + (17) ) = 0x0; //rx_rst=0
    *((uint32_t *)  map_base + (18) ) = 0x0; //rx_sys_rst=0
    usleep(1000);
    *((uint32_t *)  map_base + (20) ) = 0x1; //LED    

    status();    

    close(fd);
    return 0;

}
