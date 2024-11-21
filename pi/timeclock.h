#include <time.h>

#define CLOCK_ID	CLOCK_MONOTONIC
//#define CLOCK_ID	CLOCK_REALTIME

static inline double time_as_double(void)
{
	double restime;
	struct timespec ts = { 0 };

	clock_gettime(CLOCK_ID, &ts);

	restime = (double)ts.tv_sec;
	restime += (double)ts.tv_nsec * 1.0e-9;

	return restime;
}